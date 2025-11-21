import 'package:flutter/material.dart';
import 'package:tp_media/theme/theme.dart';

class CommonCard extends StatelessWidget {
  const CommonCard({super.key, this.child, this.radius, this.elevation = 2, this.borderColor});

  final Widget? child;
  final double elevation;
  final BorderRadius? radius;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: radius ?? smallBorderRadius,
        side: BorderSide(color: borderColor ?? const Color(0x0d3f464f)),
      ),
      elevation: elevation,
      margin: const EdgeInsets.all(0.0),
      color: Theme.of(context).cardColor,
      child: ClipRRect(borderRadius: radius ?? smallBorderRadius, child: child),
    );
  }
}
