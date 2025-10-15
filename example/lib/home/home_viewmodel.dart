import 'package:example/async/test_async_viewmodel.dart';
import 'package:example/base/viewmodel_builder.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'home_state.dart';

part 'home_viewmodel.g.dart';

@Riverpod()
class HomeViewModel extends _$HomeViewModel with ViewModel<HomeState> {
  @override
  HomeState build() {
    //This is a dependency with asyncViewModelProvider, when asyncViewModelProvider changed, this will be rebuild
    final newState = ref.watch(testAsyncViewModelProvider);
    return HomeState(counter: newState.value?.counter ?? 0);
  }

  Future<void> increment() async {
    //This is a snapshot, when asyncViewModelProvider changed, this will not be rebuild, ref.read is same with ref.watch
    //ref.watch apply only in build function, ref.read apply in all function
    final newState = ref.read(testAsyncViewModelProvider);
    state = state.copyWith(counter: (newState.value?.counter ?? 0) + 1);
  }
}
