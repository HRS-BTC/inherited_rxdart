import 'package:flutter/material.dart';
import 'package:inherited_rxdart/inherited_rxdart.dart';

/// Shortcut for subscribing only to changes belong to a subset of properties of
/// state object
class RxSelector<T, V> extends StatelessWidget {
  const RxSelector({
    super.key,
    required this.valueSelector,
    required this.subjectGetter,
    required this.builder,
  });

  /// See [RxBuilder.builder]
  final RxWidgetBuilder<V> builder;

  /// See [RxBuilder.subjectGetter]
  final RxBehaviorSubjectGetter<T> subjectGetter;

  /// Similar to [RxBuilder.filter] but will automatically compare changed
  /// computed value derived from state changes
  final RxValueSelector<T, V> valueSelector;

  @override
  Widget build(BuildContext context) {
    return RxBuilder<T>(
      subjectGetter: subjectGetter,
      filter: (context, prev, curr) {
        final oldValue = valueSelector.call(context, prev);
        final newValue = valueSelector.call(context, curr);
        return oldValue != newValue;
      },
      builder: (context, T state) {
        final selectedValue = valueSelector.call(context, state);
        return builder.call(context, selectedValue);
      },
    );
  }
}
