import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tp_media/state/loading_dialog_state.dart';

mixin InterstitialAdMixin<T extends StatefulWidget> on LoadingDialogState<T> {
  InterstitialAd? _interstitialAd;
  bool _isLoadingAd = false;

  abstract String interstitialUnitId;

  void loadAd() {
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

  void loadAndShowAd({VoidCallback? onDismissAd}) {
    if (!_isLoadingAd && _interstitialAd != null) {
      showAd(onDismissAd: onDismissAd);
      return;
    }

    if (!_isLoadingAd && _interstitialAd == null) {
      _isLoadingAd = true;
      showLoading();
      InterstitialAd.load(
        adUnitId: interstitialUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            _interstitialAd = ad;
            _isLoadingAd = false;
            hideLoading();
            showAd(onDismissAd: onDismissAd);
          },
          onAdFailedToLoad: (LoadAdError error) {
            _isLoadingAd = false;
            onDismissAd?.call();
            hideLoading();
            loadAd();
          },
        ),
      );
    }
  }

  void showAd({VoidCallback? onDismissAd}) {
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
