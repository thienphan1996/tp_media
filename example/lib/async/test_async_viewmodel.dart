import 'package:example/base/viewmodel_builder.dart';
import 'package:example/home/home_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'test_async_viewmodel.g.dart';

@Riverpod()
class TestAsyncViewModel extends _$TestAsyncViewModel with AsyncViewModel<HomeState> {
  @override
  Future<HomeState> build() async {
    state = AsyncData(HomeState());
    state = AsyncLoading(progress: 20);
    return HomeState();
  }
}
