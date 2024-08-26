import 'package:flutter/material.dart';
import 'package:inherited_rxdart/inherited_rxdart.dart';

class RxSelector<T, V> extends StatelessWidget {
  const RxSelector({
    super.key,
    required this.valueSelector,
    required this.subjectGetter,
    required this.builder,
  });

  final RxWidgetBuilder<V> builder;
  final RxBehaviorSubjectGetter<T> subjectGetter;
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
