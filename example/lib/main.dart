import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tp_media/tp_media.dart';
import 'package:tp_media/widget/top_rounded_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  await IapInitializer.init('test_EnWFkUuxBGEPZuJqCwnjCvVxfHI', 'appl_wWfNUKEQdfXNCXBpbZFJLtpTTrI');

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late OpenAdLifecycleReactor _appLifecycleReactor;
  late OpenAdManager _appOpenAdManager;

  String get openAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/9257395921';
    }
    return '';
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await AdsManager.init(context);

      _appOpenAdManager = OpenAdManager(openAdUnitId);
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
    // showAlertDialog(
    //   context,
    //   title: 'Thien Test',
    //   message: 'Hello xin chao cac ban',
    //   okText: 'OK',
    //   cancelText: 'CANCEL',
    //   onOkButton: () {},
    // );
    // ToastUtils.failed('hihihi');
    // PremiumManager().presentPaywall('Premium');
  }

  @override
  String interstitialUnitId = 'ca-app-pub-3940256099942544/1033173712';

  @override
  String rewardedUnitId = 'ca-app-pub-3940256099942544/5224354917';

  @override
  void initState() {
    AppBannerAd.isTestMode = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text(widget.title)),
      body: TopRoundedContainer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppBannerAd('ca-app-pub-3940256099942544/9214589741'),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CommonCard(child: CommonEmpty(emptyMessage: 'Test message')),
                    SizedBox(height: 16),
                    CommonTextButton(text: 'Test', onPressed: () {}),
                    SizedBox(height: 16),
                    CommonTextField(labelText: 'Hihi haha'),
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
    );
  }
}
