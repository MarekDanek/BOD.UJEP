import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart'; // Abychom se mohli odhlásit
import 'admin_kresleni_tras.dart'; // PŘIDÁNO: Import nové obrazovky pro mapu

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NAVANDR ADMIN PANEL", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white), // Aby byla ikona logoutu bílá
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline, size: 100, color: Colors.green),
            const SizedBox(height: 20),
            const Text("JSI UVNITŘ!", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            const Text("Tady brzy uvidíš seznam tvých misí."),
            
            const SizedBox(height: 50), // Větší mezera

            // --- PŘIDÁNO: TLAČÍTKO PRO KRESLENÍ ---
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFAED41), // Tvoje žlutá barva
                foregroundColor: Colors.black, // Černý text a ikona
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              icon: const Icon(Icons.map, size: 28),
              label: const Text(
                'Otevřít kreslení tras',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                // Přechod na obrazovku s kreslením
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const KresleniTrasyScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}