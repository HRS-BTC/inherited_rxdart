import 'package:flutter/material.dart';
import 'package:inherited_rxdart/inherited_rxdart.dart';

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
  late T _state;
  bool _isFirstEvent = true;

  @override
  void initState() {
    super.initState();
    final subject = widget.subjectGetter.call(context);
    assert(subject.hasValue);
    _state = subject.value;
  }

  bool _shouldRebuild(T state) {
    if (_isFirstEvent) {
      _isFirstEvent = false;
      return false;
    }
    if (_state == state) {
      return false;
    }
    if (widget.filter == null) {
      return true;
    }
    return widget.filter!.call(context, _state, state);
  }

  void _stateChanged(BuildContext context, T state) {
    bool needBuild = _shouldRebuild(state);
    if (!needBuild) {
      return;
    }
    setState(() {
      _state = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RxListener(
      listener: _stateChanged,
      subjectGetter: widget.subjectGetter,
      child: widget.builder.call(context, _state),
    );
  }
}
