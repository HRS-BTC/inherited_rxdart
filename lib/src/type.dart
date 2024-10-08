import 'package:flutter/cupertino.dart';
import 'package:inherited_rxdart/src/holder.dart';
import 'package:rxdart/rxdart.dart';

/// Signature for event handler of registered [Subject]s inside [BaseViewModel]
typedef RxEventHandler<T> = void Function(T event);

/// Signature for event receiver of [RxListener]
typedef RxEventListener<T> = void Function(BuildContext context, T event);

/// Signature for building widget with states from the BehaviorSubject
typedef RxWidgetBuilder<T> = Widget Function(BuildContext context, T event);

/// Signature for selecting which state changes to respond to, for callbacks
/// of listener
typedef RxListenerStateFilter<T> = bool Function(
    BuildContext context, T? previous, T current);

/// Signature for selecting which state changes to respond to, for building
/// widgets
typedef RxBuilderStateFilter<T> = bool Function(
    BuildContext context, T previous, T current);

/// Signature for getting [Stream], commonly used for [PublishSubject]
typedef RxSubjectGetter<T> = Stream<T> Function(BuildContext context);

/// Signature for getting [BehaviorSubject], which will be used for building UI
/// with its state (or value)
typedef RxBehaviorSubjectGetter<T> = BehaviorSubject<T> Function(
    BuildContext context);

/// Signature for selecting properties of state object to listen to its changes
typedef RxValueSelector<T, V> = V Function(BuildContext context, T state);

/// Signature for retrieving multiple [Stream] to subscribe to.
typedef RxMultiSubjectsGetter = List<BehaviorSubject<Object?>> Function(
    BuildContext context);
typedef RxMultiSubjectsBuilder = Widget Function(
    BuildContext context, List<Holder> states);
