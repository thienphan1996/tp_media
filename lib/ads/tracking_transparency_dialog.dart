import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildTrackingTransparencyDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String continueButton,
}) => Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16.0),
  child: Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      const SizedBox(height: 16),
      Text(
        title,
        style: TextStyle(
          fontSize: 20.0,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 12),
      Text(
        message,
        style: TextStyle(fontSize: 16),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 8),
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(
          continueButton,
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    ],
  ),
);

Future<void> showTrackingTransparencyDialog(
  BuildContext context,
  Widget dialogContent,
) async {
  await showCupertinoDialog(
    context: context,
    builder: (_) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: dialogContent,
      );
    },
  );
}
