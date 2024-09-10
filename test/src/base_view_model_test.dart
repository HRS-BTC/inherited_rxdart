import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inherited_rxdart/inherited_rxdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'base_view_model_test.mocks.dart';

import '../fixture/counter_view_model.dart';

abstract class Handler<T> {
  void handle(T value);
}

@GenerateNiceMocks([MockSpec<ReleasableSubjects>(), MockSpec<Handler>()])
void main() {
  const listEqual = ListEquality();
  late CounterViewModel vm;
  setUp(() {
    vm = CounterViewModel();
  });

  test('init', () {
    vm.init();
    final subjects = vm.rxSubjects;
    expect(subjects.length, 1);
    expect(subjects.firstOrNull, vm.stateChangedSubject);
  });

  test("register for state changed", () {
    final streamController = StreamController();
    final externalStream = streamController.stream;
    final stateChangedSubject = vm.stateChangedSubject;
    final compositeSubs = vm.compositeSubscription;

    addTearDown(() {
      streamController.close();
    });

    streamController.add(null);
    vm.registerForStateChanged(externalStream);

    expect(compositeSubs.length, 1);
    expectLater(stateChangedSubject, emits(null));
  });
  tearDown(() {
    vm.dispose();
  });

  test("close later", () {
    const length = 10;
    final subjects = List.generate(length, (index) => PublishSubject());
    final vmSubjects = vm.rxSubjects;

    addTearDown(() {
      for (var element in subjects) {
        element.close();
      }
    });

    vm.closeLater(subjects);

    expect(listEqual.equals(vmSubjects, subjects), true);
  });

  test("dispose", () async {
    const length = 10;
    final subjects = List.generate(length, (index) => PublishSubject());

    vm.closeLater(subjects);
    await vm.dispose();

    expect(vm.compositeSubscription.isDisposed, true);

    expect(subjects.every((element) => element.isClosed), true);
  });

  test("close releasable later", () {
    const length = 10;
    final subjects = List.generate(length, (index) => PublishSubject());
    final releasable = List.generate(length, (index) {
      final mockObj = MockReleasableSubjects();
      when(mockObj.subjects).thenReturn([subjects[index]]);
      return mockObj;
    });
    final vmSubjects = vm.rxSubjects;

    addTearDown(() {
      for (var element in subjects) {
        element.close();
      }
    });

    vm.closeReleasableLater(releasable);

    expect(listEqual.equals(vmSubjects, subjects), true);
    for (var element in releasable) {
      verify(element.subjects).called(1);
    }
  });

  test("register event handler", () async {
    const event = 50;
    final handler = MockHandler<int>();
    final subject = PublishSubject<int>();
    final compositeSubs = vm.compositeSubscription;

    vm.registerEventHandler(subject, handler.handle);
    subject.add(event);
    await subject.close();
    expect(compositeSubs.length, 1);
    verify(handler.handle(event)).called(1);
  });
}
