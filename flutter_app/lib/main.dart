import 'package:bod_ujep_app/screens/start_screen.dart';
import 'package:bod_ujep_app/admin/screens/login_screen.dart'; // Import tvého login souboru
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// Firebase importy
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const BodUjepApp());
}

class BodUjepApp extends StatelessWidget {
  const BodUjepApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navandr',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Topol",
      ),
      builder: (context, child) {
        return DefaultTextStyle.merge(
          style: const TextStyle(fontWeight: FontWeight.bold),
          child: child!,
        );
      },
      // Rozcestník na web nebo Aplikaci
      home: kIsWeb
          ? const LoginScreen() // Použije třídu z admin/screens/login_screen.dart
          : const StartScreen(), // Na mobilu hra
    );
  }
}