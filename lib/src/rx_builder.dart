import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'type.dart';

class RxBuilder<T> extends StatefulWidget {
  const RxBuilder({
    super.key,
    required this.builder,
    required this.subject,
    this.filter,
  });

  final RxWidgetBuilder<T> builder;
  final RxBuilderStateFilter<T>? filter;
  final BehaviorSubject<T> subject;

  @override
  State<RxBuilder<T>> createState() => _RxBuilderState<T>();
}

class _RxBuilderState<T> extends State<RxBuilder<T>> {
  StreamSubscription<T>? _subscription;
  late T _state;

  @override
  void initState() {
    super.initState();
    assert(widget.subject.hasValue);
    _state = widget.subject.value;
    _subscription = widget.subject.listen(_handleEvent);
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
