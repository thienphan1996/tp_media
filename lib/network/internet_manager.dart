import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class InternetManager {
  const InternetManager._internal();

  static final _instance = InternetManager._internal();

  static InternetManager get instance => _instance;

  Future<bool> get isOnline => InternetConnection().hasInternetAccess;

  Stream<InternetStatus> get onStatusChange =>
      InternetConnection().onStatusChange;
}
