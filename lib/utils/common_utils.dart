class CommonUtils {
  static bool validatePhone(String phone) {
    var pattern = r'^(?:[+0]84)?[0-9]{9,}$';
    RegExp regex = RegExp(pattern);

    return regex.hasMatch(phone);
  }
}
