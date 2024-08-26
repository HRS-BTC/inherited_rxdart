import 'package:flutter/cupertino.dart';
import 'package:inherited_rxdart/inherited_rxdart.dart';

typedef RxEventHandler<T> = void Function(T event);

typedef RxEventListener<T> = void Function(BuildContext context, T event);
typedef RxWidgetBuilder<T> = Widget Function(BuildContext context, T event);
typedef RxStateFilter<T> = bool Function(
    BuildContext context, T previous, T current);
typedef RxSubjectGetter<T> = Subject<T> Function(BuildContext context);
typedef RxBehaviorSubjectGetter<T> = BehaviorSubject<T> Function(
    BuildContext context);
