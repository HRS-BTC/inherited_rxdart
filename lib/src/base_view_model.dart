import 'dart:async';

import 'package:inherited_rxdart/src/type.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

abstract class BaseViewModel {
  final List<StreamSubscription<dynamic>> _eventSubscriptions = [];
  final List<Subject<dynamic>> _subjects = [];

  @protected
  void registerEventHandler<T>(Subject<T> stream, RxEventHandler<T> handler) {
    final subscription = stream.listen((event) {
      handler.call(event);
    });
    _eventSubscriptions.add(subscription);
  }

  void closeLater(List<Subject<dynamic>> subjects) {
    _subjects.addAll(subjects);
  }

  @mustCallSuper
  void init() {}

  @mustCallSuper
  void dispose() {
    for (var element in _eventSubscriptions) {
      element.cancel();
    }
    for (var element in _subjects) {
      element.close();
    }
  }
}
