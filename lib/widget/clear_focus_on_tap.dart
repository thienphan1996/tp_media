import 'package:flutter/material.dart';

class ClearFocusOnTap extends StatelessWidget {
  const ClearFocusOnTap({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: child,
    );
  }
}
