import 'package:flutter/material.dart';

extension ContextEx on BuildContext {
  bool isTablet() {
    return MediaQuery.of(this).size.shortestSide > 600;
  }

  Future<dynamic> pushSlideBottomUp(Widget anotherPage) {
    return Navigator.of(this).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => anotherPage,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(position: animation.drive(tween), child: child);
        },
      ),
    );
  }
}
