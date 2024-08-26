import 'package:flutter/material.dart';

import '../inherited_rxdart.dart';

class RxConsumer<T> extends StatelessWidget {
  const RxConsumer({
    super.key,
    required this.builder,
    required this.subjectGetter,
    this.listener,
    this.filter,
  });

  final RxWidgetBuilder<T> builder;
  final RxBehaviorSubjectGetter<T> subjectGetter;
  final RxEventListener<T>? listener;
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
