import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tp_media/ads/admob_enable.dart';
import 'package:tp_media/network/internet_manager.dart';
import 'package:tp_media/state/loading_dialog_state.dart';

mixin RewardedAdMixin<T extends StatefulWidget> on State<T>
    implements AdmobEnable {
  RewardedAd? _rewardedAd;
  bool _isLoadingRewardedAd = false;
  bool _isShowingDialog = false;
  Completer<void>? _loadingCompleter;
  int _retryCount = 0;

  abstract String rewardedUnitId;

  void loadRewardAd() async {
    if (!isEnableAd || await InternetManager.instance.isOnline == false) {
      return;
    }

    if (!_isLoadingRewardedAd && _rewardedAd == null) {
      _isLoadingRewardedAd = true;
      _loadingCompleter = Completer<void>();
      RewardedAd.load(
        adUnitId: rewardedUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            _retryCount = 0;
            _rewardedAd = ad;
            hideRewardedLoading();
          },
          onAdFailedToLoad: (LoadAdError error) {
            hideRewardedLoading();
            if (_retryCount < 5) {
              _retryCount++;
              loadRewardAd();
            }
          },
        ),
      );
    }
  }

  void loadAndShowRewardAd({
    Function(RewardItem)? onRewarded,
    VoidCallback? onDismiss,
  }) async {
    if (!isEnableAd || await InternetManager.instance.isOnline == false) {
      onDismiss?.call();
      return;
    }

    if (_rewardedAd != null) {
      showRewardAd(onRewarded: onRewarded, onDismiss: onDismiss);
      return;
    }

    if (_isLoadingRewardedAd) {
      if (!_isShowingDialog && mounted) {
        _isShowingDialog = true;
        showDialogLoading(context);
      }
      await _loadingCompleter?.future;
      showRewardAd(onRewarded: onRewarded, onDismiss: onDismiss);
      return;
    }

    if (_rewardedAd == null && mounted) {
      _isLoadingRewardedAd = true;
      _loadingCompleter = Completer<void>();
      _isShowingDialog = true;
      showDialogLoading(context);

      RewardedAd.load(
        adUnitId: rewardedUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            _retryCount = 0;
            _rewardedAd = ad;
            hideRewardedLoading();
            showRewardAd(onRewarded: onRewarded, onDismiss: onDismiss);
          },
          onAdFailedToLoad: (LoadAdError error) {
            hideRewardedLoading();
            if (_retryCount < 5) {
              _retryCount++;
              loadRewardAd();
            }
            onDismiss?.call();
          },
        ),
      );
    }
  }

  void hideRewardedLoading() {
    if (_isLoadingRewardedAd) {
      _isLoadingRewardedAd = false;
      _loadingCompleter?.complete();
      _loadingCompleter = null;
    }
    if (_isShowingDialog && mounted) {
      _isShowingDialog = false;
      Navigator.pop(context);
    }
  }

  void showRewardAd({
    Function(RewardItem)? onRewarded,
    VoidCallback? onDismiss,
  }) {
    if (!isEnableAd || _isLoadingRewardedAd) {
      return;
    }

    if (_rewardedAd != null) {
      _rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
        onAdFailedToShowFullScreenContent: (ad, err) {
          disposeAd();
          loadRewardAd();
          onDismiss?.call();
        },
        onAdDismissedFullScreenContent: (ad) {
          disposeAd();
          onDismiss?.call();
        },
      );
      _rewardedAd?.show(
        onUserEarnedReward: (_, item) {
          onRewarded?.call(item);
        },
      );
    } else {
      loadRewardAd();
      onDismiss?.call();
    }
  }

  void disposeAd() {
    _rewardedAd?.dispose();
    _rewardedAd = null;
  }

  @override
  void dispose() {
    disposeAd();
    super.dispose();
  }
}
