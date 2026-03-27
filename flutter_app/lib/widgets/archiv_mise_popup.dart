import 'package:flutter/material.dart';
import '../data/mise_data.dart';

class ArchivMisePopup extends StatelessWidget {
  final Mise miseData;
  final int pocetBodu;
  final ScrollController scrollController; // <--- PŘIDÁNO PRO TAHÁNÍ

  const ArchivMisePopup({
    super.key,
    required this.miseData,
    required this.pocetBodu,
    required this.scrollController, // <--- PŘIDÁNO
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFAED41),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, -4)) // Stín nahoru
        ],
      ),
      // Místo Column je tu ListView, které reaguje na tahání prstem
      child: ListView(
        controller: scrollController, // <--- TADY SE TO PROPOJUJE
        padding: const EdgeInsets.only(left: 24, right: 24, top: 12, bottom: 40),
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  miseData.nazev,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '$pocetBodu/$pocetBodu',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  miseData.podnadpis,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Text('Úspěšně dokončeno', style: TextStyle(fontSize: 14, color: Colors.black87)),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Prošel jsem kampus. Menzu. Prostranství. Bankomat. Bufet. Malé zastávky velkého dne. Hudba dohrála. Cigareta pomalu dohořívá.\nA já jsem konečně dorazil tam, kam jsem měl namířeno od začátku. Do práce.',
            style: TextStyle(fontSize: 16, color: Colors.black, height: 1.3),
          ),
        ],
      ),
    );
  }
}