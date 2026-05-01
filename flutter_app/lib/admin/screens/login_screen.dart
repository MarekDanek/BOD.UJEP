import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase
import 'dashboard_screen.dart'; // Import dashboardu

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 1. Ovladače, které "tahají" text z políček
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _loading = false; // Pro zobrazení kolečka při načítání

  // 2. Funkce pro přihlášení
  Future<void> _login() async {
    setState(() => _loading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Pokud to vyjde, jdeme na Dashboard
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Pokud to nevyjde (špatné heslo atd.), ukážeme chybu
      String message = "Došlo k chybě";
      if (e.code == 'user-not-found'){
         message = "Uživatel neexistuje";
      }else if(e.code == 'wrong-password'){
         message = "Nesprávné heslo";
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "NAVANDR",
                style: TextStyle(fontSize: 40, letterSpacing: 4),
              ),
              const Text(
                "SPRÁVA VRSTEV",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 60),

              // Políčko pro email
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "ADMINISTRÁTOR (EMAIL)",
                  labelStyle: TextStyle(fontSize: 12),
                  border: UnderlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Políčko pro heslo
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "HESLO",
                  labelStyle: TextStyle(fontSize: 12),
                  border: UnderlineInputBorder(),
                ),
              ),
              const SizedBox(height: 60),

              // Tlačítko
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _login, // Pokud načítá, nejde kliknout
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  ),
                  child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "VSTOUPIT",
                        style: TextStyle(color: Colors.white, letterSpacing: 2),
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}