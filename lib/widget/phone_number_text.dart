import 'package:flutter/material.dart';

class PhoneNumberText extends StatelessWidget {
  const PhoneNumberText({
    super.key,
    this.textStyle,
    this.prefixText,
    this.phoneNumber,
    this.onCopy,
  });

  final TextStyle? textStyle;
  final String? prefixText;
  final String? phoneNumber;
  final Function(String?)? onCopy;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onCopy?.call(phoneNumber);
      },
      child: RichText(
        textAlign: TextAlign.start,
        text: TextSpan(
          text: prefixText,
          style: textStyle,
          children: [
            TextSpan(
              text: '$phoneNumber ',
              style: textStyle?.copyWith(color: Colors.blue),
            ),
            WidgetSpan(
              child: Icon(Icons.copy, size: 18, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
