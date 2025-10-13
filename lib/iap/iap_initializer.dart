import 'dart:io';

import 'package:purchases_flutter/purchases_flutter.dart';

class IapInitializer {
  static Future<void> init(String androidApiKey, String iosApiKey) async {
    Purchases.setLogLevel(LogLevel.debug);

    PurchasesConfiguration configuration;
    if (Platform.isAndroid) {
      configuration = PurchasesConfiguration(androidApiKey);
    } else {
      configuration = PurchasesConfiguration(iosApiKey);
    }

    await Purchases.configure(configuration);
  }
}
