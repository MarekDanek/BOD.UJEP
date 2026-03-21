import 'package:flutter/material.dart';
import '../widgets/mise_popup.dart';
import '../widgets/point_pop_up.dart';
import '../data/mise_data.dart';

class DialogManager {
  static void ukazStartPopup({
    required BuildContext context,
    required Mise miseData,
    required VoidCallback onVyrazit,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return MisePopup(
          miseData: miseData,
          onVyrazit: onVyrazit,
        );
      },
    );
  }

  static void ukazPribehPopup({
    required BuildContext context,
    required BodMise bodData,
    required Mise miseData,
    required VoidCallback onPokracovat,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return PointPopup(
          bodData: bodData,
          miseData: miseData,
          onPokracovat: onPokracovat,
        );
      },
    );
  }

  // NOVÁ FUNKCE PRO ZOBRAZENÍ BONUSU (např. Tokio Drift)
  static void ukazBonusPopup({
    required BuildContext context,
    required BodMise bodData,
    required VoidCallback onPokracovat,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false, // Nedovolí zavřít kliknutím mimo, musíš kliknout na křížek nebo tlačítko
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color(0xFFFAED41), // Tvoje signaturní žlutá
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Horní lišta: nápis Bonus a křížek
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 32), // Prázdné místo pro vycentrování nadpisu
                    const Text(
                      'Bonus',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(), // Křížek jen zavře okno
                      child: const Icon(Icons.close, size: 32, color: Colors.black54),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Obrázek bonusu (pokud ho v datech máš)
                if (bodData.bonusObrazek != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      bodData.bonusObrazek!,
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  // Záložní šedý čtverec, kdybys u nějakého bonusu zapomněl obrázek přidat
                  Container(
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(child: Icon(Icons.music_note, size: 50, color: Colors.black54)),
                  ),

                const SizedBox(height: 30),

                // Název písničky (např. Tokio Drift)
                Text(
                  bodData.bonusNazev ?? 'Tajný bonus',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),

                // Podtitulek
                const Text(
                  'Skladbu můžeš poslouchat\nna cestě k dalšímu bodu.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, height: 1.3, fontWeight: FontWeight.w500),
                ),

                const SizedBox(height: 40),

                // Tlačítko Pokračovat
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Zavře popup
                    onPokracovat(); // Pošle signál do mapy, ať tě hodí dál a zapne přehrávač!
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.black, width: 1.5), // Černý okraj
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  child: const Text(
                    'Pokračovat',
                    style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }
}