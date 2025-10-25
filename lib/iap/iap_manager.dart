import 'dart:async';

import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:tp_media/network/internet_manager.dart';

abstract class IapManager {
  final _controller = StreamController<bool>.broadcast();

  abstract String entitlementId;

  bool isSubscribed = false;

  Stream<bool> get stream => _controller.stream;

  Future<CustomerInfo> get customerInfo => Purchases.getCustomerInfo();

  Future<void> addCustomerInfoUpdateListener(
    CustomerInfoUpdateListener customerInfoUpdateListener,
  ) async {
    if (await InternetManager.instance.isOnline) {
      Purchases.addCustomerInfoUpdateListener(customerInfoUpdateListener);
    }
  }

  Future<CustomerInfo?> init({CustomerInfo? customerInfo}) async {
    addCustomerInfoUpdateListener((customerInfo) {
      _updateState(entitlementId, customerInfo);
    });

    try {
      final info = customerInfo ?? await this.customerInfo;
      _updateState(entitlementId, info);
      return info;
    } catch (e) {
      return null;
    }
  }

  Future<bool> presentPaywallIfNeeded({
    Offering? offering,
    bool displayCloseButton = false,
  }) async {
    if (isSubscribed) {
      return true;
    }

    if (await InternetManager.instance.isOnline == false) {
      return isSubscribed;
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

    return isSubscribed;
  }

  Future<bool> presentPaywall({
    Offering? offering,
    bool displayCloseButton = false,
  }) async {
    if (isSubscribed) {
      return true;
    }

    if (await InternetManager.instance.isOnline == false) {
      return isSubscribed;
    }

    final paywallResult = await RevenueCatUI.presentPaywall(
      offering: offering,
      displayCloseButton: displayCloseButton,
    );
    if (paywallResult == PaywallResult.purchased ||
        paywallResult == PaywallResult.restored) {
      return refreshFromRevenueCat();
    }

    return isSubscribed;
  }

  Future<bool> refreshFromRevenueCat() async {
    try {
      return _updateState(entitlementId, await customerInfo);
    } catch (e) {
      return Future.value(isSubscribed);
    }
  }

  Future<bool> _updateState(
    String entitlementId,
    CustomerInfo customerInfo,
  ) async {
    final active =
        customerInfo.entitlements.all[entitlementId]?.isActive ?? false;
    if (active != isSubscribed) {
      isSubscribed = active;
      _controller.add(active);
    }
    return isSubscribed;
  }

  void dispose() {
    _controller.close();
  }
}
