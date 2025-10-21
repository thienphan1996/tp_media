import 'package:flutter/material.dart';
import 'package:tp_media/widget/common_snackbar.dart';

extension ContextEx on BuildContext {
  bool get isTablet => MediaQuery.of(this).size.shortestSide > 600;

  ColorScheme get colors => Theme.of(this).colorScheme;

  TextTheme get textTheme => Theme.of(this).textTheme;

  ThemeData get theme => Theme.of(this);

  double get screenHeight {
    return MediaQuery.of(this).size.height;
  }

  double get statusBarHeight {
    return MediaQuery.of(this).padding.top;
  }

  double get screenWidth {
    return MediaQuery.of(this).size.width;
  }

  bool get isMobile {
    return MediaQuery.of(this).size.width < 728.0;
  }

  bool get isPortrait {
    return MediaQuery.of(this).orientation == Orientation.portrait;
  }

  bool get isLandscape {
    return MediaQuery.of(this).orientation == Orientation.landscape;
  }

  void hideKeyboard() {
    FocusScope.of(this).unfocus();
  }

  void showSuccessSnackBar(String text, {SnackBarAction? action}) {
    ScaffoldMessenger.of(this).showSnackBar(CommonSnackBar.success(context: this, text: text, action: action));
  }

  void showInfoSnackBar(String text, {SnackBarAction? action}) {
    ScaffoldMessenger.of(this).showSnackBar(CommonSnackBar.info(context: this, text: text, action: action));
  }

  void showWarningSnackBar(String text, {SnackBarAction? action}) {
    ScaffoldMessenger.of(this).showSnackBar(CommonSnackBar.warning(context: this, text: text, action: action));
  }

  void showErrorSnackBar(String text, {SnackBarAction? action}) {
    ScaffoldMessenger.of(this).showSnackBar(CommonSnackBar.error(context: this, text: text, action: action));
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
