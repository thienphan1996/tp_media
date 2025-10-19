import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

abstract class IapManager {
  final _secureStorage = const FlutterSecureStorage();

  final _controller = StreamController<bool>.broadcast();

  abstract String entitlementId;

  String get _keyIapManager {
    return 'key_${entitlementId.toLowerCase()}';
  }

  bool isSubscribed = false;

  Stream<bool> get stream => _controller.stream;

  Future<CustomerInfo> get iapCustomerInfo => Purchases.getCustomerInfo();

  void addCustomerInfoUpdateListener(
    CustomerInfoUpdateListener customerInfoUpdateListener,
  ) {
    Purchases.addCustomerInfoUpdateListener(customerInfoUpdateListener);
  }

  Future<CustomerInfo> init({CustomerInfo? customerInfo}) async {
    final storedValue = await _secureStorage.read(key: _keyIapManager);

    isSubscribed = storedValue == "true";

    Purchases.addCustomerInfoUpdateListener((customerInfo) {
      _updateState(entitlementId, customerInfo);
    });

    final info = customerInfo ?? await iapCustomerInfo;

    _updateState(entitlementId, info);

    return info;
  }

  Future<bool> presentPaywallIfNeeded({
    Offering? offering,
    bool displayCloseButton = false,
  }) async {
    if (isSubscribed) {
      return Future.value(true);
    }

    final paywallResult = await RevenueCatUI.presentPaywallIfNeeded(
      entitlementId,
      offering: offering,
      displayCloseButton: displayCloseButton,
    );

    if (paywallResult == PaywallResult.purchased ||
        paywallResult == PaywallResult.restored) {
      return refreshFromRevenueCat();
    }

    return Future.value(isSubscribed);
  }

  Future<bool> presentPaywall({
    Offering? offering,
    bool displayCloseButton = false,
  }) async {
    if (isSubscribed) {
      return Future.value(true);
    }

    final paywallResult = await RevenueCatUI.presentPaywall(
      offering: offering,
      displayCloseButton: displayCloseButton,
    );
    if (paywallResult == PaywallResult.purchased ||
        paywallResult == PaywallResult.restored) {
      return refreshFromRevenueCat();
    }

    return Future.value(isSubscribed);
  }

  Future<bool> refreshFromRevenueCat() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      final active =
          customerInfo.entitlements.all[entitlementId]?.isActive ?? false;

      _updateState(entitlementId, customerInfo);

      return Future.value(active);
    } catch (e) {
      return Future.value(isSubscribed);
    }
  }

  void _updateState(String entitlementId, CustomerInfo customerInfo) async {
    final active =
        customerInfo.entitlements.all[entitlementId]?.isActive ?? false;
    if (active != isSubscribed) {
      isSubscribed = active;
      _controller.add(active);

      await _secureStorage.write(key: _keyIapManager, value: active.toString());
    }
  }
}
