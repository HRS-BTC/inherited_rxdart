import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nested/nested.dart';

import '../inherited_rxdart.dart';

class RxListener<T> extends SingleChildStatefulWidget {
  const RxListener({
    super.key,
    required this.listener,
    required this.subjectGetter,
    super.child,
  });

  final RxSubjectGetter<T> subjectGetter;
  final RxEventListener<T> listener;

  @override
  State<RxListener<T>> createState() => _RxListenerState<T>();
}

class _RxListenerState<T> extends SingleChildState<RxListener<T>> {
  StreamSubscription<T>? _subscription;

  @override
  void initState() {
    super.initState();
    final subject = widget.subjectGetter.call(context);
    _subscription = subject.listen(_handleEvent);
  }

  void _handleEvent(T event) {
    widget.listener.call(context, event);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    final resolvedChild = child ?? const SizedBox.shrink();
    return resolvedChild;
  }
}
