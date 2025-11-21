import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tp_media/ads/admob_enable.dart';
import 'package:tp_media/network/internet_manager.dart';
import 'package:tp_media/state/loading_dialog_state.dart';

mixin InterstitialAdMixin<T extends StatefulWidget> on State<T> implements AdmobEnable {
  InterstitialAd? _interstitialAd;
  bool _isLoadingInterstitialAd = false;

  abstract String interstitialUnitId;

  void loadAd() async {
    if (!isEnableAd || await InternetManager.instance.isOnline == false) {
      return;
    }

    if (!_isLoadingInterstitialAd && _interstitialAd == null) {
      _isLoadingInterstitialAd = true;
      InterstitialAd.load(
        adUnitId: interstitialUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            _interstitialAd = ad;
            _isLoadingInterstitialAd = false;
          },
          onAdFailedToLoad: (LoadAdError error) {
            _isLoadingInterstitialAd = false;
          },
        ),
      );
    }
  }

  void loadAndShowAd({VoidCallback? onDismissAd}) async {
    if (!isEnableAd || await InternetManager.instance.isOnline == false) {
      onDismissAd?.call();
      return;
    }

    if (!_isLoadingInterstitialAd && _interstitialAd != null) {
      showAd(onDismissAd: onDismissAd);
      return;
    }

    if (!_isLoadingInterstitialAd && _interstitialAd == null && mounted) {
      _isLoadingInterstitialAd = true;
      showDialogLoading(context);
      InterstitialAd.load(
        adUnitId: interstitialUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            _interstitialAd = ad;
            hideInterstitialLoading();
            showAd(onDismissAd: onDismissAd);
          },
          onAdFailedToLoad: (LoadAdError error) {
            hideInterstitialLoading();
            loadAd();
            onDismissAd?.call();
          },
        ),
      );
    }
  }

  void hideInterstitialLoading() {
    if (_isLoadingInterstitialAd) {
      _isLoadingInterstitialAd = false;
      Navigator.pop(context);
    }
  }

  void showAd({VoidCallback? onDismissAd}) {
    if (!isEnableAd || _isLoadingInterstitialAd) {
      return;
    }

    if (_interstitialAd != null) {
      _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          disposeAd();
          loadAd();
          onDismissAd?.call();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          disposeAd();
          loadAd();
          onDismissAd?.call();
        },
      );
      _interstitialAd?.show();
    } else {
      loadAd();
      onDismissAd?.call();
    }
  }

  void disposeAd() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
  }

  @override
  void dispose() {
    disposeAd();
    super.dispose();
  }
}
