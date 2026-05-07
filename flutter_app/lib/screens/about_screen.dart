import 'package:flutter/material.dart';
import '../widgets/app_bar.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: MyAppBar(
        levaIkona: Icons.arrow_back_ios_new,
        barvaPozadi: Colors.transparent,
        naLevaIkonaKlik: () => Navigator.pop(context),
        pravaIkona: Icons.info_outline,
        naPravaIkonaKlik: () {}, 
      ),
      body: Container(
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                const Text(
                  'O nás',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 30),

                // --- SEKCE: O PROJEKTU ---
                _buildSectionTitle('Projekt BOD UJEP'),
                _buildSectionBody(
                  'Tato aplikace je součástí projektu BOD UJEP.\n'
                  'města Ústí nad Labem pomocí interaktivních tras a příběhů.'
                ),

                // --- SEKCE: AUTOŘI ---
                _buildSectionTitle('Autoři'),
                _buildSectionBody(
                  '• Vývoj: Marek Daněk\n'
                  '• Grafika: ...\n'
                  '• Koordinace: ...'
                ),

                // --- SEKCE: INFO O APP ---
                _buildSectionTitle('Informace o aplikaci'),
                _buildSectionBody(
                  'Verze: 1.0.2 (Production)\n'
                  'Technologie: Flutter & Firebase'
                ),

                // --- SEKCE: IMPRESUM ---
                _buildSectionTitle('Impresum'),
                _buildSectionBody(
                  'Univerzita J. E. Purkyně v Ústí nad Labem\n'
                  'Pasteurova\n'
                  '400 96 Ústí nad Labem\n'
                ),
                
                const SizedBox(height: 40),
                // Malé logo UJEP nebo grafika na konec
                Center(
                  child: Opacity(
                    opacity: 0.5,
                    child: Icon(Icons.school_outlined, size: 60, color: Colors.black),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Pomocná metoda pro nadpisy sekcí (shodný styl s menu)
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 8.0),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black54,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  // Pomocná metoda pro tělo textu
  Widget _buildSectionBody(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        color: Colors.black87,
        height: 1.4,
      ),
    );
  }
}