import 'package:flutter/material.dart';
import 'package:randomizer/randomizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Randomizer',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 131, 245, 197)),
          useMaterial3: true,
        ),
        home: const Randomiser());
  }
}
