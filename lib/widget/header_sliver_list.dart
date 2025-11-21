import 'package:flutter/material.dart';

class HeaderSliverList extends StatelessWidget {
  const HeaderSliverList({
    super.key,
    this.header,
    required this.builder,
    this.childCount,
    this.padding,
    this.emptyItem,
  });

  final Widget? header;
  final Widget? Function(BuildContext, int) builder;
  final int? childCount;
  final EdgeInsetsGeometry? padding;
  final Widget? emptyItem;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: header),
        childCount == 0
            ? SliverToBoxAdapter(child: emptyItem)
            : SliverPadding(
              padding: padding ?? EdgeInsets.zero,
              sliver: SliverList(delegate: SliverChildBuilderDelegate(builder, childCount: childCount)),
            ),
      ],
    );
  }
}
