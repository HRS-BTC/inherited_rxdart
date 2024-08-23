import 'dart:async';

import 'package:inherited_rxdart/src/type.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

abstract class BaseViewModel {
  final List<StreamSubscription<dynamic>> _eventSubscriptions = [];

  @protected
  void registerEventHandler<T>(Subject<T> stream, RxEventHandler<T> handler) {
    final subscription = stream.listen((event) {
      handler.call(event);
    });
    _eventSubscriptions.add(subscription);
  }

  @mustCallSuper
  void init() {}

  @mustCallSuper
  void dispose() {
    for (var element in _eventSubscriptions) {
      element.cancel();
    }
  }
}
