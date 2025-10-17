extension StringEx on String {
  String get replaceComma => replaceAll(',', '.');

  String capitalize() {
    if (isEmpty) {
      return this;
    }

    if (length == 1) {
      return this[0].toUpperCase();
    }

    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  bool isUri() {
    String pattern = r'[a-zA-Z0-9]{1,100}:.*';
    RegExp regExp = RegExp(pattern);

    return regExp.hasMatch(this);
  }

  bool validatePhone() {
    var pattern = r'^(?:[+0]84)?[0-9]{9,}$';
    RegExp regex = RegExp(pattern);

    return regex.hasMatch(this);
  }
}

extension NullableStringEx on String? {
  String get orEmpty => this != null ? this! : '';

  bool get isNullOrEmpty => this == null || this!.isEmpty;

  String ifIsNullOrEmpty(String fallback) => isNullOrEmpty ? fallback : this!;
}
