import 'package:flutter/material.dart';
import 'mapa_screen.dart';
import '../widgets/app_bar.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: MyAppBar(
        levaIkona: Icons.map_outlined,
        barvaPozadi: Colors.transparent,
        naLevaIkonaKlik: () {
          // CHYTRÁ LOGIKA NÁVRATU:
          // Pokud pod tímto menu už nějaká mapa běží (jsme ve hře), jen menu zavřeme.
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            // Pokud jsme aplikaci zrovna zapnuli a žádná mapa ještě neběží, tak ji vytvoříme.
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MapaScreen()),
            );
          }
        },
        pravaIkona: Icons.close,
        naPravaIkonaKlik: () {
          // Tady můžeš dát třeba ukončení aplikace nebo návrat
        },
      ),

      body: Container(
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
    );
  }
}