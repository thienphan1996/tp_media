import 'package:in_app_review/in_app_review.dart';
import 'package:tp_media/network/internet_manager.dart';

class InAppReviewChecker {
  static Future<bool> requestReview() async {
    if (await InternetManager.instance.isOnline == false) {
      return false;
    }

    final inAppReview = InAppReview.instance;
    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
      return true;
    }

    return false;
  }
}
