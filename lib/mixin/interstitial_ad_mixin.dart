import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tp_media/ads/admob_enable.dart';
import 'package:tp_media/network/internet_manager.dart';
import 'package:tp_media/state/loading_dialog_state.dart';

mixin InterstitialAdMixin<T extends StatefulWidget> on State<T>
    implements AdmobEnable {
  InterstitialAd? _interstitialAd;
  bool _isLoadingInterstitialAd = false;
  bool _isShowingDialog = false;
  Completer<void>? _loadingCompleter;
  int _retryCount = 0;

  abstract String interstitialUnitId;

  void loadAd() async {
    if (!isEnableAd || await InternetManager.instance.isOnline == false) {
      return;
    }

    if (!_isLoadingInterstitialAd && _interstitialAd == null) {
      _isLoadingInterstitialAd = true;
      _loadingCompleter = Completer<void>();
      InterstitialAd.load(
        adUnitId: interstitialUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            _retryCount = 0;
            _interstitialAd = ad;
            hideInterstitialLoading();
          },
          onAdFailedToLoad: (LoadAdError error) {
            hideInterstitialLoading();
            if (_retryCount < 5) {
              _retryCount++;
              loadAd();
            }
          },
        ),
      );
    }
  }

  void loadAndShowAd({VoidCallback? onDismiss}) async {
    if (!isEnableAd || await InternetManager.instance.isOnline == false) {
      onDismiss?.call();
      return;
    }

    if (_interstitialAd != null) {
      showAd(onDismissAd: onDismiss);
      return;
    }

    if (_isLoadingInterstitialAd) {
      if (!_isShowingDialog && mounted) {
        _isShowingDialog = true;
        showDialogLoading(context);
      }
      await _loadingCompleter?.future;
      showAd(onDismissAd: onDismiss);
      return;
    }

    if (_interstitialAd == null && mounted) {
      _isLoadingInterstitialAd = true;
      _loadingCompleter = Completer<void>();
      _isShowingDialog = true;
      showDialogLoading(context);
      InterstitialAd.load(
        adUnitId: interstitialUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            _retryCount = 0;
            _interstitialAd = ad;
            hideInterstitialLoading();
            showAd(onDismissAd: onDismiss);
          },
          onAdFailedToLoad: (LoadAdError error) {
            hideInterstitialLoading();
            if (_retryCount < 5) {
              _retryCount++;
              loadAd();
            }
            onDismiss?.call();
          },
        ),
      );
    }
  }

  void hideInterstitialLoading() {
    if (_isLoadingInterstitialAd) {
      _isLoadingInterstitialAd = false;
      _loadingCompleter?.complete();
      _loadingCompleter = null;
    }
    if (_isShowingDialog && mounted) {
      _isShowingDialog = false;
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
