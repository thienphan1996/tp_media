import 'dart:io';

import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:tp_media/iap/iap_manager.dart';

class IapInitializer {
  static Future<void> init({String? androidApiKey, String? iosApiKey}) async {
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
  }

  static Future<void> initIapManagers(List<IapManager> iapManagers) async {
    if (iapManagers.isEmpty) {
      return;
    }

    final customerInfo = await iapManagers.first.init();
    for (var i = 1; i < iapManagers.length; i++) {
      await iapManagers[i].init(customerInfo: customerInfo);
    }
  }
}
