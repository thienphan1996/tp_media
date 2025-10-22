import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tp_media/ads/admob_enable.dart';
import 'package:tp_media/network/internet_manager.dart';
import 'package:tp_media/state/loading_dialog_state.dart';

mixin InterstitialAdMixin<T extends StatefulWidget> on State<T> implements AdmobEnable {
  InterstitialAd? _interstitialAd;
  bool _isLoadingAd = false;

  abstract String interstitialUnitId;

  void loadAd() async {
    if (!isEnableAd || await InternetManager.instance.isOnline == false) {
      return;
    }

    if (!_isLoadingAd && _interstitialAd == null) {
      _isLoadingAd = true;
      InterstitialAd.load(
        adUnitId: interstitialUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            _interstitialAd = ad;
            _isLoadingAd = false;
          },
          onAdFailedToLoad: (LoadAdError error) {
            _isLoadingAd = false;
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

    if (!_isLoadingAd && _interstitialAd != null) {
      showAd(onDismissAd: onDismissAd);
      return;
    }

    if (!_isLoadingAd && _interstitialAd == null && mounted) {
      _isLoadingAd = true;
      showLoadingDialog(context);
      InterstitialAd.load(
        adUnitId: interstitialUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            _interstitialAd = ad;
            hideLoadingDialog();
            showAd(onDismissAd: onDismissAd);
          },
          onAdFailedToLoad: (LoadAdError error) {
            onDismissAd?.call();
            hideLoadingDialog();
            loadAd();
          },
        ),
      );
    }
  }

  void hideLoadingDialog() {
    if (_isLoadingAd) {
      _isLoadingAd = false;
      Navigator.pop(context);
    }
  }

  void showAd({VoidCallback? onDismissAd}) {
    if (!isEnableAd || _isLoadingAd) {
      return;
    }

    if (_interstitialAd != null) {
      _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          onDismissAd?.call();
          disposeAd();
          loadAd();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          onDismissAd?.call();
          disposeAd();
          loadAd();
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
