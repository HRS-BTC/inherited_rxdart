import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:inherited_rxdart/inherited_rxdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'rx_listener_test.mocks.dart';

abstract class RxListenerHelper<T> {
  void trigger(T value);

  void dualNumberCall(T a, T b);
}

@GenerateNiceMocks([MockSpec<RxListenerHelper>()])
void main() {
  late PublishSubject<int> subject;
  late MockRxListenerHelper helper;

  setUp(() {
    subject = PublishSubject<int>();
    helper = MockRxListenerHelper();
  });

  group("listener trigger", () {
    testWidgets("trigger listener", (tester) async {
      await tester.pumpWidget(
        RxListener(
          listener: (context, state) {
            helper.trigger(state);
          },
          subjectGetter: (_) => subject,
          child: const SizedBox(),
        ),
      );

      final events = <int>[5, 10, 15, 20];
      for (var element in events) {
        subject.add(element);
      }
      await subject.close();
      verifyInOrder(events.map((e) => helper.trigger(e)).toList());
      verifyNoMoreInteractions(helper);
    });

    testWidgets("trigger listener filtered first time has same prev and curr", (tester) async {
      await tester.pumpWidget(
        RxListener(
          filter: (context, prev, curr) {
            helper.dualNumberCall(prev, curr);
            return true;
          },
          listener: (context, state) {
            helper.trigger(state);
          },
          subjectGetter: (_) => subject,
          child: const SizedBox(),
        ),
      );

      const event = 5;
      subject.add(event);
      await subject.close();
      verify(helper.dualNumberCall(event, event)).called(1);
      verify(helper.trigger(event)).called(1);
      verifyNoMoreInteractions(helper);
    });
    testWidgets("trigger listener filtered", (tester) async {
      bool filterCond(int value) => value % 10 == 0;
      await tester.pumpWidget(
        RxListener(
          filter: (context, prev, curr) {
            return filterCond(curr);
          },
          listener: (context, state) {
            helper.trigger(state);
          },
          subjectGetter: (_) => subject,
          child: const SizedBox(),
        ),
      );

      final events = <int>[5, 10, 15, 20];
      for (var element in events) {
        subject.add(element);
      }
      await subject.close();

      final expectedList = events.where(filterCond);
      final notExpectedList = events.whereNot(filterCond);
      verifyInOrder(expectedList.map((e) => helper.trigger(e)).toList());
      for (var e in notExpectedList) {
        verifyNever(helper.trigger(e));
      }
      verifyNoMoreInteractions(helper);
    });
  });

  testWidgets("change subjects", (tester) async {
    final newSubjects = PublishSubject<int>();

    await tester.pumpWidget(
      RxListener(
        listener: (context, state) {
          helper.trigger(state);
        },
        subjectGetter: (_) => subject,
        child: const SizedBox(),
      ),
    );

    await tester.pumpWidget(
      RxListener(
        listener: (context, state) {
          helper.trigger(state);
        },
        subjectGetter: (_) => newSubjects,
        child: const SizedBox(),
      ),
    );

    final events1 = <int>[5, 10, 15, 20];
    final events2 = <int>[25, 30, 35, 40];
    for (var element in events1) {
      subject.add(element);
    }
    for (var element in events2) {
      newSubjects.add(element);
    }
    await subject.close();
    await newSubjects.close();
    verifyInOrder(events2.map((e) => helper.trigger(e)).toList());
    for (var element in events1) {
      verifyNever(helper.trigger(element));
    }
    verifyNoMoreInteractions(helper);
  });
}
