import 'dart:async';

import 'package:flutter/material.dart';
import 'type.dart';

class RxBuilder<T> extends StatefulWidget {
  const RxBuilder({
    super.key,
    required this.builder,
    required this.subjectGetter,
    this.filter,
  });

  final RxWidgetBuilder<T> builder;
  final RxStateFilter<T>? filter;
  final RxBehaviorSubjectGetter<T> subjectGetter;

  @override
  State<RxBuilder<T>> createState() => _RxBuilderState<T>();
}

class _RxBuilderState<T> extends State<RxBuilder<T>> {
  StreamSubscription<T>? _subscription;
  late T _state;

  @override
  void initState() {
    super.initState();
    final subject = widget.subjectGetter.call(context);
    assert(subject.hasValue);
    _state = subject.value;
    _subscription = subject.listen(_handleEvent);
  }

  void _handleEvent(T event) {
    bool needBuild = _shouldBuild(event);
    if (!needBuild) {
      return;
    }
    setState(() {
      _state = event;
    });
  }

  bool _shouldBuild(T event) {
    if (_state == event) {
      return false;
    }
    if (widget.filter == null) {
      return true;
    }
    return widget.filter!.call(context, _state, event);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder.call(context, _state);
  }
}
