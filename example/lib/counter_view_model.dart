import 'package:inherited_rxdart/inherited_rxdart.dart';

class CounterViewModel extends BaseViewModel {
  CounterViewModel() {
    registerEventHandler(counterIncreaseEvent, _handleIncreaseCounter);
    registerEventHandler(counterDecreaseEvent, _handleDecreaseCounter);
    closeLater([counterState, counterIncreaseEvent, counterDecreaseEvent]);
  }

  final counterState = BehaviorSubject.seeded(0);

  final counterIncreaseEvent = PublishSubject<bool>();
  final counterDecreaseEvent = PublishSubject<bool>();

  void _handleIncreaseCounter(bool event) {
    counterState.add(counterState.value + 1);
  }

  void _handleDecreaseCounter(bool event) {
    counterState.add(counterState.value - 1);
  }
}
