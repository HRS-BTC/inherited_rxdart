import 'dart:async';

import 'package:inherited_rxdart/inherited_rxdart.dart';
import 'package:meta/meta.dart';

/// Base class for view model, extending this often required
abstract class BaseViewModel {
  @visibleForTesting
  final CompositeSubscription compositeSubscription = CompositeSubscription();

  @visibleForTesting
  final List<Subject<dynamic>> rxSubjects = [];

  final PublishSubject<dynamic> stateChangedSubject = PublishSubject();

  @protected
  @mustCallSuper
  void registerForStateChanged(Subject<dynamic> stream) {
    final subscription = stream.listen((event) {
      stateChangedSubject.add(null);
    });
    compositeSubscription.add(subscription);
  }

  @mustCallSuper
  @protected
  void registerEventHandler<T>(Stream<T> stream, RxEventHandler<T> handler) {
    final subscription = stream.listen((event) {
      handler.call(event);
    });
    compositeSubscription.add(subscription);
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
    rxSubjects.add(stateChangedSubject);
  }

  @mustCallSuper
  Future<void> dispose() async {
    await compositeSubscription.cancel();
    await Future.wait(rxSubjects.map((e) => e.close()));
    rxSubjects.clear();
  }
}
