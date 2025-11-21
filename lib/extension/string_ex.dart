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

  bool isPhoneNumber() {
    var pattern = r'^(?:[+0]84)?[0-9]{9,}$';
    RegExp regex = RegExp(pattern);

    return regex.hasMatch(this);
  }

  String get vnToEn {
    const from =
        "àáạảãâầấậẩẫăằắặẳẵ"
        "èéẹẻẽêềếệểễ"
        "ìíịỉĩ"
        "òóọỏõôồốộổỗơờớợởỡ"
        "ùúụủũưừứựửữ"
        "ỳýỵỷỹ"
        "đ"
        "ÀÁẠẢÃÂẦẤẬẨẪĂẰẮẶẲẴ"
        "ÈÉẸẺẼÊỀẾỆỂỄ"
        "ÌÍỊỈĨ"
        "ÒÓỌỎÕÔỒỐỘỔỖƠỜỚỢỞỠ"
        "ÙÚỤỦŨƯỪỨỰỬỮ"
        "ỲÝỴỶỸ"
        "Đ";

    const to =
        "aaaaaaaaaaaaaaaaa"
        "eeeeeeeeeee"
        "iiiii"
        "ooooooooooooooooo"
        "uuuuuuuuuuu"
        "yyyyy"
        "d"
        "AAAAAAAAAAAAAAAAA"
        "EEEEEEEEEEE"
        "IIIII"
        "OOOOOOOOOOOOOOOOO"
        "UUUUUUUUUUU"
        "YYYYY"
        "D";

    String result = this;
    for (int i = 0; i < from.length; i++) {
      result = result.replaceAll(from[i], to[i]);
    }
    return result;
  }
}

extension NullableStringEx on String? {
  String get orEmpty => this != null ? this! : '';

  bool get isNullOrEmpty => this == null || this!.isEmpty;

  String ifIsNullOrEmpty(String fallback) => isNullOrEmpty ? fallback : this!;
}
