import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_mobile_ads/src/ad_instance_manager.dart';
import 'package:tp_media/ads/admob_initializer.dart';

void main() {
  testWidgets('waits for test device configuration before SDK initialization', (
    tester,
  ) async {
    final configurationApplied = Completer<void>();
    final calls = <String>[];
    final messenger = tester.binding.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(instanceManager.channel, (call) async {
      if (call.method.startsWith('MobileAds#')) {
        calls.add(call.method);
      }
      switch (call.method) {
        case 'MobileAds#updateRequestConfiguration':
          expect(call.arguments['testDeviceIds'], ['test-device']);
          await configurationApplied.future;
          return null;
        case 'MobileAds#initialize':
          return InitializationStatus({});
        default:
          return null;
      }
    });
    addTearDown(() {
      messenger.setMockMethodCallHandler(instanceManager.channel, null);
    });

    await tester.pumpWidget(const SizedBox());
    final initialization = AdmobInitializer.init(
      tester.element(find.byType(SizedBox)),
      const SizedBox(),
      testDeviceIds: ['test-device'],
    );
    await tester.pump();

    expect(calls, ['MobileAds#updateRequestConfiguration']);
    configurationApplied.complete();
    await tester.pump();
    final status = await initialization;

    expect(calls, [
      'MobileAds#updateRequestConfiguration',
      'MobileAds#initialize',
    ]);
    expect(status.adapterStatuses, isEmpty);
  });
}
