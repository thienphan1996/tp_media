import 'package:flutter/material.dart';

class CommonTextButton extends StatelessWidget {
  const CommonTextButton({
    super.key,
    required this.text,
    this.isEnable = true,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.radius,
  });

  final bool isEnable;
  final VoidCallback? onPressed;
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final BorderRadius? radius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: isEnable ? onPressed : null,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
            isEnable ? (backgroundColor ?? Theme.of(context).primaryColor) : Colors.grey,
          ),
          shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: radius ?? BorderRadius.circular(8))),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(text, style: TextStyle(color: textColor ?? Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
