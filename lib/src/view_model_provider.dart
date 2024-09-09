import 'package:flutter/cupertino.dart';
import 'package:inherited_rxdart/inherited_rxdart.dart';

/// Widget for injecting [BaseViewModel] to a subtree
class ViewModelProvider<T extends BaseViewModel> extends SingleChildStatelessWidget {
  const ViewModelProvider({
    super.key,
    required Create<T> create,
    super.child,
    this.lazy = false,
  })  : _create = create,
        _value = null;

  final Create<T>? _create;
  final T? _value;
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

  const ViewModelProvider.value({
    super.key,
    required T value,
    super.child,
  })  : _create = null,
        _value = value,
        lazy = false;

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
