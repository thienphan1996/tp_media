import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showAlertDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String okText,
  required String cancelText,
  required Function() onOkButton,
}) {
  showCupertinoDialog(
    context: context,
    barrierDismissible: true,
    builder: (ctx) {
      return CommonAlertDialog(
        title: title,
        message: message,
        onOkButton: onOkButton,
        okText: okText,
        cancelText: cancelText,
      );
    },
  );
}

class CommonAlertDialog extends StatelessWidget {
  const CommonAlertDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onOkButton,
    required this.okText,
    required this.cancelText,
  });

  final String title;
  final String message;
  final String okText;
  final String cancelText;
  final Function() onOkButton;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 20.0,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        message,
        style: TextStyle(fontSize: 16, color: Colors.black87),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ButtonStyle(
            overlayColor: WidgetStateProperty.all(Colors.transparent),
          ),
          child: Text(
            cancelText,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        TextButton(
          onPressed: () async {
            onOkButton();
          },
          style: ButtonStyle(
            overlayColor: WidgetStateProperty.all(Colors.transparent),
          ),
          child: Text(
            okText,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
