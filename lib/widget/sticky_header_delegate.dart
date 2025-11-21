import 'package:flutter/material.dart';

class StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double minHeight;
  final double maxHeight;
  final Color pinnedColor;
  final Color normalColor;

  StickyHeaderDelegate({
    required this.child,
    required this.minHeight,
    required this.maxHeight,
    this.pinnedColor = Colors.transparent,
    this.normalColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final bool isPinned = shrinkOffset > 0;

    return Container(color: isPinned ? pinnedColor : normalColor, child: child);
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(covariant StickyHeaderDelegate oldDelegate) {
    return oldDelegate.child != child ||
        oldDelegate.pinnedColor != pinnedColor ||
        oldDelegate.normalColor != normalColor;
  }
}
