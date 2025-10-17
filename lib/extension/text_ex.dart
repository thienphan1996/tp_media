import 'package:flutter/material.dart';

extension TextEx on TextStyle {
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);
  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);
  TextStyle get italic => copyWith(fontStyle: FontStyle.italic);
  TextStyle get underline => copyWith(decoration: TextDecoration.underline);

  TextStyle get fontSize8 => copyWith(fontSize: 8);
  TextStyle get fontSize10 => copyWith(fontSize: 10);
  TextStyle get fontSize12 => copyWith(fontSize: 12);
  TextStyle get fontSize14 => copyWith(fontSize: 14);
  TextStyle get fontSize16 => copyWith(fontSize: 16);
  TextStyle get fontSize18 => copyWith(fontSize: 18);
  TextStyle get fontSize20 => copyWith(fontSize: 20);
  TextStyle get fontSize22 => copyWith(fontSize: 22);
  TextStyle get fontSize24 => copyWith(fontSize: 24);
}
