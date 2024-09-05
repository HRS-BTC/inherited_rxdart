import 'dart:async';

import 'package:inherited_rxdart/inherited_rxdart.dart';
import 'package:meta/meta.dart';

abstract class BaseViewModel {
  @visibleForTesting
  final List<StreamSubscription<dynamic>> eventSubscriptions = [];
  @visibleForTesting
  final List<Subject<dynamic>> rxSubjects = [];

  final PublishSubject<dynamic> stateChangedSSubject = PublishSubject();

  @protected
  @mustCallSuper
  void registerForStateChanged(Subject<dynamic> stream) {
    final subscription = stream.listen((event) {
      stateChangedSSubject.add(null);
    });
    eventSubscriptions.add(subscription);
  }

  @mustCallSuper
  @protected
  void registerEventHandler<T>(Stream<T> stream, RxEventHandler<T> handler) {
    final subscription = stream.listen((event) {
      handler.call(event);
    });
    eventSubscriptions.add(subscription);
  }

  @protected
  @mustCallSuper
  void closeLater(List<Subject<dynamic>> subjects) {
    rxSubjects.addAll(subjects);
  }

  @protected
  @mustCallSuper
  void closeReleasableLater(List<ReleasableSubjects> subjects) {
    for (var element in subjects) {
      rxSubjects.addAll(element.subjects);
    }
  }

  @mustCallSuper
  void init() {
    rxSubjects.add(stateChangedSSubject);
  }

  @mustCallSuper
  Future<void> dispose() async {
    await Future.wait(eventSubscriptions.map((e) => e.cancel()));
    await Future.wait(rxSubjects.map((e) => e.close()));
    eventSubscriptions.clear();
    rxSubjects.clear();
  }
}
