import 'package:intl/intl.dart';

class DateTimeUtils {
  static const String DATE_TIME_DISPLAY_FORMAT = "HH:mm dd/MM/yyyy";

  static String get nowDisplay {
    return DateFormat(DATE_TIME_DISPLAY_FORMAT).format(DateTime.now());
  }

  static String toStringDisplay(DateTime dateTime) {
    try {
      return DateFormat(DateTimeUtils.DATE_TIME_DISPLAY_FORMAT).format(dateTime);
    } catch (e) {
      return '';
    }
  }
}
