// ignore: unused_import
import 'dart:developer' as dev;

import 'dart:math';
import 'package:vector_math/vector_math.dart';

import 'package:flutter/material.dart';
import 'package:game/Utils/utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: themeMode,
      home: MyHome(),
    );
  }
}

class ThemeModeSelect extends StatelessWidget {
  const ThemeModeSelect({
    super.key,
    required this.updateTheme,
    required this.height,
    required this.width,
  });

  final VoidCallback updateTheme;

  final double width;

  final double height;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: updateTheme,
      style: ElevatedButton.styleFrom(
          minimumSize: Size(width, height),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      child: Text(theme, style: const TextStyle(fontSize: 20)),
    );
  }
}

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  double yAxis = 15;

  double x = 0.0;
  double y = 0.0;

  double angle = 0;

  void _updateLocation(PointerEvent details) {
    setState(() {
      x = details.position.dx - (MediaQuery.of(context).size.width / 2);
      y = (MediaQuery.of(context).size.height - details.position.dy) -
          (MediaQuery.of(context).size.height / 2);
    });
    _updateAngle(x, y);
  }

  _updateAngle(double x, double y) {
    final deltaX = x - 0;
    final deltaY = y - 0;

    final rad = atan2(deltaY, deltaX);

    final deg = rad * (180 / pi);

    setState(() {
      if (x < 0 && y > 0) {
        angle = (450 - deg);
        return;
      }
      angle = (deg - 90).abs();
    });
  }

  moveCharacter() {
    setState(() {
      yAxis = 30;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => moveCharacter(),
        child: MouseRegion(
          onHover: _updateLocation,
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: Duration(seconds: 3),
                right: 700,
                top: 400,
                child: Transform.rotate(
                    angle: radians(angle), child: const Character()),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  "X: $x       Y: $y      Angle: $angle",
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: ThemeModeSelect(
                    height: 60, width: 100, updateTheme: updateTheme),
              )
            ],
          ),
        ),
      ),
    );
  }

  updateTheme() => setState(() {
        if (theme == "Dark") {
          themeMode = lightMode;
          theme = "Light";
        } else {
          theme = "Dark";
          themeMode = darkMode;
        }
      });
}

class Character extends StatelessWidget {
  const Character({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.rocket_rounded,
      size: 50,
    );
  }
}
