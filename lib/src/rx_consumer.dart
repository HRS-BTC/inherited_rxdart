import 'package:flutter/material.dart';

import '../inherited_rxdart.dart';

/// Combination of [RxBuilder] and [RxListener] for easier handle changed from
/// a single [BehaviorSubject]
class RxConsumer<T> extends StatelessWidget {
  const RxConsumer({
    super.key,
    required this.builder,
    required this.subjectGetter,
    this.listener,
    this.filter,
  });

  /// See [RxBuilder.builder]
  final RxWidgetBuilder<T> builder;

  /// See [RxBuilder.subjectGetter]
  final RxBehaviorSubjectGetter<T> subjectGetter;

  /// See [RxListener.listener]
  final RxEventListener<T>? listener;

  /// See [RxListener.filter]
  final RxStateFilter<T>? filter;

  @override
  Widget build(BuildContext context) {
    return RxListener<T>(
      listener: (context, value) {
        return listener?.call(context, value);
      },
      subjectGetter: subjectGetter,
      child: RxBuilder<T>(
        filter: filter,
        subjectGetter: subjectGetter,
        builder: builder,
      ),
    );
  }
}
