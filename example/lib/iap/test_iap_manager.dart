import 'package:tp_media/tp_media.dart';

class TestIapManager extends IapManager {
  TestIapManager._internal();

  static final _instance = TestIapManager._internal();

  static TestIapManager get instance => _instance;

  @override
  String entitlementId = 'Testing';
}
