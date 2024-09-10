import 'package:example/counter_view_model.dart';
import 'package:flutter/material.dart';
import 'package:inherited_rxdart/inherited_rxdart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider(
      create: (BuildContext context) {
        return CounterViewModel();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(title),
        ),
        body: RxListener(
          listener: (BuildContext context, event) {
            debugPrint('event from state $event');
          },
          subjectGetter: (BuildContext context) {
            return context.read<CounterViewModel>().output.counterState;
          },
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'You have pushed the button this many times:',
                ),
                TextWidget(),
              ],
            ),
          ),
        ),
        floatingActionButton: const InteractiveButtons(),
      ),
    );
  }
}

class InteractiveButtons extends StatelessWidget {
  const InteractiveButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          onPressed: () => context
              .read<CounterViewModel>()
              .input
              .counterDecreaseEvent
              .add(true),
          tooltip: 'Decrease',
          child: const Icon(Icons.horizontal_rule),
        ),
        FloatingActionButton(
          onPressed: () => context
              .read<CounterViewModel>()
              .input
              .counterIncreaseEvent
              .add(true),
          tooltip: 'Increase',
          child: const Icon(Icons.add),
        ),
      ],
    );
  }
}

class TextWidget extends StatelessWidget {
  const TextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return RxBuilder(
      filter: (context, prev, curr) {
        return curr % 2 == 1;
      },
      builder: (context, state) {
        return Text(
          '$state',
          style: Theme.of(context).textTheme.headlineMedium,
        );
      },
      subjectGetter: (BuildContext context) {
        return context.read<CounterViewModel>().output.counterState;
      },
    );
  }
}
