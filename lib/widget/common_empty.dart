import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CommonEmpty extends StatelessWidget {
  const CommonEmpty({required this.emptyMessage, super.key});

  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(24),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 120,
              height: 100,
              child: Lottie.asset(
                'assets/ani_empty.json',
                package: 'tp_media',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: TextStyle(
                fontSize: 14.0,
                color: Theme.of(context).hintColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
