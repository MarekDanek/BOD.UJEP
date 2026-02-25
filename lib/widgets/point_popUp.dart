import 'package:flutter/material.dart';

class PointPopup extends StatelessWidget {
  const PointPopup({super.key});

  @override
  Widget build(BuildContext context) {
    // FractionallySizedBox nám zajistí, že okno zabere třeba 90% výšky displeje (skoro full screen)
    return FractionallySizedBox(
      heightFactor: 0.9,
      child: Container(
        color: const Color(0xFFFFF8E1), // Světle žluté pozadí podle návrhu
        child: Column(
          children: [
            // Horní lišta s nadpisem a křížkem
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Na vlnovce', // Nadpis vrstvy
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 30),
                    onPressed: () {
                      // Tímto příkazem se pop-up okno zavře
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),

            // Místo pro obrázek/video
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey[300],
              child: const Center(
                child: Icon(Icons.image, size: 50, color: Colors.grey), // Zástupný symbol pro fotku
              ),
            ),

            // Textový obsah
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                 'INFORMACE V POPUP OKNĚ.',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}