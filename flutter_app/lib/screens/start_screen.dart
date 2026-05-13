import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'mapa/mapa_screen.dart';
import '../widgets/app_bar.dart';
import '../screens/ucet_screen.dart'; 
import '../screens/seznam_tras_screen.dart';
import '../screens/about_screen.dart'; 
import '../data/mise_data.dart'; // PŘIDÁNO: Import dat, abychom měli přístup k 'vsechnyMise'

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  void _ukazDialogUkonceni(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Center(
            child: GestureDetector(
              onTap: () => SystemNavigator.pop(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                decoration: BoxDecoration(
                  color: const Color(0xFFAEFFA4),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.black, width: 1.5),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Text(
                  'Ukončit aplikaci?',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: MyAppBar(
        levaIkona: Icons.map_outlined,
        barvaPozadi: Colors.transparent,
        naLevaIkonaKlik: () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            Navigator.pushReplacement(
              context,
              // UPRAVENO: Předáváme první misi jako výchozí
              MaterialPageRoute(builder: (context) => MapaScreen(vybranaMise: vsechnyMise[0])),
            );
          }
        },
        pravaIkona: Icons.close,
        naPravaIkonaKlik: () {
          _ukazDialogUkonceni(context);
        },
      ),

      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            Navigator.pushReplacement(
              context,
              // UPRAVENO: Předáváme první misi jako výchozí
              MaterialPageRoute(builder: (context) => MapaScreen(vybranaMise: vsechnyMise[0])),
            );
          }
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFCFCE4),
                Color(0xFFAEFFA4)
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Mapa',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const UcetScreen()),
                      );
                    },
                    child: const Text(
                      'Účet',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SeznamTrasScreen()),
                      );
                    },
                    child: const Text(
                      'Trasy',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10), // Mezera mezi Trasy a O nás

                // --- O NÁS ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AboutScreen()),
                      );
                    },
                    child: const Text(
                      'O nás',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                // --------------------------

                const Spacer(),
                Center(
                  child: Image.asset(
                    'assets/trpaslik.png',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}