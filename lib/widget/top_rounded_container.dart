import 'package:flutter/material.dart';

class TopRoundedContainer extends StatelessWidget {
  final Widget child;
  final double radius;
  final Color? backgroundColor;
  final Color? backTopColor;
  const TopRoundedContainer({
    super.key,
    required this.child,
    this.radius = 16,
    this.backgroundColor,
    this.backTopColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backTopColor ?? Theme.of(context).colorScheme.inversePrimary,
      height: double.maxFinite,
      child: ClipRRect(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(radius), topRight: Radius.circular(radius)),
        child: Container(color: backgroundColor ?? Colors.white, child: child),
      ),
    );
  }
}
