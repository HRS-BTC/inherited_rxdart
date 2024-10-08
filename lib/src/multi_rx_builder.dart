import 'dart:async';

import 'package:flutter/material.dart';
import 'package:inherited_rxdart/inherited_rxdart.dart';
import 'package:collection/collection.dart';

import 'holder.dart';

/// Serve as a way to subscribe to multiple [Stream] at once, and will trigger
/// the [builder] function when new event emitted
class MultiRxBuilder extends StatefulWidget {
  const MultiRxBuilder({
    super.key,
    required this.builder,
    required this.subjectsGetter,
  });

  /// Re-trigger when new [Stream]s's event fired. The retrieval of data needed
  /// to build is to be acquired in this function
  final RxMultiSubjectsBuilder builder;

  /// Retrieve [Stream]s to subscribe to trigger rebuilds
  final RxMultiSubjectsGetter subjectsGetter;

  @override
  State<MultiRxBuilder> createState() => _MultiRxBuilderState();
}

class _MultiRxBuilderState extends State<MultiRxBuilder> {
  late List<BehaviorSubject<Object?>> _subjects;
  List<Holder> _states = [];
  final _listEq = const ListEquality();
  StreamSubscription? subs;

  @override
  void initState() {
    super.initState();
    _subjects = widget.subjectsGetter.call(context);
    _updateStates(_subjects);
    _subscribe(_subjects);
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant MultiRxBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.subjectsGetter != oldWidget.subjectsGetter) {
      final newSubjects = widget.subjectsGetter.call(context);
      if (!_listEq.equals(newSubjects, _subjects)) {
        _unsubscribe();
        _subjects = newSubjects;
        _subscribe(newSubjects);
      }
    }
  }

  void _subscribe(List<BehaviorSubject<Object?>> subjects) {
    final stream = Rx.combineLatest<Object?, List<Holder>>(subjects, (states) {
      return states.map((e) => Holder(e)).toList();
    });
    _updateStates(subjects);
    subs = stream.listen(_update);
  }

  void _unsubscribe() {
    subs?.cancel();
  }

  void _updateStates(List<BehaviorSubject<Object?>> subjects) {
    _states = subjects.map((e) => Holder(e.value)).toList();
  }

  void _update(List<Holder> states) {
    setState(() {
      _states = states;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder.call(context, _states);
  }
}
