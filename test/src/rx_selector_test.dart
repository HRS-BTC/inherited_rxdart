import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inherited_rxdart/inherited_rxdart.dart';

class SelectorWidgetTest extends StatelessWidget {
  const SelectorWidgetTest({super.key, required this.value});

  final int value;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(value.toString()),
            ],
          ),
        ),
      ),
    );
  }
}

class ValueObject {
  final int a;
  final int b;

  const ValueObject({
    required this.a,
    required this.b,
  });

  ValueObject copyWith({int? a, int? b}) {
    return ValueObject(a: a ?? this.a, b: b ?? this.b);
  }
}

void main() {
  late BehaviorSubject<ValueObject> subject;

  setUp(() {
    const valueObject = ValueObject(a: 1, b: 2);
    subject = BehaviorSubject<ValueObject>.seeded(valueObject);
  });

  testWidgets("Render initial state", (tester) async {
    final expectedTextA = subject.value.a.toString();

    await tester.pumpWidget(
      RxSelector(
        builder: (context, state) {
          return SelectorWidgetTest(value: state);
        },
        subjectGetter: (_) => subject,
        valueSelector: (BuildContext context, ValueObject state) {
          return state.a;
        },
      ),
    );
    final textFinderA = find.text(expectedTextA);
    expect(textFinderA, findsOne);
  });

  testWidgets("Render new state match filter", (tester) async {
    const newValue = ValueObject(a: 5, b: 10);
    final expectedTextA = newValue.a.toString();

    await tester.pumpWidget(
      RxSelector(
        builder: (context, state) {
          return SelectorWidgetTest(value: state);
        },
        subjectGetter: (_) => subject,
        valueSelector: (BuildContext context, ValueObject state) {
          return state.a;
        },
      ),
    );
    subject.add(newValue);
    await tester.pump();
    final textFinderA = find.text(expectedTextA);
    expect(textFinderA, findsOne);
  });

  tearDown(() {
    subject.close();
  });
}
