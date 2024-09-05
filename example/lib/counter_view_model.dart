import 'package:inherited_rxdart/inherited_rxdart.dart';

class Input with ReleasableSubjects {
  const Input(
    this.counterDecreaseEvent,
    this.counterIncreaseEvent,
  );

  final PublishSubject<bool> counterIncreaseEvent;
  final PublishSubject<bool> counterDecreaseEvent;

  @override
  List<Subject> get subjects => [
        counterDecreaseEvent,
        counterDecreaseEvent,
      ];
}

class Output with ReleasableSubjects {
  const Output(this.counterState);

  final BehaviorSubject<int> counterState;

  @override
  List<Subject> get subjects => [counterState];
}

class CounterViewModel extends BaseViewModel {
  late final Input input;
  late final Output output;

  CounterViewModel({int initialState = 0}) {
    input = Input(
      PublishSubject(),
      PublishSubject(),
    );
    output = Output(
      BehaviorSubject.seeded(initialState),
    );
    closeReleasableLater([input, output]);
    registerEventHandler(input.counterIncreaseEvent, _handleIncreaseCounter);
    registerEventHandler(input.counterDecreaseEvent, _handleDecreaseCounter);
  }

  void _handleIncreaseCounter(bool event) {
    output.counterState.add(output.counterState.value + 1);
  }

  void _handleDecreaseCounter(bool event) {
    output.counterState.add(output.counterState.value - 1);
  }
}
