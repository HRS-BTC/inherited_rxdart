import 'package:flutter/cupertino.dart';

typedef RxEventHandler<T> = void Function(T event);

typedef RxEventListener<T> = void Function(BuildContext context, T event);
typedef RxWidgetBuilder<T> = Widget Function(BuildContext context, T event);
typedef RxBuilderStateFilter<T> = bool Function(
    BuildContext context, T previous, T current);
