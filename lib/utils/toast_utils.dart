import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtils {
  static void success(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green.withValues(alpha: .2),
      textColor: Colors.black,
      fontSize: 16.0,
    );
  }

  static void updated(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.orange.withValues(alpha: .2),
      textColor: Colors.black,
      fontSize: 16.0,
    );
  }

  static void deleted(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red.withValues(alpha: .2),
      textColor: Colors.black,
      fontSize: 16.0,
    );
  }

  static void failed(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red.withValues(alpha: .2),
      textColor: Colors.black,
      fontSize: 16.0,
    );
  }
}
