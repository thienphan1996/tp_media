import 'package:flutter/material.dart';

class DisableContainer extends StatelessWidget {
  const DisableContainer({
    super.key,
    required this.child,
    this.disable = false,
  });

  final Widget child;
  final bool disable;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (disable)
          Positioned.fill(
            child: Container(
              color: Colors.white.withValues(alpha: .5),
              child: const IgnorePointer(ignoring: true),
            ),
          ),
      ],
    );
  }
}
