import 'package:flutter/material.dart';
import '../data/mise_data.dart';

class MisePopup extends StatelessWidget {
  final Mise miseData;
  final VoidCallback onVyrazit;

  const MisePopup({
    super.key,
    required this.miseData,
    required this.onVyrazit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFAED41),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Center(
              child: Container(
                width: 40,
                height: 3,
                decoration: BoxDecoration(
                  color: const Color(0x80000000),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 30), // Trochu zmenšená mezera kvůli křížku
            Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 16.0), // Upravený padding pro křížek
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Název mise a postup zabalíme do Columnu, aby byly u sebe
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          miseData.nazev,
                          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black, letterSpacing: -0.5),
                        ),
                        Text(
                          // UPRAVENO: Používá dynamickou délku z předané mise
                          '0/${miseData.trasa.length}', 
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  // Tlačítko pro zavření popupu
                  IconButton(
                    icon: const Icon(Icons.close, size: 30, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context); // Zavře popup
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                miseData.podnadpis,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                miseData.textCast1,
                style: const TextStyle(fontSize: 15, height: 1.2, color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Image.asset(
              miseData.obrazekCesta,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity, height: 200, color: Colors.black12,
                  child: const Center(child: Icon(Icons.image, size: 50, color: Colors.black54)),
                );
              },
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                miseData.textCast2,
                style: const TextStyle(fontSize: 15, height: 1.2, color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(color: Colors.black54, thickness: 1),
            const SizedBox(height: 10),
            Center(
              child: Container(
                padding: const EdgeInsets.only(bottom: 2),
                decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black, width: 1.5))),
                child: const Text('Informace', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Expanded(child: Center(child: Text(miseData.pocetBodu, style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold)))), Expanded(child: Center(child: Text(miseData.vzdalenost, style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold))))]),
                  const SizedBox(height: 16),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Expanded(child: Center(child: Text(miseData.obtiznost, style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold)))), Expanded(child: Center(child: Text(miseData.cas, style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold))))]),
                  const SizedBox(height: 16),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Expanded(child: Center(child: Text(miseData.bonusy, style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold)))), Expanded(child: Center(child: Text(miseData.typ, style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold))))]),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  onVyrazit();
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 1.5), borderRadius: BorderRadius.circular(20)),
                  child: const Text('Vyrazit!', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                ),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}