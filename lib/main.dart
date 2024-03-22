import 'package:flutter/material.dart';
import 'package:flutter_progress_bar_assignment/progress_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: ProgressBar(
      duration: Duration(seconds: 10),
      progressBarType: ProgressBarType.linear,
    ));
  }
}
