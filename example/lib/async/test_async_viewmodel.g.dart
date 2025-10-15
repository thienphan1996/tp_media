// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_async_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TestAsyncViewModel)
const testAsyncViewModelProvider = TestAsyncViewModelProvider._();

final class TestAsyncViewModelProvider
    extends $AsyncNotifierProvider<TestAsyncViewModel, HomeState> {
  const TestAsyncViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'testAsyncViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$testAsyncViewModelHash();

  @$internal
  @override
  TestAsyncViewModel create() => TestAsyncViewModel();
}

String _$testAsyncViewModelHash() =>
    r'3999da5973f73b5cc37c18ad1ab07bbcbb7e9b54';

abstract class _$TestAsyncViewModel extends $AsyncNotifier<HomeState> {
  FutureOr<HomeState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<HomeState>, HomeState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<HomeState>, HomeState>,
              AsyncValue<HomeState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
