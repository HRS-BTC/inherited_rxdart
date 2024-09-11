import 'package:inherited_rxdart/inherited_rxdart.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fixture/show_counter.dart';

void main() {
  late BehaviorSubject<int> subject;

  setUp(() {
    subject = BehaviorSubject<int>.seeded(0);
  });

  testWidgets("Un-seeded behaviorSubject throw error", (tester) async {
    final unSeededSubject = BehaviorSubject<int>();
    addTearDown(() {
      unSeededSubject.close();
    });

    await tester.pumpWidget(
      RxBuilder(
        builder: (context, state) {
          return ShowCounterTest(value: state);
        },
        subjectGetter: (_) => unSeededSubject,
      ),
    );

    expect(tester.takeException(), isInstanceOf<AssertionError>());
  });

  testWidgets("Render initial state", (tester) async {
    final expectedText = subject.value.toString();

    await tester.pumpWidget(
      RxBuilder(
        builder: (context, state) {
          return ShowCounterTest(value: state);
        },
        subjectGetter: (_) => subject,
      ),
    );
    final textFinder = find.text(expectedText);
    expect(textFinder, findsOne);
  });

  testWidgets("Render new state", (tester) async {
    const nextValue = 1;
    final expectedText = nextValue.toString();

    await tester.pumpWidget(
      RxBuilder(
        builder: (context, state) {
          return ShowCounterTest(value: state);
        },
        subjectGetter: (_) => subject,
      ),
    );
    subject.add(nextValue);
    await tester.pump();
    final textFinder = find.text(expectedText);
    expect(textFinder, findsOne);
  });

  testWidgets("Render new state respect filter", (tester) async {
    const nextValue = 1;
    final expectedText = subject.value.toString();
    final notExpectedText = nextValue.toString();
    bool renderCond(int value) => value % 2 == 0;

    await tester.pumpWidget(
      RxBuilder(
        filter: (context, prev, curr) {
          return renderCond.call(curr);
        },
        builder: (context, state) {
          return ShowCounterTest(value: state);
        },
        subjectGetter: (_) => subject,
      ),
    );
    subject.add(nextValue);
    await tester.pump();
    final textFinder = find.text(expectedText);
    final textFinder2 = find.text(notExpectedText);
    expect(textFinder, findsOne);
    expect(textFinder2, findsNothing);
  });

  tearDown(() {
    subject.close();
  });
}
