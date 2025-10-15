import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class BaseHookWidget extends HookConsumerWidget {
  const BaseHookWidget({super.key});

  void onInit(WidgetRef ref) {}

  void onDispose(WidgetRef ref) {}

  void onUpdate(WidgetRef ref) {}

  Widget buildView(BuildContext context, WidgetRef ref);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasInit = useRef(false);

    useEffect(() {
      if (!hasInit.value) {
        onInit(ref);
        hasInit.value = true;
      } else {
        onUpdate(ref);
      }

      return () => onDispose(ref);
    }, const []);

    return buildView(context, ref);
  }
}
