import 'package:flutter/material.dart';

class TakeIfContainer extends StatelessWidget {
  const TakeIfContainer({
    super.key,
    required this.condition,
    required this.child,
    this.orElse,
  });

  final bool condition;
  final Widget Function() child;
  final Widget Function()? orElse;

  @override
  Widget build(BuildContext context) {
    if (condition) {
      return child();
    }

    return orElse?.call() ?? SizedBox.shrink();
  }
}
