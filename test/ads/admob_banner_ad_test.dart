import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_mobile_ads/src/ad_instance_manager.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:tp_media/ads/admob_banner_ad.dart';

void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();
  final calls = <MethodCall>[];
  Future<int?> Function(MethodCall)? sizeLookup;

  List<MethodCall> loads() =>
      calls.where((call) => call.method == 'loadBannerAd').toList();
  BannerAd adFor(MethodCall call) =>
      instanceManager.adFor(call.arguments['adId'])! as BannerAd;

  Widget host({
    double width = 320,
    String unitId = 'banner-a',
    bool enabled = true,
    EdgeInsets viewInsets = EdgeInsets.zero,
    Size screenSize = const Size(800, 1000),
  }) => MaterialApp(
    home: MediaQuery(
      data: MediaQueryData(size: screenSize, viewInsets: viewInsets),
      child: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: width,
          child: AdmobBannerAd(unitId, isEnableAd: enabled),
        ),
      ),
    ),
  );

  setUp(() {
    calls.clear();
    sizeLookup = null;
    AdmobBannerAd.isTestMode = false;
    binding.defaultBinaryMessenger.setMockMethodCallHandler(
      instanceManager.channel,
      (call) async {
        calls.add(call);
        if (call.method == 'AdSize#getLargeAnchoredAdaptiveBannerAdSize') {
          return sizeLookup == null ? 50 : await sizeLookup!(call);
        }
        return null;
      },
    );
    binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform_views,
      (call) async {
        if (call.method == 'create') return 0;
        if (call.method == 'resize') {
          return {
            'width': call.arguments['width'],
            'height': call.arguments['height'],
          };
        }
        return null;
      },
    );
    binding.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('dev.fluttercommunity.plus/connectivity_status'),
      (_) async => null,
    );
  });

  tearDown(() {
    AdmobBannerAd.isTestMode = false;
    binding.defaultBinaryMessenger.setMockMethodCallHandler(
      instanceManager.channel,
      null,
    );
    binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform_views,
      null,
    );
    binding.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('dev.fluttercommunity.plus/connectivity_status'),
      null,
    );
  });

  testWidgets(
    'uses slot width and reuses the loaded ad on unrelated rebuilds',
    (tester) async {
      await tester.pumpWidget(host());
      await tester.pump();
      expect(loads(), hasLength(1));
      final sizeCall = calls.firstWhere(
        (call) => call.method == 'AdSize#getLargeAnchoredAdaptiveBannerAdSize',
      );
      expect(sizeCall.arguments['width'], 320);
      final ad = adFor(loads().single);
      ad.listener.onAdLoaded!(ad);
      await tester.pump();

      await tester.pumpWidget(
        host(viewInsets: const EdgeInsets.only(bottom: 300)),
      );
      await tester.pump();
      expect(loads(), hasLength(1));
      expect(tester.widget<AdWidget>(find.byType(AdWidget)).ad, same(ad));
      ad.listener.onAdFailedToLoad!(
        ad,
        LoadAdError(2, 'test', 'Refresh failed', null),
      );
      await tester.pump(const Duration(minutes: 3));
      expect(loads(), hasLength(1));
      expect(tester.widget<AdWidget>(find.byType(AdWidget)).ad, same(ad));
      final adId = loads().single.arguments['adId'] as int;
      await tester.pumpWidget(const SizedBox());
      expect(instanceManager.isWidgetAdIdMounted(adId), isFalse);
      expect(instanceManager.adFor(adId), isNull);
    },
  );

  testWidgets('disposes on disable and loads the new unit when enabled', (
    tester,
  ) async {
    await tester.pumpWidget(host());
    await tester.pump();
    final firstId = loads().single.arguments['adId'];
    final oldAd = adFor(loads().single);

    await tester.pumpWidget(host(enabled: false));
    await tester.pump();
    expect(instanceManager.adFor(firstId), isNull);
    oldAd.listener.onAdLoaded!(oldAd);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(host(unitId: 'banner-b'));
    await tester.pump();
    expect(loads(), hasLength(2));
    expect(loads().last.arguments['adUnitId'], 'banner-b');
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('replaces the ad when ID, width, or orientation changes', (
    tester,
  ) async {
    await tester.pumpWidget(host());
    await tester.pump();
    final oldAd = adFor(loads().single);
    await tester.pumpWidget(host(unitId: 'banner-b'));
    await tester.pump();
    await tester.pumpWidget(host(unitId: 'banner-b', width: 280));
    await tester.pump();
    await tester.pumpWidget(
      host(unitId: 'banner-b', width: 280, screenSize: const Size(1000, 800)),
    );
    await tester.pump();
    oldAd.listener.onAdLoaded!(oldAd);
    expect(loads(), hasLength(4));
    expect((loads().last.arguments['size'] as AdSize).width, 280);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('does not create an ad after disposal during size lookup', (
    tester,
  ) async {
    final size = Completer<int?>();
    sizeLookup = (_) => size.future;
    await tester.pumpWidget(host());
    await tester.pumpWidget(const SizedBox());
    size.complete(50);
    await tester.pump();
    expect(loads(), isEmpty);
    expect(tester.takeException(), isNull);
  });

  testWidgets('ignores obsolete size results after resizing', (tester) async {
    final oldSize = Completer<int?>();
    sizeLookup = (call) async =>
        call.arguments['width'] == 320 ? await oldSize.future : 50;
    await tester.pumpWidget(host());
    await tester.pumpWidget(host(width: 280));
    await tester.pump();
    oldSize.complete(50);
    await tester.pump();
    expect(loads(), hasLength(1));
    expect((loads().single.arguments['size'] as AdSize).width, 280);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('screenshot mode displays an image without an ad request', (
    tester,
  ) async {
    AdmobBannerAd.isTestMode = true;
    await tester.pumpWidget(host());
    await tester.pump();
    expect(find.byType(Image), findsOneWidget);
    expect(calls, isEmpty);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('bounds retries and increases the delay after each failure', (
    tester,
  ) async {
    await http.runWithClient(() async {
      await tester.pumpWidget(host());
      await tester.pump();
      for (var retry = 0; retry < 5; retry++) {
        final ad = adFor(loads().last);
        ad.listener.onAdFailedToLoad!(
          ad,
          LoadAdError(2, 'test', 'Network error', null),
        );
        await tester.pump();
        expect(instanceManager.adIdFor(ad), isNull);
        final delay = Duration(seconds: 5 * (1 << retry));
        await tester.pump(delay - const Duration(milliseconds: 1));
        expect(loads(), hasLength(retry + 1));
        await tester.pump(const Duration(milliseconds: 1));
        await tester.pump();
        expect(loads(), hasLength(retry + 2));
      }
      final ad = adFor(loads().last);
      ad.listener.onAdFailedToLoad!(
        ad,
        LoadAdError(2, 'test', 'Network error', null),
      );
      await tester.pump(const Duration(minutes: 3));
      expect(loads(), hasLength(6));
      await tester.pumpWidget(const SizedBox());
      await tester.pump();
    }, () => MockClient((_) async => http.Response('', 200)));
  });

  testWidgets('pauses failed retries in background and retries on resume', (
    tester,
  ) async {
    await http.runWithClient(() async {
      await tester.pumpWidget(host());
      await tester.pump();
      final ad = adFor(loads().single);
      ad.listener.onAdFailedToLoad!(
        ad,
        LoadAdError(2, 'test', 'Network error', null),
      );
      await tester.pump();
      binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      try {
        await tester.pump(const Duration(seconds: 30));
        expect(loads(), hasLength(1));
        binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
        await tester.pump();
        expect(loads(), hasLength(2));
      } finally {
        await tester.pumpWidget(const SizedBox());
        binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
        await tester.pump();
      }
    }, () => MockClient((_) async => http.Response('', 200)));
  });

  testWidgets('waits offline and retries when connectivity returns', (
    tester,
  ) async {
    var online = false;
    await http.runWithClient(() async {
      await tester.pumpWidget(host());
      await tester.pump();
      final ad = adFor(loads().single);
      ad.listener.onAdFailedToLoad!(
        ad,
        LoadAdError(2, 'test', 'Offline', null),
      );
      await tester.pump();
      await tester.pump(const Duration(seconds: 20));
      expect(loads(), hasLength(1));
      online = true;
      await tester.pump(const Duration(seconds: 10));
      await tester.pump();
      expect(loads(), hasLength(2));
      await tester.pumpWidget(const SizedBox());
      await tester.pump();
    }, () => MockClient((_) async => http.Response('', online ? 200 : 503)));
  });
}
