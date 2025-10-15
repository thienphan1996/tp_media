import 'package:example/async/test_async_viewmodel.dart';
import 'package:example/base/base_hook_widget.dart';
import 'package:example/home/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends BaseHookWidget {
  const HomePage({super.key});

  @override
  Widget buildView(BuildContext context, WidgetRef ref) {
    final viewModelAsync = ref.watch(testAsyncViewModelProvider);
    final viewModel = ref.watch(homeViewModelProvider);
    final watch = ref.watch(homeViewModelProvider);
    final read = ref.read(homeViewModelProvider);
    final refresh = ref.refresh(homeViewModelProvider);
    final listener = ref.listen(homeViewModelProvider, (previous, next) {});
    final isExist = ref.exists(homeViewModelProvider);
    final invalidate = ref.invalidate(homeViewModelProvider, asReload: true);
    return Scaffold(
      body: Container(
        child: viewModelAsync.when(
          data: (s) {
            return SizedBox();
          },
          error: (e, _) {
            return SizedBox();
          },
          loading: () {
            return SizedBox();
          },
        ),
      ),
    );
  }
}
