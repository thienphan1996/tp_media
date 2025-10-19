import 'package:example/base/app_lifecycle_mixin.dart';
import 'package:example/base/base_hook_widget.dart';

abstract class BaseLifecycleWidget extends BaseHookWidget
    with AppLifecycleMixin {
  const BaseLifecycleWidget({super.key});
}
