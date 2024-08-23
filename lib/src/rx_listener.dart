import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nested/nested.dart';

import '../inherited_rxdart.dart';

class RxListener<T> extends SingleChildStatefulWidget {
  const RxListener({
    super.key,
    required this.listener,
    required this.subjectGetter,
    this.filter,
    super.child,
  });

  final RxSubjectGetter<T> subjectGetter;
  final RxEventListener<T> listener;
  final RxStateFilter<T>? filter;

  @override
  State<RxListener<T>> createState() => _RxListenerState<T>();
}

class _RxListenerState<T> extends SingleChildState<RxListener<T>> {
  StreamSubscription<T>? _subscription;
  T? _state;
  bool _isFirstEvent = true;

  @override
  void initState() {
    super.initState();
    final subject = widget.subjectGetter.call(context);
    _subscription = subject.listen(_handleEvent);
  }

  void _handleEvent(T event) {
    final needTrigger = _shouldTrigger(event);
    if (needTrigger) {
      widget.listener.call(context, event);
    }
    _state = event;
  }

  bool _shouldTrigger(T event) {
    if (_isFirstEvent) {
      _isFirstEvent = false;
      return true;
    }
    if (widget.filter == null) {
      return true;
    }
    final currentState = _state as T;
    final nextState = event;
    return widget.filter!.call(context, currentState, nextState);
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
