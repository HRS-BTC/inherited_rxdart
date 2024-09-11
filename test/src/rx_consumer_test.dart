import 'package:flutter_test/flutter_test.dart';
import 'package:inherited_rxdart/inherited_rxdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../fixture/rx_listener_helper.dart';
import '../fixture/show_counter.dart';
import 'rx_consumer_test.mocks.dart';

@GenerateNiceMocks([MockSpec<RxListenerHelper>()])
void main() {
  late BehaviorSubject<int> subject;
  late MockRxListenerHelper helper;

  setUp(() {
    subject = BehaviorSubject<int>.seeded(0);
    helper = MockRxListenerHelper();
  });

  testWidgets("Render initial state", (tester) async {
    final expectedText = subject.value.toString();

    await tester.pumpWidget(
      RxConsumer(
        builder: (context, state) {
          return ShowCounterTest(value: state);
        },
        subjectGetter: (_) => subject,
      ),
    );
    final textFinder = find.text(expectedText);
    expect(textFinder, findsOne);
  });

  testWidgets("Render new state and perform callback", (tester) async {
    final prevValue = subject.value;
    const nextValue = 1;
    final expectedText = nextValue.toString();

    await tester.pumpWidget(
      RxConsumer(
        listener: (context, state) {
          helper.trigger(state);
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
    expect(textFinder, findsOne);
    verifyInOrder([
      helper.trigger(prevValue),
      helper.trigger(nextValue),
    ]);
    verifyNoMoreInteractions(helper);
  });

  tearDown(() {
    subject.close();
  });
}
