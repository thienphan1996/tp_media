import 'package:flutter/material.dart';
import 'package:tp_media/extension/context_ex.dart';

class DialogHeader extends StatelessWidget {
  const DialogHeader({
    required this.title,
    this.borderRadius = 16,
    this.isShowTopDivider = false,
    this.titleStyle,
    super.key,
  });

  final bool isShowTopDivider;
  final String title;
  final TextStyle? titleStyle;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      color: context.colors.surface,
      borderRadius: BorderRadius.only(topLeft: Radius.circular(borderRadius), topRight: Radius.circular(borderRadius)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            visible: isShowTopDivider,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 8),
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: Colors.grey.shade300),
                ),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 48),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: isShowTopDivider ? 12 : 16),
                    child: Text(
                      title,
                      style: titleStyle ?? TextStyle(fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: 48,
                  padding: EdgeInsets.only(top: isShowTopDivider ? 6 : 12),
                  child: Icon(Icons.close_rounded, color: Colors.black54, size: 28),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
