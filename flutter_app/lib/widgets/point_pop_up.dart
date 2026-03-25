import 'package:flutter/material.dart';
import '../data/mise_data.dart';

class PointPopup extends StatefulWidget {
  final List<BodMise> historieBodu;
  final Mise miseData;
  final VoidCallback onPokracovat;

  const PointPopup({
    super.key,
    required this.historieBodu,
    required this.miseData,
    required this.onPokracovat,
  });

  @override
  State<PointPopup> createState() => _PointPopupState();
}

class _PointPopupState extends State<PointPopup> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // Úvodní stránka = nejnovější bod
    _currentPage = widget.historieBodu.length - 1;
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85, // 85% obrazovky
      decoration: const BoxDecoration(
        color: Color(0xFFFAED41),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      // SafeArea zajistí, že tlačítko nevleze pod domovskou čáru na iPhonu/Tabletu
      child: SafeArea(
        bottom: true,
        child: Column(
          children: [
            const SizedBox(height: 12),
            // Úchopová čárka
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Indikátory stránek (čárky)
            if (widget.historieBodu.length > 1)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.historieBodu.length, (index) {
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
            const SizedBox(height: 12),

            // Knížka (Scrollovací obsah)
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemCount: widget.historieBodu.length,
                itemBuilder: (context, index) {
                  final bodData = widget.historieBodu[index];

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded( // Expanded zamezí přetečení dlouhého názvu mise
                                child: Text(
                                  widget.miseData.nazev,
                                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w500, color: Colors.black, letterSpacing: -0.5),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.black, width: 1.5),
                                ),
                                child: Center(
                                  child: Text(
                                    bodData.id.toString(),
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Text(
                            bodData.nazevBodu,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Text(
                            bodData.podnadpis,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Text(
                            bodData.textCast1,
                            style: const TextStyle(fontSize: 15, height: 1.2, color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Image.asset(
                          bodData.obrazekCesta,
                          width: double.infinity,
                          height: 300,
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
                            bodData.textCast2,
                            style: const TextStyle(fontSize: 15, height: 1.2, color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 40), 
                      ],
                    ),
                  );
                },
              ),
            ),

            AnimatedOpacity(
              opacity: _currentPage == widget.historieBodu.length - 1 ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: IgnorePointer(
                ignoring: _currentPage != widget.historieBodu.length - 1, // Aby na něj nešlo kliknout, když je průhledné
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      widget.onPokracovat();
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 1.5), borderRadius: BorderRadius.circular(20)),
                      child: const Text('Pokračovat', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}