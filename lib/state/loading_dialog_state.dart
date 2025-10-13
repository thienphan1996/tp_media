import 'package:flutter/material.dart';

void showLoadingDialog(BuildContext context, {Color? color}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      return PopScope(
        //Prevent Back press on Android devices
        canPop: false,
        child: Dialog(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: SizedBox(
              width: 48,
              height: 48,
              child: Center(child: CircularProgressIndicator(color: color ?? Theme.of(context).primaryColor)),
            ),
          ),
        ),
      );
    },
  );
}

abstract class LoadingDialogState<T extends StatefulWidget> extends State<T> {
  var isLoading = false;

  void showLoading() {
    isLoading = true;
    showLoadingDialog(context);
  }

  void hideLoading() {
    if (isLoading) {
      isLoading = false;
      Navigator.pop(context);
    }
  }
}
