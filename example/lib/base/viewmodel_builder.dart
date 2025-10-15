mixin ViewModel<T> {
  T build();
}

mixin AsyncViewModel<T> {
  Future<T> build();
}
