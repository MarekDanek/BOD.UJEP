import 'package:flutter/material.dart';
import '../data/mise_data.dart';

class PrehledBonusuPopup extends StatefulWidget {
  final List<ZiskanyBonus> vsetkyBonusy;

  const PrehledBonusuPopup({
    super.key,
    required this.vsetkyBonusy,
  });

  @override
  State<PrehledBonusuPopup> createState() => _PrehledBonusuPopupState();
}

class _PrehledBonusuPopupState extends State<PrehledBonusuPopup> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Pojistka, kdyby náhodou v misi nebyly žádné bonusy
    if (widget.vsetkyBonusy.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFFFAED41),
        body: SafeArea(
          child: Stack(
            children: [
              const Center(
                child: Text("Zatím nemáš žádné bonusy.", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              Positioned(
                top: 10,
                right: 20,
                child: IconButton(
                  icon: const Icon(Icons.close, size: 32, color: Colors.black),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFAED41), // Žluté pozadí podle Figmy
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 20),
                // Nadpis přesně jako ve Frame 12
                const Text(
                  'Bonusy',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 20),

                // Posuvná část pro každý získaný bonus
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                    },
                    itemCount: widget.vsetkyBonusy.length,
                    itemBuilder: (context, index) {
                      final bonus = widget.vsetkyBonusy[index];
                      final stranka = bonus.stranka;

                      return SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Column(
                          children: [
                            // 1. Fotka k bonusu
                            if (stranka.obrazek != null && stranka.obrazek!.isNotEmpty)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  stranka.obrazek!,
                                  width: double.infinity,
                                  height: MediaQuery.of(context).size.height * 0.45,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height * 0.45,
                                    color: Colors.black12,
                                    child: const Center(child: Icon(Icons.image_not_supported, size: 50, color: Colors.black54)),
                                  ),
                                ),
                              ),
                            
                            const SizedBox(height: 30),

                            // 2. Vizuál Audio přehrávače podle Figmy
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: const [
                                  BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))
                                ]
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.play_arrow, size: 30),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(height: 4, width: double.infinity, color: Colors.grey[300]),
                                        const SizedBox(height: 4),
                                        Text(
                                          stranka.podnadpis ?? stranka.text, 
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12), 
                                          maxLines: 1, 
                                          overflow: TextOverflow.ellipsis
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Text('02:38', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                  const SizedBox(width: 10),
                                  const Icon(Icons.close, size: 20),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 30),

                            // 3. Hlavní text bonusu
                            Text(
                              stranka.podnadpis ?? "Existencionální pauza",
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                            
                            const SizedBox(height: 12),
                            
                            // 4. Podtext bonusu
                            Text(
                              stranka.text,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
                            ),
                            
                            const SizedBox(height: 40),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Spodní tečky (indikátory) jako ve Figmě
                if (widget.vsetkyBonusy.length > 1)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(widget.vsetkyBonusy.length, (index) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 4,
                          width: _currentPage == index ? 24 : 12,
                          decoration: BoxDecoration(
                            color: _currentPage == index ? Colors.black : Colors.black26,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        );
                      }),
                    ),
                  ),
              ],
            ),

            // Křížek pro zavření celého okna s bonusy nahoře vpravo
            Positioned(
              top: 10,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close, size: 32, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}