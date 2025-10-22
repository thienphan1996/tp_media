import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tp_media/network/internet_manager.dart';

class OpenAdLifecycleReactor {
  final AdmobOpenAd appOpenAdManager;

  OpenAdLifecycleReactor({required this.appOpenAdManager});

  void listenToAppStateChanges() {
    AppStateEventNotifier.startListening();
    AppStateEventNotifier.appStateStream.forEach((state) => _onAppStateChanged(state));
  }

  void _onAppStateChanged(AppState appState) {
    // Try to show an app open ad if the app is being resumed and
    // we're not already showing an app open ad.
    debugPrint('New AppState mixin: $appState');
    if (appState == AppState.foreground) {
      appOpenAdManager.showAdIfAvailable();
    }
  }
}

/// Utility class that manages loading and showing app open ads.
class AdmobOpenAd {
  AdmobOpenAd(this.adUnitId, {this.isEnableAd});

  final String adUnitId;

  final bool Function()? isEnableAd;

  /// Maximum duration allowed between loading and showing the ad.
  final Duration maxCacheDuration = Duration(hours: 4);

  /// Keep track of load time so we don't show an expired ad.
  DateTime? _appOpenLoadTime;

  AppOpenAd? _appOpenAd;

  bool _isShowingAd = false;

  bool _isLoadingAd = false;

  bool get isAdAvailable {
    return _appOpenAd != null;
  }

  bool get _isEnableAd {
    return isEnableAd?.call() ?? true;
  }

  /// Load an AppOpenAd.
  void loadAd() async {
    if (!_isEnableAd || await InternetManager.instance.isOnline == false) {
      return;
    }

    _isLoadingAd = true;

    AppOpenAd.load(
      adUnitId: adUnitId,
      request: AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('$ad loaded');
          _appOpenLoadTime = DateTime.now();
          _appOpenAd = ad;
          _isLoadingAd = false;
        },
        onAdFailedToLoad: (error) {
          debugPrint('AppOpenAd failed to load: $error');
          _isLoadingAd = false;
        },
      ),
    );
  }

  /// Shows the ad, if one exists and is not already being shown.
  ///
  /// If the previously cached ad has expired, this just loads and caches a
  /// new ad.
  void showAdIfAvailable({VoidCallback? onDismiss}) {
    if (!_isEnableAd || _isLoadingAd) {
      return;
    }
    if (!isAdAvailable) {
      debugPrint('Tried to show ad before available.');
      loadAd();
      return;
    }
    if (_isShowingAd) {
      debugPrint('Tried to show ad while already showing an ad.');
      return;
    }
    if (DateTime.now().subtract(maxCacheDuration).isAfter(_appOpenLoadTime!)) {
      debugPrint('Maximum cache duration exceeded. Loading another ad.');
      _appOpenAd?.dispose();
      _appOpenAd = null;
      loadAd();
      return;
    }

    _appOpenAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAd = true;
        debugPrint('$ad onAdShowedFullScreenContent');
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('$ad onAdFailedToShowFullScreenContent: $error');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
      },
      onAdDismissedFullScreenContent: (ad) {
        debugPrint('$ad onAdDismissedFullScreenContent');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAd();
        onDismiss?.call();
      },
    );
    _appOpenAd?.show();
  }
}
