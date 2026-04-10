import 'package:flutter/material.dart';
import '../data/mise_data.dart'; // Potřebujeme přístup k datům o bodech

class KonecMisePopup extends StatefulWidget {
  final List<BodMise> historieBodu;
  final Mise miseData; // <--- NOVÉ: Přidán objekt s daty o celé misi
  final VoidCallback onUzavrit;
  final VoidCallback onBonusy;

  const KonecMisePopup({
    super.key,
    required this.historieBodu,
    required this.miseData, // <--- NOVÉ: Přidáno do konstruktoru
    required this.onUzavrit,
    required this.onBonusy,
  });

  @override
  State<KonecMisePopup> createState() => _KonecMisePopupState();
}

class _KonecMisePopupState extends State<KonecMisePopup> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // Chceme, aby se okno otevřelo ROVNOU na poslední stránce (Závěrečné shrnutí)
    _currentPage = widget.historieBodu.length;
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Celkový počet stránek = všechny body příběhu + 1 závěrečné shrnutí
    final totalPages = widget.historieBodu.length + 1;

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Color(0xFFFAED41),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          // Dynamické indikátory nahoře (tečky/pomlčky)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(totalPages, (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 4,
              width: _currentPage == index ? 24 : 12,
              decoration: BoxDecoration(
                color: _currentPage == index ? Colors.black : Colors.black38,
                borderRadius: BorderRadius.circular(2),
              ),
            )),
          ),
          const SizedBox(height: 20),

          // Posuvná část
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemCount: totalPages,
              itemBuilder: (context, index) {
                // Pokud jsme na úplně poslední stránce, ukážeme SHRNUTÍ
                if (index == widget.historieBodu.length) {
                  return _buildZaverecneShrnuti();
                }
                // Jinak ukazujeme příběh z minulých bodů (0 až N)
                else {
                  return _buildPribehovaStranka(widget.historieBodu[index]);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- TADY JE ZÁVĚREČNÁ STRÁNKA S DYNAMICKOU STATISTIKOU ---
  Widget _buildZaverecneShrnuti() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Mise splněna!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black)),
                const SizedBox(height: 16),
                const Text(
                  'Prošel jsem kampus. Menzu. Prostranství. Bankomat. Bufet. Malé zastávky velkého dne. Hudba dohrála. Cigareta pomalu dohořívá. A já jsem konečně dorazil tam, kam jsem měl namířeno od začátku. Do práce.',
                  style: TextStyle(fontSize: 16, height: 1.3, color: Colors.black),
                ),
                const SizedBox(height: 30),
                const Divider(color: Colors.black, thickness: 1),
                const SizedBox(height: 10),

                Center(
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 4),
                    decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black, width: 1.5))),
                    child: const Text('Statistika', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
                  ),
                ),
                const SizedBox(height: 20),

                // --- TADY JE TVOJE DYNAMICKÁ STATISTIKA Z DAT MISE ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          widget.miseData.vzdalenost, // <--- Bere se dynamicky
                          style: const TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold)
                        )
                      )
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          widget.miseData.cas, // <--- Bere se dynamicky
                          style: const TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold)
                        )
                      )
                    ),
                  ]
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          widget.miseData.obtiznost, // Přidána obtížnost jako v popupu
                          style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold)
                        )
                      )
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          widget.miseData.typ, // <--- Bere se dynamicky typ
                          style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold)
                        )
                      )
                    ),
                  ]
                ),
                // ----------------------------------------------------

                const SizedBox(height: 30),

                Center(
                  child: OutlinedButton(
                    onPressed: widget.onBonusy,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.black, width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    ),
                    child: const Text('Bonusy', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),

          Image.asset('assets/BOD5_1.png', width: double.infinity, height: 250, fit: BoxFit.cover),
          const SizedBox(height: 30),

          Center(
            child: OutlinedButton(
              onPressed: widget.onUzavrit,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.black, width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
              ),
              child: const Text('Uzavřít', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // --- TOTO VYKRESLÍ HISTORII PŘEDCHOZÍCH BODŮ ---
  Widget _buildPribehovaStranka(BodMise bod) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(bod.nazevBodu, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
            const SizedBox(height: 16),
            Text(
              bod.textCast1,
              style: const TextStyle(fontSize: 18, height: 1.3, color: Colors.black),
            ),
            const SizedBox(height: 24),
            // Pokud má bod obrázek, ukážeme ho
            if (bod.obrazekCesta.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  bod.obrazekCesta,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 24),
            Text(
              bod.textCast2,
              style: const TextStyle(fontSize: 18, height: 1.3, color: Colors.black),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}