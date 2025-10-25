import 'dart:io';

import 'package:example/iap/test_iap_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tp_media/tp_media.dart';

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

  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
  late OpenAdLifecycleReactor _appLifecycleReactor;
  late AdmobOpenAd _appOpenAdManager;
  var _adReady = false;
  late final Future initFuture;

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
  bool get isEnableAd => !TestIapManager.instance.isSubscribed;

  @override
  void initState() {
    initFuture = _initApp();
    super.initState();
  }

  Future<void> _initApp() async {
    final isIapSubscribed = await IapInitializer.init(
      [TestIapManager.instance],
      androidApiKey: 'test_ISWQvtVjQVYMyJrPXVqZFabZTaT',
      iosApiKey: '',
    );

    if (!isIapSubscribed) {
      await _initAdmob();
    }

    setState(() {
      _adReady = true;
    });
  }

  Future<void> _initAdmob() async {
    await AdmobInitializer.init(context, trackingTransparencyDialog(context));

    _appOpenAdManager = AdmobOpenAd(openAdUnitId, isEnableAd: () => !TestIapManager.instance.isSubscribed);
    _appOpenAdManager.loadAd();
    _appLifecycleReactor = OpenAdLifecycleReactor(appOpenAdManager: _appOpenAdManager);
    _appLifecycleReactor.listenToAppStateChanges();
  }

  void _incrementCounter() {
    loadAndShowRewardAd();
  }

  @override
  String interstitialUnitId = kTestAndroidInterstitialId;

  @override
  String rewardedUnitId = kTestAndroidRewardedAdId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initFuture,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (!_adReady) {
          return Container(
            color: Colors.white,
            child: Dialog(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor)),
                ),
              ),
            ),
          );
        }

        return SafeArea(
          child: Scaffold(
            appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text(widget.title)),
            body: TopRoundedContainer(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    AdmobBannerAd(kTestAndroidBannerId, isEnableAd: !TestIapManager.instance.isSubscribed),
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
                          CommonCard(
                            child: PremiumUser(
                              text: 'Hello Premium User',
                              title: 'Have a good day',
                              isPremiumUser: TestIapManager.instance.isSubscribed,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AdmobBannerAd(kTestAndroidBannerId, isEnableAd: !TestIapManager.instance.isSubscribed),
                    InternetChecker(message: 'No internet connection.', child: Text('Has internet!')),
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
      },
    );
  }
}
