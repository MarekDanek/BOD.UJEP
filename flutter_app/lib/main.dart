import 'package:bod_ujep_app/screens/start_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const BodUjepApp());
}

class BodUjepApp extends StatelessWidget {
  const BodUjepApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navandr',
      theme: ThemeData(
      fontFamily: "Topol",
      ),
      builder: (context, child) {
        return DefaultTextStyle.merge(
          style: const TextStyle(fontWeight: FontWeight.bold),
          child: child!,
        );
      },
      home: const StartScreen(),
    );
  }
}