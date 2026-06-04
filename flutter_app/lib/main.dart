import 'package:bod_ujep_app/screens/start_screen.dart';
import 'package:bod_ujep_app/admin/screens/login_screen.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// Firebase importy
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Přidán import pro naše načítání dat
import 'package:bod_ujep_app/data/mise_data.dart';

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
          ? const LoginScreen() // Pro admin zůstává přihlášení
          : FutureBuilder(
              // ZDE SE ZASTAVÍME A STÁHNEME DATA ONLINE:
              future: nactiMiseZFirebase(),
              builder: (context, snapshot) {
                // Dokud stahujeme, ukaž hráči Loading...
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    backgroundColor: Color(0xFFFAED41),
                    body: Center(
                      child: CircularProgressIndicator(color: Colors.black),
                    ),
                  );
                }
                // Jakmile je staženo, pusť ho do mapy/menu!
                return const StartScreen();
              },
            ), 
    );
  }
}