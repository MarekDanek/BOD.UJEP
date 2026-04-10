import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'mapa/mapa_screen.dart';
import '../widgets/app_bar.dart';

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
              MaterialPageRoute(builder: (context) => const MapaScreen()),
            );
          }
        },
        pravaIkona: Icons.close,
        naPravaIkonaKlik: () {
          _ukazDialogUkonceni(context);
        },
      ),

      // Celé tělo je teď klikatelné
      body: GestureDetector(
        behavior: HitTestBehavior.opaque, // Zajistí klikatelnost i na prázdném pozadí
        onTap: () {
          // Stejná logika jako u ikony v AppBaru
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MapaScreen()),
            );
          }
        },
        child: Container(
          // Zabereme maximální možný prostor
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