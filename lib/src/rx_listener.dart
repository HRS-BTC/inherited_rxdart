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
  late final Stream<T> subject;

  @override
  void initState() {
    super.initState();
    subject = widget.subjectGetter.call(context);
    _subscribe(subject);
  }

  @override
  void didUpdateWidget(covariant RxListener<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.subjectGetter != oldWidget.subjectGetter) {
      final newSubject = widget.subjectGetter.call(context);
      if (newSubject != subject) {
        _unsubscribe();
        _subscribe(newSubject);
      }
    }
  }

  void _subscribe(Stream<T> subject) {
    _subscription = subject.listen(_handleEvent);
  }

  void _unsubscribe() {
    _subscription?.cancel();
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
    _unsubscribe();
    super.dispose();
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    final resolvedChild = child ?? const SizedBox.shrink();
    return resolvedChild;
  }
}
