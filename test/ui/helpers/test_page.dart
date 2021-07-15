import 'package:flutter/material.dart';

class TestPage extends StatelessWidget {
  final WidgetBuilder test;

  const TestPage(this.test);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          body: test(context),
        ),
      ),
    );
  }
}
