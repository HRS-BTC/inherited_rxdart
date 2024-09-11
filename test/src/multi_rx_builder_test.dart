import 'package:flutter/material.dart';
import 'package:inherited_rxdart/inherited_rxdart.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fixture/show_counter.dart';

void main() {
  late List<BehaviorSubject<int>> subjects;
  const subjectsCount = 10;

  setUp(() {
    subjects =
        List.generate(subjectsCount, (index) => BehaviorSubject.seeded(index));
  });

  testWidgets("Render initial state", (tester) async {
    int selectedIndex = (subjectsCount / 2).floor();
    final expectedText = subjects[selectedIndex].value.toString();

    await tester.pumpWidget(
      MultiRxBuilder(
        builder: (context) {
          final state = subjects[selectedIndex].value;
          return ShowCounterTest(value: state);
        },
        subjectsGetter: (BuildContext context) {
          return subjects;
        },
      ),
    );
    final textFinder = find.text(expectedText);
    expect(textFinder, findsOne);
  });

  testWidgets("Render next state", (tester) async {
    int selectedIndex = (subjectsCount / 2).floor();
    const nextEvent = 100;
    final expectedText = nextEvent.toString();

    await tester.pumpWidget(
      MultiRxBuilder(
        builder: (context) {
          final state = subjects[selectedIndex].value;
          return ShowCounterTest(value: state);
        },
        subjectsGetter: (BuildContext context) {
          return subjects;
        },
      ),
    );

    subjects[selectedIndex].add(nextEvent);
    await tester.pump();
    final textFinder = find.text(expectedText);
    expect(textFinder, findsOne);
  });

  testWidgets("handle next state of changedSubjects", (tester) async {
    int selectedIndex = (subjectsCount / 2).floor();
    final newSubjects = List.generate(
        subjectsCount, (index) => BehaviorSubject.seeded(index + 100));
    final expectedText = newSubjects[selectedIndex].value.toString();

    addTearDown(() {
      for (var element in newSubjects) {
        element.close();
      }
    });

    await tester.pumpWidget(
      MultiRxBuilder(
        builder: (context) {
          final state = subjects[selectedIndex].value;
          return ShowCounterTest(value: state);
        },
        subjectsGetter: (BuildContext context) {
          return subjects;
        },
      ),
    );
    await tester.pumpWidget(
      MultiRxBuilder(
        builder: (context) {
          final state = newSubjects[selectedIndex].value;
          return ShowCounterTest(value: state);
        },
        subjectsGetter: (BuildContext context) {
          return newSubjects;
        },
      ),
    );

    final textFinder = find.text(expectedText);
    expect(textFinder, findsOne);
  });
  tearDown(() {
    for (var element in subjects) {
      element.close();
    }
    subjects.clear();
  });
}
