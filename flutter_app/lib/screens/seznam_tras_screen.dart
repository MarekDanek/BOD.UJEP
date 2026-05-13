import 'package:flutter/material.dart';
import '../data/mise_data.dart'; // Očekává, že tady je definováno "vsechnyMise"
import '../widgets/app_bar.dart';
import 'mapa/mapa_screen.dart'; // PŘIDÁNO: Import mapy, abychom na ni mohli navigovat

enum RazeniTras { nazevVzestupne, nazevSestupne, vzdalenost, cas }

class SeznamTrasScreen extends StatefulWidget {
  const SeznamTrasScreen({super.key});

  @override
  State<SeznamTrasScreen> createState() => _SeznamTrasScreenState();
}

class _SeznamTrasScreenState extends State<SeznamTrasScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _zobrazitVyhledavani = false;
  String _searchQuery = '';
  RazeniTras _razeni = RazeniTras.nazevVzestupne;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  int _parseVzdalenostVMetrech(String value) {
    final ciste = value.trim().toLowerCase().replaceAll(',', '.');
    if (ciste.endsWith('km')) {
      final cislo = double.tryParse(ciste.replaceAll('km', '').trim()) ?? 0;
      return (cislo * 1000).round();
    }
    if (ciste.endsWith('m')) {
      return int.tryParse(ciste.replaceAll('m', '').trim()) ?? 0;
    }
    return 0;
  }

  int _parseCasVSekundach(String value) {
    final ciste = value.trim().toLowerCase();
    final hodinovyMatch = RegExp(r'(\d+)\s*h').firstMatch(ciste);
    final minutovyMatch = RegExp(r'(\d+)\s*min').firstMatch(ciste);
    final sekundovyMatch = RegExp(r'(\d+)\s*s').firstMatch(ciste);

    final hodiny = int.tryParse(hodinovyMatch?.group(1) ?? '0') ?? 0;
    final minuty = int.tryParse(minutovyMatch?.group(1) ?? '0') ?? 0;
    final sekundy = int.tryParse(sekundovyMatch?.group(1) ?? '0') ?? 0;

    if (hodiny == 0 && minuty == 0 && sekundy == 0) {
      final fallbackMinuty = int.tryParse(ciste.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      return fallbackMinuty * 60;
    }

    return hodiny * 3600 + minuty * 60 + sekundy;
  }

  List<Mise> _getFiltrovaneARazeneMise() {
    // UPRAVENO: Používá globální seznam 'vsechnyMise' místo lokální proměnné
    final vyfiltrovane = vsechnyMise.where((mise) {
      final odpovidaVyhledavani = _searchQuery.isEmpty ||
          mise.nazev.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          mise.podnadpis.toLowerCase().contains(_searchQuery.toLowerCase());
      return odpovidaVyhledavani;
    }).toList();

    vyfiltrovane.sort((a, b) {
      switch (_razeni) {
        case RazeniTras.nazevVzestupne:
          return a.nazev.compareTo(b.nazev);
        case RazeniTras.nazevSestupne:
          return b.nazev.compareTo(a.nazev);
        case RazeniTras.vzdalenost:
          return _parseVzdalenostVMetrech(a.vzdalenost)
              .compareTo(_parseVzdalenostVMetrech(b.vzdalenost));
        case RazeniTras.cas:
          return _parseCasVSekundach(a.cas).compareTo(_parseCasVSekundach(b.cas));
      }
    });

    return vyfiltrovane;
  }

  String _labelRazeni(RazeniTras razeni) {
    switch (razeni) {
      case RazeniTras.nazevVzestupne:
        return 'Název A-Z';
      case RazeniTras.nazevSestupne:
        return 'Název Z-A';
      case RazeniTras.vzdalenost:
        return 'Vzdálenost';
      case RazeniTras.cas:
        return 'Čas';
    }
  }

  @override
  Widget build(BuildContext context) {
    final miseList = _getFiltrovaneARazeneMise();

    return Scaffold(
      appBar: MyAppBar(
        levaIkona: Icons.arrow_back,
        naLevaIkonaKlik: () => Navigator.pop(context),
        pravaIkona: _zobrazitVyhledavani ? Icons.close : Icons.search,
        naPravaIkonaKlik: () {
          setState(() {
            _zobrazitVyhledavani = !_zobrazitVyhledavani;
            if (!_zobrazitVyhledavani) {
              _searchQuery = '';
              _searchController.clear();
            }
          });
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                const Text(
                  'Kompletní seznam tras',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                if (_zobrazitVyhledavani)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) => setState(() => _searchQuery = value),
                      decoration: InputDecoration(
                        hintText: 'Vyhledat trasu...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  setState(() {
                                    _searchQuery = '';
                                    _searchController.clear();
                                  });
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<RazeniTras>(
                        value: _razeni,
                        decoration: InputDecoration(
                          labelText: 'Řazení',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: RazeniTras.values.map((value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(_labelRazeni(value)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() => _razeni = value);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: miseList.isEmpty
                      ? const Center(
                          child: Text(
                            'Žádná trasa neodpovídá filtru.',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        )
                      : ListView.separated(
                          itemCount: miseList.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final mise = miseList[index];
                            
                            // PŘIDÁNO: GestureDetector, aby šlo na kartičku kliknout
                            return GestureDetector(
                              onTap: () {
                                // Při kliknutí tě to hodí na mapu s vybranou misí
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MapaScreen(vybranaMise: mise),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFAED41),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.black, width: 2),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 6,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      mise.nazev,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      mise.podnadpis,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            mise.vzdalenost,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            mise.cas,
                                            textAlign: TextAlign.right,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
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