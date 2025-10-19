import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tp_media/ads/tracking_transparency_dialog.dart';

const kTestAndroidBannerId = "ca-app-pub-3940256099942544/6300978111";
const kTestAndroidInterstitialId = "ca-app-pub-3940256099942544/1033173712";
const kTestAndroidInterstitialVideoId =
    "ca-app-pub-3940256099942544/8691691433";
const kTestAndroidOpenAdId = "ca-app-pub-3940256099942544/9257395921";
const kTestAndroidRewardedAdId = "ca-app-pub-3940256099942544/5224354917";
const kTestAndroidNativeAdId = "ca-app-pub-3940256099942544/1044960115";

const kTestIOSBannerId = "ca-app-pub-3940256099942544/2934735716";
const kTestIOSInterstitialId = "ca-app-pub-3940256099942544/4411468910";
const kTestIOSInterstitialVideoId = "ca-app-pub-3940256099942544/5135589807";
const kTestIOSOpenAdId = "ca-app-pub-3940256099942544/5575463023";
const kTestIOSRewardedAdId = "ca-app-pub-3940256099942544/1712485313";
const kTestIOSNativeAdId = "ca-app-pub-3940256099942544/2521693316";

class AdmobInitializer {
  // Remember add this lines to Info.plist
  // <key>NSUserTrackingUsageDescription</key>
  // <string>This identifier will be used to deliver personalized ads to you.</string>
  static Future<InitializationStatus> init(
    BuildContext context,
    Widget dialogContent, {
    List<String>? testDeviceIds,
  }) async {
    if (Platform.isIOS) {
      final isNotDetermined =
          await AppTrackingTransparency.trackingAuthorizationStatus ==
          TrackingStatus.notDetermined;

      if (isNotDetermined && context.mounted) {
        await showTrackingTransparencyDialog(context, dialogContent);

        await Future.delayed(const Duration(milliseconds: 200));

        await AppTrackingTransparency.requestTrackingAuthorization();
      }
    }

    MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(testDeviceIds: testDeviceIds),
    );

    return MobileAds.instance.initialize();
  }
}
