import 'package:example/base/base_hook_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

mixin AppLifecycleMixin on BaseHookWidget {
  void onForeground() {}

  void onBackground() {}

  void onResumed() {}

  void onPaused() {}

  @protected
  void useAppLifecycle() {
    useEffect(() {
      final observer = _AppLifecycleObserver(
        onForeground: onForeground,
        onBackground: onBackground,
        onResumed: onResumed,
        onPaused: onPaused,
      );
      WidgetsBinding.instance.addObserver(observer);
      return () => WidgetsBinding.instance.removeObserver(observer);
    }, const []);
  }
}

class _AppLifecycleObserver with WidgetsBindingObserver {
  final VoidCallback? onForeground;
  final VoidCallback? onBackground;
  final VoidCallback? onResumed;
  final VoidCallback? onPaused;

  _AppLifecycleObserver({
    this.onForeground,
    this.onBackground,
    this.onResumed,
    this.onPaused,
  });

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        onResumed?.call();
        onForeground?.call();
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
      case AppLifecycleState.inactive:
        onPaused?.call();
        onBackground?.call();
        break;
      default:
        break;
    }
  }
}
