import 'package:intl/intl.dart';

const String kDateDisplayFormat = "HH:mm dd/MM/yyyy";

class DateTimeUtils {
  static String get nowDisplay {
    return DateFormat(kDateDisplayFormat).format(DateTime.now());
  }

  static String toStringDisplay(DateTime dateTime) {
    try {
      return DateFormat(kDateDisplayFormat).format(dateTime);
    } catch (e) {
      return '';
    }
  }
}
