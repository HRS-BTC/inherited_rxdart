import 'package:flutter/material.dart';
import 'package:nested/nested.dart';
import 'package:collection/collection.dart';
import 'type.dart';
import 'rx_listener.dart';

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
  final WidgetBuilder builder;

  /// Retrieve [Stream]s to subscribe to trigger rebuilds
  final RxMultiSubjectsGetter subjectsGetter;

  @override
  State<MultiRxBuilder> createState() => _MultiRxBuilderState();
}

class _MultiRxBuilderState extends State<MultiRxBuilder> {
  late List<Stream<dynamic>> subjects;
  final listEq = const ListEquality();
  final stateKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    subjects = widget.subjectsGetter.call(context);
  }

  @override
  void didUpdateWidget(covariant MultiRxBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.subjectsGetter != oldWidget.subjectsGetter) {
      final newSubjects = widget.subjectsGetter.call(context);
      if (!listEq.equals(newSubjects, subjects)) {
        subjects = newSubjects;
      }
    }
  }

  void _update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Nested(
      children: List.generate(
        subjects.length,
        (index) {
          return RxListener(
            listener: (_, __) => _update(),
            subjectGetter: (_) => subjects[index],
          );
        },
      ),
      child: KeyedSubtree(
        // prevent state lost when re-position node-wise
        key: stateKey,
        child: widget.builder.call(context),
      ),
    );
  }
}
