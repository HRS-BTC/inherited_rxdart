import 'package:flutter/cupertino.dart';
import 'package:inherited_rxdart/inherited_rxdart.dart';

/// Widget for injecting [BaseViewModel] to a subtree. Child widget can then
/// use the [Provider] extension [context.read] (or [context.watch]) to retrieve
/// injected object of type [T].
/// Multiple [ViewModelProvider] can also be injected without wrapping each
/// other by the use of [Nested]
class ViewModelProvider<T extends BaseViewModel>
    extends SingleChildStatelessWidget {
  /// Create a new [BaseViewModel], calling [BaseViewModel.init] and
  /// inject it to the [child] subtree. When this widget is dismounted,
  /// [BaseViewModel.dispose] will be called and release resources accordingly.
  const ViewModelProvider({
    super.key,
    required Create<T> create,
    super.child,
    this.lazy = false,
  })  : _create = create,
        _value = null;

  /// Inject already existed and managed [BaseViewModel] to the [child] subtree,
  /// will not call [BaseViewModel.init] or [BaseViewModel.dispose].
  /// Use [ViewModelProvider] instead to have self-managed [BaseViewModel]
  /// lifecycle.
  /// For [BaseViewModel] created outside of [ViewModelProvider], its lifecycle
  /// may be managed by calling [State.initState] and [State.dispose]
  /// respectively.
  const ViewModelProvider.value({
    super.key,
    required T value,
    super.child,
  })  : _create = null,
        _value = value,
        lazy = false;

  final Create<T>? _create;
  final T? _value;

  /// Whether to immediately create the [BaseViewModel] in case of using
  /// [ViewModelProvider] or wait until the first time it's required through the
  /// use of [context.read] (or [context.watch])
  final bool lazy;

  static VoidCallback _startListening<T extends BaseViewModel>(
    InheritedContext<T?> element,
    T viewModel,
  ) {
    final subscription = viewModel.stateChangedSubject.listen(
      (_) => element.markNeedsNotifyDependents(),
    );
    return subscription.cancel;
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    if (_value != null) {
      return InheritedProvider<T>.value(
        value: _value,
        startListening: _startListening,
        child: child,
      );
    }
    return InheritedProvider<T>(
      lazy: lazy,
      create: (context) {
        assert(_create != null);
        final viewModel = _create!.call(context);
        viewModel.init();
        return viewModel;
      },
      dispose: (context, viewModel) {
        viewModel.dispose();
      },
      startListening: _startListening,
      child: child,
    );
  }
}
