import 'package:flutter/material.dart';
import '../data/mise_data.dart';
import 'audio_player.dart';

class ZiskanyBonus {
  final BonusovaStranka stranka;
  final String? audioPath;
  ZiskanyBonus(this.stranka, this.audioPath);
}

class PrehledBonusuPopup extends StatefulWidget {
  final List<ZiskanyBonus> vsetkyBonusy;

  const PrehledBonusuPopup({super.key, required this.vsetkyBonusy});

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
    if (widget.vsetkyBonusy.isEmpty) return const Scaffold(backgroundColor: Color(0xFFFAED41));

    return Scaffold(
      backgroundColor: const Color(0xFFFAED41),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: widget.vsetkyBonusy.length,
            itemBuilder: (context, index) {
              final bonus = widget.vsetkyBonusy[index];
              final pageData = bonus.stranka;

              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 20.0),
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
                      if (pageData.malyText != null) ...[
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            pageData.malyText!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16, height: 1.2, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                      const Expanded(flex: 2, child: SizedBox()),
                    ],
                  ),
                ),
              );
            },
          ),

          if (widget.vsetkyBonusy[_currentPage].audioPath != null)
            Positioned(
              bottom: 80,
              left: 20,
              right: 20,
              child: MiniAudioPlayer(
                nazevSkladby: widget.vsetkyBonusy[_currentPage].stranka.text,
                audioPath: widget.vsetkyBonusy[_currentPage].audioPath!,
                onZavrit: () {},
              ),
            ),

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

          if (widget.vsetkyBonusy.length > 1)
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
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
    );
  }
}