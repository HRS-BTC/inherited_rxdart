import 'package:flutter/material.dart';
import 'package:nested/nested.dart';
import 'package:collection/collection.dart';
import 'type.dart';
import 'rx_listener.dart';

class MultiRxBuilder extends StatefulWidget {
  const MultiRxBuilder({
    super.key,
    required this.builder,
    required this.subjectsGetter,
  });

  final WidgetBuilder builder;
  final RxMultiSubjectsGetter subjectsGetter;

  @override
  State<MultiRxBuilder> createState() => _MultiRxBuilderState();
}

class _MultiRxBuilderState extends State<MultiRxBuilder> {
  late final List<Stream<dynamic>> subjects;
  final listEq = const ListEquality();

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
      child: widget.builder.call(context),
    );
  }
}
