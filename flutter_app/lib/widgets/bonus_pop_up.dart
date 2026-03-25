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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      if (pageData.podnadpis != null)
                        Text(
                          pageData.podnadpis!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                      const Expanded(flex: 1, child: SizedBox()),
                      if (pageData.obrazek != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            pageData.obrazek!,
                            width: double.infinity,
                            fit: BoxFit.contain,
                            height: MediaQuery.of(context).size.height * 0.45,
                          ),
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
                      const Expanded(flex: 2, child: SizedBox()),
                    ],
                  ),
                ),
              );
            },
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 32),
                  const Text(
                    'Bonus',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.close, size: 32, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
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
                  ),
                  child: const Text(
                    'Pokračovat',
                    style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
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