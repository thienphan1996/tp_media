import 'package:flutter/material.dart';

class Global {
  static OverlayEntry? overlayEntry;

  static void showLoading(BuildContext context) {
    if (overlayEntry != null) return;

    overlayEntry = OverlayEntry(
      builder:
          (context) => SizedBox(
            width: 48,
            height: 48,
            child: Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor)),
          ),
    );
    Overlay.of(context).insert(overlayEntry!);
  }

  static void hideLoading() {
    if (overlayEntry == null) return;
    overlayEntry?.remove();
    overlayEntry = null;
  }
}
