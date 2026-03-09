import 'package:flutter/material.dart';
import 'screens/mapa_screen.dart';

void main() {
  runApp(const BodUjepApp());
}

class BodUjepApp extends StatelessWidget {
  const BodUjepApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BOD. UJEP',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
      ),
      home: const MapaScreen(),
    );
  }
}