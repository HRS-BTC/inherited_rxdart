import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:inherited_rxdart/inherited_rxdart.dart';
import 'package:meta/meta.dart';

/// Subclass of [BaseViewModel] will have its lifecycle managed by
/// [ViewModelProvider], important methods to override are [init] and [dispose]
/// in case to interfere with resources clean up and initialization
abstract class BaseViewModel {
  /// When register multiple event handler with [registerEventHandler] or
  /// combine subjects as an identity for this [BaseViewModel], subscriptions
  /// will be disposed through this property
  @visibleForTesting
  final CompositeSubscription compositeSubscription = CompositeSubscription();

  /// RxDart's [Subject]s usually need to be dispose/release because it is in
  /// its core just a [StreamController], this properties help to release such
  /// resources later
  @visibleForTesting
  final List<Subject<dynamic>> rxSubjects = [];

  /// The state identity of this [BaseViewModel], will trigger update in
  /// [RxBuilder] and [RxListener] when provide this to the [RxSubjectGetter]s
  /// This will also trigger the update of widgets when used with
  /// [context.watch]
  /// But by the design of this library and the app, such cases are often not
  /// needed
  final PublishSubject<dynamic> stateChangedSubject = PublishSubject();

  /// Register a [Stream] as a part of this [BaseViewModel] identity, represented
  /// by [stateChangedSubject]
  @protected
  @mustCallSuper
  void registerForStateChanged(Stream<dynamic> stream) {
    final subscription = stream.listen((event) {
      stateChangedSubject.add(null);
    });
    compositeSubscription.add(subscription);
  }

  /// Commonly used for register event handler for [Stream], or [PublishSubject],
  /// will auto dispose the subscription with [compositeSubscription]
  @mustCallSuper
  @protected
  void registerEventHandler<T>(Stream<T> stream, RxEventHandler<T> handler) {
    final subscription = stream.listen((event) {
      handler.call(event);
    });
    compositeSubscription.add(subscription);
  }

  /// Used for registering a subjects for disposing later. This should be used
  /// on user defined [Subject] in [BaseViewModel]
  @protected
  @mustCallSuper
  void closeLater(List<Subject<dynamic>> subjects) {
    rxSubjects.addAll(subjects);
  }

  /// [ReleasableSubjects] act as retriever for external objects with multiple
  /// [Subject]s as properties, register them here to release all of those
  /// [Subject]s
  @protected
  @mustCallSuper
  void closeReleasableLater(List<ReleasableSubjects> subjects) {
    for (var element in subjects) {
      rxSubjects.addAll(element.subjects);
    }
  }

  /// Override this for performing initialization when widget's mounted.
  @mustCallSuper
  void init() {
    rxSubjects.add(stateChangedSubject);
  }

  /// Release previously registered resources, override this to perform clean
  /// up as needed.
  @mustCallSuper
  Future<void> dispose() async {
    await compositeSubscription.cancel();
    await Future.wait(rxSubjects.map((e) => e.close()));
    rxSubjects.clear();
  }
}
