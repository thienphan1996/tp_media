import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

class PremiumManager {
  PremiumManager._internal();

  factory PremiumManager() => _instance;

  static final PremiumManager _instance = PremiumManager._internal();

  static final _keyIsSubscribed = "is_premium";

  final _secureStorage = const FlutterSecureStorage();

  final _controller = StreamController<bool>.broadcast();

  bool isPremiumUser = false;

  Stream<bool> get subscriptionStream => _controller.stream;

  Future<void> init(String entitlementId) async {
    // Load cache từ Secure Storage
    final storedValue = await _secureStorage.read(key: _keyIsSubscribed);
    isPremiumUser = storedValue == "true";

    // Listen RevenueCat update
    Purchases.addCustomerInfoUpdateListener((customerInfo) {
      _updateState(entitlementId, customerInfo);
    });

    refreshFromRevenueCat(entitlementId);
  }

  Future<bool> presentPaywallIfNeeded(
    String entitlementId, {
    Offering? offering,
    bool displayCloseButton = false,
  }) async {
    if (isPremiumUser) {
      return Future.value(true);
    }

    final paywallResult = await RevenueCatUI.presentPaywallIfNeeded(
      entitlementId,
      offering: offering,
      displayCloseButton: displayCloseButton,
    );

    if (paywallResult == PaywallResult.purchased || paywallResult == PaywallResult.restored) {
      return refreshFromRevenueCat(entitlementId);
    }

    return Future.value(isPremiumUser);
  }

  Future<bool> presentPaywall(String entitlementId, {Offering? offering, bool displayCloseButton = false}) async {
    if (isPremiumUser) {
      return Future.value(true);
    }

    final paywallResult = await RevenueCatUI.presentPaywall(offering: offering, displayCloseButton: displayCloseButton);
    if (paywallResult == PaywallResult.purchased || paywallResult == PaywallResult.restored) {
      return refreshFromRevenueCat(entitlementId);
    }

    return Future.value(isPremiumUser);
  }

  /// Hàm refresh thủ công với callback
  Future<bool> refreshFromRevenueCat(String entitlementId) async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      final active = customerInfo.entitlements.all[entitlementId]?.isActive ?? false;

      // Cập nhật state & cache
      _updateState(entitlementId, customerInfo);

      // Gọi callback trả kết quả
      return Future.value(active);
    } catch (e) {
      // Nếu lỗi thì callback với trạng thái hiện tại
      return Future.value(isPremiumUser);
    }
  }

  void _updateState(String entitlementId, CustomerInfo customerInfo) async {
    final active = customerInfo.entitlements.all[entitlementId]?.isActive ?? false;
    if (active != isPremiumUser) {
      isPremiumUser = active;
      _controller.add(active);

      // Lưu vào secure storage
      await _secureStorage.write(key: _keyIsSubscribed, value: active.toString());
    }
  }
}
