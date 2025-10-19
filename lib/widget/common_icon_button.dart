import 'package:flutter/material.dart';

class CommonIconButton extends StatelessWidget {
  const CommonIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 48,
    this.color,
  });

  final IconData icon;
  final Function() onPressed;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      elevation: 0.0,
      onPressed: onPressed,
      constraints: BoxConstraints.tightFor(width: size, height: size),
      shape: const CircleBorder(),
      child: Icon(
        icon,
        size: size * .6,
        color: color ?? Theme.of(context).primaryColor,
      ),
    );
  }
}
