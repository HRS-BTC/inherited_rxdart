import 'package:flutter/material.dart';
import 'package:inherited_rxdart/inherited_rxdart.dart';

/// Subscribe to a [BehaviorSubject.seeded] and use its [BehaviorSubject.value]
/// to build UI correspondingly.
class RxBuilder<T> extends StatefulWidget {
  const RxBuilder({
    super.key,
    required this.builder,
    required this.subjectGetter,
    this.filter,
  });

  /// Current and updated values of [BehaviorSubject] will trigger the
  /// rebuilding and provide current value as a parameter for building UI
  final RxWidgetBuilder<T> builder;

  /// Similar to [RxListener.filter], used for subscribing to certain aspect
  /// of the whole state object to rebuild.
  final RxStateFilter<T>? filter;

  /// Retrieval for a [BehaviorSubject.seeded], or generally, a [BehaviorSubject]
  /// with [BehaviorSubject.hasValue] equal to [true]. This is needed to
  /// warrant the widget building behavior, since all building operation inside
  /// the framework are done in a asynchronous way, data, or state, used for
  /// rendering must exist first.
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
