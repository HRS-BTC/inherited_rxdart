import 'package:flutter/material.dart';

class ShowCounterTest extends StatelessWidget {
  const ShowCounterTest({super.key, required this.value});

  final int value;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        body: Center(
          child: Text(value.toString()),
        ),
      ),
    );
  }
}
