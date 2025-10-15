import 'dart:io';

import 'package:example/iap/test_iap_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tp_media/tp_media.dart';
import 'package:tp_media/widget/top_rounded_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  await IapInitializer.init(androidApiKey: 'test_ISWQvtVjQVYMyJrPXVqZFabZTaT', iosApiKey: '');
  await IapInitializer.initIapManagers([TestIapManager.instance]);

  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late OpenAdLifecycleReactor _appLifecycleReactor;
  late AdmobOpenAd _appOpenAdManager;

  Widget trackingTransparencyDialog(BuildContext context) {
    return buildTrackingTransparencyDialog(
      context,
      title: 'Test title',
      message: 'Message example',
      continueButton: 'Continue',
    );
  }

  String get openAdUnitId {
    if (Platform.isAndroid) {
      return kTestAndroidOpenAdId;
    }
    return '';
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await AdmobInitializer.init(context, trackingTransparencyDialog(context));

      _appOpenAdManager = AdmobOpenAd(openAdUnitId);
      _appLifecycleReactor = OpenAdLifecycleReactor(appOpenAdManager: _appOpenAdManager);
      _appLifecycleReactor.listenToAppStateChanges();
      _appOpenAdManager.loadAd();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends LoadingDialogState<MyHomePage> with InterstitialAdMixin, RewardedAdMixin {
  void _incrementCounter() {
    TestIapManager.instance.presentPaywallIfNeeded();
  }

  @override
  String interstitialUnitId = kTestAndroidInterstitialId;

  @override
  String rewardedUnitId = kTestAndroidRewardedAdId;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text(widget.title)),
        body: TopRoundedContainer(
          child: SingleChildScrollView(
            child: Column(
              children: [
                AdmobBannerAd(kTestAndroidBannerId),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CommonCard(child: CommonEmpty(emptyMessage: 'Test message')),
                      SizedBox(height: 16),
                      CommonTextButton(text: 'Test', onPressed: () {}),
                      SizedBox(height: 16),
                      CommonTextField(labelText: 'Testing field'),
                      SizedBox(height: 16),
                      CommonIconButton(icon: Icons.add_circle_outlined, onPressed: () {}),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
