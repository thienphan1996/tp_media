import 'package:flutter/material.dart';

class CommonCard extends StatelessWidget {
  const CommonCard({super.key, this.child, this.radius, this.elevation = 2});

  final Widget? child;
  final double elevation;
  final BorderRadius? radius;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: radius ?? BorderRadius.circular(8),
        side: const BorderSide(color: Color(0x0d3f464f)),
      ),
      elevation: elevation,
      margin: const EdgeInsets.all(0.0),
      color: Colors.white,
      child: ClipRRect(borderRadius: radius ?? BorderRadius.circular(8), child: child),
    );
  }
}
