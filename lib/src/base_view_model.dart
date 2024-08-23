import 'dart:async';

import 'package:inherited_rxdart/src/type.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

abstract class BaseViewModel {
  @visibleForTesting
  final List<StreamSubscription<dynamic>> eventSubscriptions = [];
  @visibleForTesting
  final List<Subject<dynamic>> rxSubjects = [];

  @mustCallSuper
  @protected
  void registerEventHandler<T>(Subject<T> stream, RxEventHandler<T> handler) {
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

  @mustCallSuper
  void init() {}

  @mustCallSuper
  void dispose() {
    for (var element in eventSubscriptions) {
      element.cancel();
    }
    for (var element in rxSubjects) {
      element.close();
    }
  }
}
