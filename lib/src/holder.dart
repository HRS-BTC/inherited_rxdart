import 'dart:core';

/// Class for easier value casting
class Holder {
  const Holder(this._value);

  final Object? _value;

  T cast<T>() => _value as T;

  T? tryCast<T>() => _value is T ? _value : null;

  Object? get raw => _value;
}
