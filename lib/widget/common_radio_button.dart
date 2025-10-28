import 'package:flutter/material.dart';
import 'package:tp_media/tp_media.dart';

class TileRadio<T> extends StatelessWidget {
  const TileRadio({
    required this.value,
    required this.groupValue,
    required this.title,
    required this.onChanged,
    this.subtitle = "",
    this.activeColor,
    this.borderColor,
    this.enable = true,
    this.maxLines = 1,
    super.key,
  });

  final T value;
  final T? groupValue;
  final ValueChanged<T>? onChanged;
  final Color? activeColor;
  final Color? borderColor;
  final String title;
  final String subtitle;
  final bool enable;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return DisableContainer(
      disable: !enable,
      child: MaterialInkWell(
        onTap: () {
          onChanged?.call(value);
        },
        radius: 12,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: mediumBorderRadius,
            border: Border.all(
              color:
                  value == groupValue
                      ? (activeColor ?? context.colors.primary)
                      : (borderColor ?? Colors.grey),
              width: value == groupValue ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                value == groupValue
                    ? Icons.check_circle_rounded
                    : Icons.circle_outlined,
                color:
                    value == groupValue ? context.colors.primary : Colors.grey,
                size: 20,
              ),
              SizedBox(width: 12),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  subtitle.isNotEmpty
                      ? Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          subtitle,
                          maxLines: maxLines,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 14, color: Colors.black45),
                        ),
                      )
                      : SizedBox.shrink(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
