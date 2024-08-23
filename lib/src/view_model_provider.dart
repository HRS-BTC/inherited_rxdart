import 'package:flutter/cupertino.dart';
import 'package:inherited_rxdart/inherited_rxdart.dart';

class ViewModelProvider<T extends BaseViewModel> extends StatelessWidget {
  const ViewModelProvider({
    super.key,
    required Create<T> create,
    this.child,
    this.lazy = false,
  })  : _create = create,
        _value = null;

  final Create<T>? _create;
  final T? _value;
  final Widget? child;
  final bool lazy;

  const ViewModelProvider.value({
    super.key,
    required T value,
    this.child,
  })  : _create = null,
        _value = value,
        lazy = false;

  @override
  Widget build(BuildContext context) {
    if (_value != null) {
      return Provider<T>.value(
        value: _value,
        child: child,
      );
    }
    return Provider<T>(
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
      child: child,
    );
  }
}
