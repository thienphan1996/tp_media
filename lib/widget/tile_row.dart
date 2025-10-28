import 'package:flutter/material.dart';

class TileRow extends StatelessWidget {
  const TileRow(
    this.icon,
    this.title, {
    super.key,
    this.onTap,
    this.isShowArrow = true,
  });

  final Widget icon;
  final Widget title;
  final Function()? onTap;
  final bool isShowArrow;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              children: [
                SizedBox(width: 8),
                SizedBox(width: 42.0, height: 42.0, child: icon),
                SizedBox(width: 8.0),
                Expanded(child: title),
                Visibility(
                  visible: isShowArrow,
                  child: Icon(
                    Icons.keyboard_arrow_right_rounded,
                    color: Colors.grey,
                    size: 20,
                  ),
                ),
                SizedBox(width: isShowArrow ? 8 : 0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
