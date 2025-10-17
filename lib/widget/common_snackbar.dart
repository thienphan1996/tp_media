import 'package:flutter/material.dart';
import 'package:tp_media/extension/context_ex.dart';

class CommonSnackBar extends SnackBar {
  CommonSnackBar.success({super.key, required BuildContext context, required String text, super.action})
    : super(
        content: Row(
          children: [
            Icon(Icons.check, size: 24, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text(text, style: context.textTheme.bodyMedium?.copyWith(color: Colors.white))),
          ],
        ),
        backgroundColor: Colors.green,
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 32),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
      );

  CommonSnackBar.info({super.key, required BuildContext context, required String text, super.action})
    : super(
        content: Row(
          children: [
            Icon(Icons.info_outline, size: 24, color: Colors.black),
            SizedBox(width: 8),
            Expanded(child: Text(text, style: context.textTheme.bodyMedium?.copyWith(color: Colors.black))),
          ],
        ),
        backgroundColor: Colors.black45,
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 32),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
      );

  CommonSnackBar.warning({super.key, required BuildContext context, required String text, super.action})
    : super(
        content: Row(
          children: [
            const Icon(Icons.warning_amber, size: 24, color: Colors.orange),
            const SizedBox(width: 8),
            Expanded(child: Text(text, style: context.textTheme.bodyMedium?.copyWith(color: Colors.orange))),
          ],
        ),
        backgroundColor: Colors.orange.withValues(alpha: .1),
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 32),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
      );

  CommonSnackBar.error({super.key, required BuildContext context, required String text, super.action})
    : super(
        content: Row(
          children: [
            Icon(Icons.close, size: 24, color: context.colors.onError),
            const SizedBox(width: 8),
            Expanded(child: Text(text, style: context.textTheme.bodyMedium?.copyWith(color: context.colors.onError))),
          ],
        ),
        backgroundColor: context.colors.error,
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 32),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
      );
}
