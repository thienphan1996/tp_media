import 'package:flutter/material.dart';

extension ScrollControllerEx on ScrollController {
  void scrollToBottom({int durationMilli = 500}) {
    if (!hasClients) {
      return;
    }

    animateTo(position.maxScrollExtent, duration: Duration(milliseconds: durationMilli), curve: Curves.ease);
  }
}
