import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tp_media/state/loading_dialog_state.dart';

mixin RewardedAdMixin<T extends StatefulWidget> on LoadingDialogState<T> {
  RewardedAd? _rewardedAd;

  abstract String rewardedUnitId;

  void loadAndShowRewardAd({Function(RewardItem)? onRewarded, VoidCallback? onDismiss}) {
    _rewardedAd?.dispose();
    _rewardedAd = null;

    showLoading();

    RewardedAd.load(
      adUnitId: rewardedUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          // Called when an ad is successfully received.
          debugPrint('Ad was loaded.');
          // Keep a reference to the ad so you can show it later.
          _rewardedAd = ad;

          hideLoading();
          showRewardAd(onRewarded: onRewarded, onDismiss: onDismiss);
        },
        onAdFailedToLoad: (LoadAdError error) {
          // Called when an ad request failed.
          debugPrint('Ad failed to load with error: $error');
          hideLoading();
          onDismiss?.call();
        },
      ),
    );
  }

  void showRewardAd({Function(RewardItem)? onRewarded, VoidCallback? onDismiss}) {
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
