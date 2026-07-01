import 'package:flutter/material.dart';
import '../data/odznak_data.dart';
import '../data/profil_data.dart';
import '../data/profil_obrazky.dart';
import '../widgets/app_bar.dart';
import '../widgets/upravit_profil_dialog.dart';

class UcetScreen extends StatefulWidget {
  const UcetScreen({super.key});

  @override
  State<UcetScreen> createState() => _UcetScreenState();
}

class _UcetScreenState extends State<UcetScreen> {
  bool _zobrazitOdznaky = false;
  ProfilUzivatele _profil = ProfilUzivatele();
  bool _nacteno = false;

  @override
  void initState() {
    super.initState();
    _nactiProfil();
  }

  Future<void> _nactiProfil() async {
    final profil = await nactiProfil();
    if (mounted) {
      setState(() {
        _profil = profil;
        _nacteno = true;
      });
    }
  }

  Future<void> _otevritUpravuProfilu() async {
    final vysledek = await showDialog<ProfilUzivatele>(
      context: context,
      builder: (context) => UpravitProfilDialog(profil: _profil),
    );

    if (vysledek != null) {
      await ulozProfil(vysledek);
      if (mounted) {
        setState(() {
          _profil = vysledek;
        });
      }
    }
  }

  void _zobrazitDetailOdznaku(Odznak odznak) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 40),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFFCFCE4),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildObrazekOdznaku(odznak, velikost: 120),
                  const SizedBox(height: 16),
                  Text(
                    odznak.nazev,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    odznak.popis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildObrazekOdznaku(Odznak odznak, {required double velikost}) {
    if (odznak.obrazek != null) {
      return Image.asset(
        odznak.obrazek!,
        width: velikost,
        height: velikost,
        fit: BoxFit.contain,
      );
    }

    return Container(
      width: velikost,
      height: velikost,
      decoration: BoxDecoration(
        color: const Color(0xFFFAED41),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Icon(
        Icons.military_tech,
        size: velikost * 0.55,
        color: Colors.black,
      ),
    );
  }

  Widget _buildProfilovyObrazek({required double velikost}) {
    return buildProfilObrazek(
      idObrazku: _profil.idObrazku,
      velikost: velikost,
    );
  }

  Widget _buildProfilovaHlavicka() {
    TextStyle stylJmeno({required double velikost, required FontWeight vaha, Color? barva, FontStyle styl = FontStyle.normal}) {
      return TextStyle(
        fontSize: velikost,
        fontWeight: vaha,
        color: barva ?? Colors.black,
        fontStyle: styl,
      );
    }

    Widget radek(String text, TextStyle styl, {String? placeholder}) {
      final zobrazit = text.isNotEmpty ? text : (placeholder ?? '');
      return Text(
        zobrazit,
        style: styl.copyWith(
          color: text.isNotEmpty ? styl.color : Colors.black38,
          fontStyle: text.isNotEmpty ? styl.fontStyle : FontStyle.normal,
        ),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              radek(_profil.jmeno, stylJmeno(velikost: 26, vaha: FontWeight.bold), placeholder: 'Jméno'),
              const SizedBox(height: 4),
              radek(_profil.prijmeni, stylJmeno(velikost: 22, vaha: FontWeight.w600), placeholder: 'Příjmení'),
              const SizedBox(height: 4),
              radek(
                _profil.prezdivka,
                stylJmeno(velikost: 18, vaha: FontWeight.w500, styl: FontStyle.italic),
                placeholder: 'Přezdívka',
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        _buildProfilovyObrazek(velikost: 80),
      ],
    );
  }

  Widget _buildPolozkaUctu(
    IconData ikona,
    String text, {
    VoidCallback? onTap,
    bool jeRozbaleno = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 1.5),
              ),
              child: Icon(ikona, color: Colors.black, size: 24),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            if (onTap != null)
              Icon(
                jeRozbaleno ? Icons.expand_less : Icons.expand_more,
                color: Colors.black54,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMrizkaOdznaku() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: ziskaneOdznaky.length,
        itemBuilder: (context, index) {
          final odznak = ziskaneOdznaky[index];
          return GestureDetector(
            onTap: () => _zobrazitDetailOdznaku(odznak),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildObrazekOdznaku(odznak, velikost: 72),
                const SizedBox(height: 6),
                Text(
                  odznak.nazev,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_nacteno) {
      return const Scaffold(
        backgroundColor: Color(0xFFFCFCE4),
        body: Center(
          child: CircularProgressIndicator(color: Colors.black),
        ),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: MyAppBar(
        levaIkona: Icons.arrow_back,
        barvaPozadi: Colors.transparent,
        naLevaIkonaKlik: () {
          Navigator.pop(context);
        },
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFCFCE4), Color(0xFFAEFFA4)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Text(
                  'Můj účet',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                _buildProfilovaHlavicka(),
                const SizedBox(height: 28),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPolozkaUctu(Icons.map, 'Seznam rozehraných map'),
                        _buildPolozkaUctu(Icons.check_circle, 'Seznam dokončených map'),
                        _buildPolozkaUctu(
                          Icons.military_tech,
                          'Odznaky',
                          onTap: () {
                            setState(() {
                              _zobrazitOdznaky = !_zobrazitOdznaky;
                            });
                          },
                          jeRozbaleno: _zobrazitOdznaky,
                        ),
                        if (_zobrazitOdznaky) _buildMrizkaOdznaku(),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: GestureDetector(
                    onTap: _otevritUpravuProfilu,
                    child: const Text(
                      'Upravit údaje',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.black54,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
