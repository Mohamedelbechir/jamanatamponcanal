class Optional<T> {
  final T? value;
  final bool _hasValue;
  bool get isEmpty => !_hasValue;

  const Optional.value(this.value) : _hasValue = true;

  const Optional.empty()
      : value = null,
        _hasValue = false;
}
