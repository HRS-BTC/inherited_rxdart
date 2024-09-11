import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inherited_rxdart/inherited_rxdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'view_model_provider_test.mocks.dart';

@GenerateNiceMocks([MockSpec<BaseViewModel>()])
void main() {
  late MockBaseViewModel vm;
  late PublishSubject subject;

  setUp(() {
    vm = MockBaseViewModel();
    subject = PublishSubject();
    when(vm.stateChangedSubject).thenAnswer((_) => subject);
  });

  group("creating view model", () {
    testWidgets("lazy false", (tester) async {
      await tester.pumpWidget(
        ViewModelProvider(
          create: (context) {
            return vm;
          },
          lazy: false,
          child: const SizedBox(),
        ),
      );
      verify(vm.init()).called(1);
    });

    testWidgets("lazy true", (tester) async {
      await tester.pumpWidget(
        ViewModelProvider(
          create: (context) {
            return vm;
          },
          lazy: true,
          child: const SizedBox(),
        ),
      );
      verifyNever(vm.init());
    });
  });

  testWidgets("inject managed view model ", (tester) async {
    await tester.pumpWidget(
      ViewModelProvider.value(
        value: vm,
        child: const SizedBox(),
      ),
    );
    verifyNever(vm.init());
  });

  testWidgets("trigger inside start listening", (tester) async {
    await tester.pumpWidget(
      ViewModelProvider(
        create: (context) {
          return vm;
        },
        lazy: false,
        child: const SizedBox(),
      ),
    );
    subject.add(null);
  });

  group("dispose view model", () {
    testWidgets("dispose created vm", (tester) async {
      await tester.pumpWidget(
        ViewModelProvider(
          create: (context) {
            return vm;
          },
          lazy: false,
          child: const SizedBox(),
        ),
      );
      await tester.pumpWidget(Container());
      verify(vm.dispose()).called(1);
    });

    testWidgets("not dispose managed vm elsewhere", (tester) async {
      await tester.pumpWidget(
        ViewModelProvider.value(
          value: vm,
          child: const SizedBox(),
        ),
      );
      await tester.pumpWidget(Container());
      verifyNever(vm.dispose());
    });
  });
  tearDown(() {
    subject.close();
  });
}
