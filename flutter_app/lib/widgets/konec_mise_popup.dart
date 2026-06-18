import 'package:flutter/material.dart';
import '../data/mise_data.dart'; 

class KonecMisePopup extends StatefulWidget {
  final List<BodMise> historieBodu;
  final String odehranyCas;
  final Mise miseData; 
  final VoidCallback onUzavrit;
  final VoidCallback onBonusy;

  const KonecMisePopup({
    super.key,
    required this.historieBodu,
    required this.odehranyCas,
    required this.miseData, 
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

  // --- TADY JE ZÁVĚREČNÁ STRÁNKA, KTERÁ UŽ ČTE DATA Z TVÉ DATABÁZE ---
  Widget _buildZaverecneShrnuti() {
    // Zjistíme, jestli má tato mise alespoň jeden bod s bonusovou stránkou
    final bool maBonusy = widget.historieBodu.any((bod) => bod.bonusoveStranky != null && bod.bonusoveStranky!.isNotEmpty);
    
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ČTEME NADPIS Z DATABÁZE
                Text(
                  widget.miseData.zaverecnyNadpis, 
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black)
                ),
                const SizedBox(height: 16),
                
                // ČTEME HLAVNÍ TEXT Z DATABÁZE ("splnil jsi to brasko")
                Text(
                  widget.miseData.zaverecnyText,
                  style: const TextStyle(fontSize: 16, height: 1.3, color: Colors.black),
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

                // --- DYNAMICKÁ STATISTIKA Z DAT MISE ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          widget.miseData.vzdalenost,
                          style: const TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold)
                        )
                      )
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          widget.odehranyCas, 
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
                          widget.miseData.obtiznost,
                          style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold)
                        )
                      )
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          widget.miseData.typ,
                          style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold)
                        )
                      )
                    ),
                  ]
                ),

                const SizedBox(height: 30),

                // --- TLAČÍTKO BONUSY SE ZOBRAZÍ JEN KDYŽ MISE MÁ BONUSY ---
                if (maBonusy) ...[
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
              ],
            ),
          ),

          // --- DYNAMICKÝ OBRÁZEK Z DATABÁZE (S POJISTKOU PROTI PÁDU) ---
          if (widget.miseData.zaverecnyObrazek.isNotEmpty)
            Image.asset(
              widget.miseData.zaverecnyObrazek, 
              width: double.infinity, 
              height: 250, 
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Tato část zabrání pádu aplikace, pokud obrázek ve složce assets ještě fyzicky nemáš!
                return Container(
                  width: double.infinity,
                  height: 250,
                  color: Colors.black12,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.image_not_supported, size: 50, color: Colors.black54),
                      const SizedBox(height: 10),
                      Text("Obrázek nenalezen:\n${widget.miseData.zaverecnyObrazek}", textAlign: TextAlign.center, style: const TextStyle(color: Colors.black54)),
                    ],
                  ),
                );
              },
            ),
            
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
            if (bod.obrazekCesta.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  bod.obrazekCesta,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: double.infinity, height: 200, color: Colors.black12,
                    child: const Center(child: Icon(Icons.image_not_supported, color: Colors.black54)),
                  ),
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