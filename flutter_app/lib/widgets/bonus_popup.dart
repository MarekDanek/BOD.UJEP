import 'package:flutter/material.dart';
import '../data/mise_data.dart';

class BonusPopupMultipage extends StatefulWidget {
  final BodMise bodData;
  final VoidCallback onVyrazitPokracovat;

  const BonusPopupMultipage({
    super.key,
    required this.bodData,
    required this.onVyrazitPokracovat,
  });

  @override
  State<BonusPopupMultipage> createState() => _BonusPopupMultipageState();
}

class _BonusPopupMultipageState extends State<BonusPopupMultipage> {
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
    if (widget.bodData.bonusoveStranky == null || widget.bodData.bonusoveStranky!.isEmpty) {
      return const SizedBox.shrink();
    }

    final pages = widget.bodData.bonusoveStranky!;

    return Scaffold(
      backgroundColor: const Color(0xFFFAED41),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemCount: pages.length,
            itemBuilder: (context, index) {
              final pageData = pages[index];

              return SafeArea(
                // Obaleno do SingleChildScrollView pro responzivitu
                child: SingleChildScrollView(
                  // Větší spodní padding (120), aby text nevlezl pod plovoucí tlačítka
                  padding: const EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 200),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Text(
                          pageData.podnadpis ?? '',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),

                      // Nahrazeno pevným SizedBoxem místo Expanded
                      const SizedBox(height: 20),

                      if (pageData.obrazek != null)
                        pageData.zaoblitObrazek == true
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  pageData.obrazek!,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  height: MediaQuery.of(context).size.height * 0.45,
                                ),
                              )
                            : Image.asset(
                                pageData.obrazek!,
                                width: double.infinity,
                                fit: BoxFit.contain,
                                height: MediaQuery.of(context).size.height * 0.45,
                              ),

                      const SizedBox(height: 30),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          pageData.text,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 22, height: 1.3, fontWeight: FontWeight.bold),
                        ),
                      ),

                      if (pageData.malyText != null) ...[
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            pageData.malyText!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16, height: 1.2, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),

          // Křížek pro zavření
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.close, size: 32, color: Colors.black54),
                ),
              ),
            ),
          ),

          // Tlačítko Pokračovat (zobrazí se jen na poslední stránce)
          if (_currentPage == pages.length - 1)
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: Center(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    widget.onVyrazitPokracovat();
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.black, width: 2.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                    backgroundColor: const Color(0xFFFAED41), // Přidáno pozadí, aby pod ním neprosvítal text
                  ),
                  child: const Text(
                    'Pokračovat',
                    style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),

          // Tečky (indikátor stránek)
          if (pages.length > 1)
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(pages.length, (index) {
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
    );
  }
}