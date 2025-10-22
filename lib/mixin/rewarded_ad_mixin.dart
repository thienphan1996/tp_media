import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tp_media/ads/admob_enable.dart';
import 'package:tp_media/network/internet_manager.dart';
import 'package:tp_media/state/loading_dialog_state.dart';

mixin RewardedAdMixin<T extends StatefulWidget> on State<T> implements AdmobEnable {
  RewardedAd? _rewardedAd;
  bool _isLoadingAd = false;

  abstract String rewardedUnitId;

  void loadAndShowRewardAd({Function(RewardItem)? onRewarded, VoidCallback? onDismiss}) async {
    if (!isEnableAd || await InternetManager.instance.isOnline == false) {
      onDismiss?.call();
      return;
    }

    if (!mounted) {
      return;
    }

    _rewardedAd?.dispose();
    _rewardedAd = null;
    _isLoadingAd = true;

    showLoadingDialog(context);

    RewardedAd.load(
      adUnitId: rewardedUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          // Called when an ad is successfully received.
          debugPrint('Ad was loaded.');
          // Keep a reference to the ad so you can show it later.
          _rewardedAd = ad;

          hideLoadingDialog();
          showRewardAd(onRewarded: onRewarded, onDismiss: onDismiss);
        },
        onAdFailedToLoad: (LoadAdError error) {
          // Called when an ad request failed.
          debugPrint('Ad failed to load with error: $error');

          hideLoadingDialog();
          onDismiss?.call();
        },
      ),
    );
  }

  void hideLoadingDialog() {
    if (_isLoadingAd) {
      _isLoadingAd = false;
      Navigator.pop(context);
    }
  }

  void showRewardAd({Function(RewardItem)? onRewarded, VoidCallback? onDismiss}) {
    if (!isEnableAd || _isLoadingAd) {
      return;
    }

    if (_rewardedAd != null) {
      _rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
        onAdFailedToShowFullScreenContent: (ad, err) {
          // Called when the ad failed to show full screen content.
          debugPrint('Ad failed to show full screen content with error: $err');
          // Dispose the ad here to free resources.
          ad.dispose();
          onDismiss?.call();
        },
        onAdDismissedFullScreenContent: (ad) {
          // Called when the ad dismissed full screen content.
          debugPrint('Ad was dismissed.');
          // Dispose the ad here to free resources.
          ad.dispose();
          onDismiss?.call();
        },
      );
      _rewardedAd?.show(
        onUserEarnedReward: (_, item) {
          onRewarded?.call(item);
        },
      );
    } else {
      loadAndShowRewardAd();
      onDismiss?.call();
    }
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    super.dispose();
  }
}
