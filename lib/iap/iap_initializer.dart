import 'dart:io';

import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:tp_media/iap/iap_manager.dart';

class IapInitializer {
  static Future<bool> init(List<IapManager> iapManagers, {String? androidApiKey, String? iosApiKey}) async {
    Purchases.setLogLevel(LogLevel.debug);

    PurchasesConfiguration configuration;
    if (Platform.isAndroid && androidApiKey != null) {
      configuration = PurchasesConfiguration(androidApiKey);
    } else if (Platform.isIOS && iosApiKey != null) {
      configuration = PurchasesConfiguration(iosApiKey);
    } else {
      throw Exception('Invalid platform');
    }

    await Purchases.configure(configuration);

    return _initIapManagers(iapManagers);
  }

  static Future<bool> _initIapManagers(List<IapManager> iapManagers) async {
    var isSubscribed = false;

    if (iapManagers.isEmpty) {
      return false;
    }

    final customerInfo = await iapManagers.first.init();
    isSubscribed = iapManagers.first.isSubscribed;

    for (var i = 1; i < iapManagers.length; i++) {
      await iapManagers[i].init(customerInfo: customerInfo);

      isSubscribed = isSubscribed || iapManagers[i].isSubscribed;
    }

    return isSubscribed;
  }
}
