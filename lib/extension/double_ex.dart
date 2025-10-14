import 'dart:math';

extension DoubleEx on double {
  double round({int digit = 1}) {
    if (isNaN) {
      return 0;
    }

    num mod = pow(10.0, digit);

    return ((this * mod).round().toDouble() / mod);
  }

  String get orZeroString {
    if (this == 0.0) {
      return '0';
    }

    return toString();
  }
}
