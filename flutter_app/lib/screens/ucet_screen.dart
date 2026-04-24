import 'package:flutter/material.dart';
import '../widgets/app_bar.dart'; // Ujisti se, že tahle cesta sedí

class UcetScreen extends StatelessWidget {
  const UcetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: MyAppBar(
        levaIkona: Icons.arrow_back,
        barvaPozadi: Colors.transparent,
        naLevaIkonaKlik: () {
          Navigator.pop(context);
        },
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFCFCE4), Color(0xFFAEFFA4)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10), // Malá mezera pod AppBarem

                // Nadpis stránky
                const Text(
                  'Můj účet',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),


                // Seznam věcí, které tu budou
                _buildPolozkaUctu(Icons.person, 'Profilové informace uživatele'),
                _buildPolozkaUctu(Icons.map, 'Seznam rozehraných map'),
                _buildPolozkaUctu(Icons.check_circle, 'Seznam dokončených map'),
                _buildPolozkaUctu(Icons.military_tech, 'Odznaky a globální úspěchy'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPolozkaUctu(IconData ikona, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 1.5),
            ),
            child: Icon(ikona, color: Colors.black, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87
              ),
            ),
          ),
        ],
      ),
    );
  }
}