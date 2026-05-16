import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore plugin

class KresleniTrasyScreen extends StatefulWidget {
  const KresleniTrasyScreen({super.key});

  @override
  State<KresleniTrasyScreen> createState() => _KresleniTrasyScreenState();
}

class _KresleniTrasyScreenState extends State<KresleniTrasyScreen> {
  final MapController _mapController = MapController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Seznam bodů, které se aktuálně kreslí na mapu
  List<LatLng> _nakreslenaTrasa = [];
  bool _rezimKresleni = false;

  // Formulářové kontrolery pro novou misi
  final _nazevController = TextEditingController();
  final _podnadpisController = TextEditingController();
  final _text1Controller = TextEditingController();
  final _text2Controller = TextEditingController();
  final _vzdalenostController = TextEditingController();
  final _casController = TextEditingController();

  @override
  void dispose() {
    _nazevController.dispose();
    _podnadpisController.dispose();
    _text1Controller.dispose();
    _text2Controller.dispose();
    _vzdalenostController.dispose();
    _casController.dispose();
    super.dispose();
  }

  // POMOCNÁ FUNKCE: Vypočítá vzdálenost mezi dvěma GPS body v metrech
  double _vypocitejVzdalenost(LatLng p1, LatLng p2) {
    return const Distance().as(LengthUnit.Meter, p1, p2);
  }

  // HLAVNÍ FUNKCE: Převod trasy na JSON a uložení do Firebase Firestore
  Future<void> _ulozMisiDoDatabaze() async {
    if (_nakreslenaTrasa.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nejprve musíš na mapě nakreslit nějakou trasu!')),
      );
      return;
    }

    if (_nazevController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Musíš vyplnit název mise!')),
      );
      return;
    }

    try {
      // 1. PŘEVOD (Serializace): Převedeme List<LatLng> na List<Map<String, double>> pro Firebase
      List<Map<String, double>> jsonTrasa = _nakreslenaTrasa.map((bod) {
        return {
          'lat': bod.latitude,
          'lon': bod.longitude,
        };
      }).toList();

      // 2. STRUKTURA DOKUMENTU: Přesně odpovídá tomu, co máš v souboru mise_data.dart
      Map<String, dynamic> novaMiseData = {
        'nazev': _nazevController.text.trim(),
        'podnadpis': _podnadpisController.text.trim(),
        'textCast1': _text1Controller.text.trim(),
        'textCast2': _text2Controller.text.trim(),
        'vzdalenost': _vzdalenostController.text.trim().isEmpty ? '1.2 km' : _vzdalenostController.text.trim(),
        'cas': _casController.text.trim().isEmpty ? '30 min' : _casController.text.trim(),
        'pocetBodu': '${_nakreslenaTrasa.length} bodů',
        'obtiznost': 'Střední',
        'bonusy': '0 bonusů',
        'typ': 'Příběh',
        'obrazekCesta': 'assets/placeholder.png',
        // Startovní pozice bubliny bude automaticky první bod nakreslené trasy
        'startLat': _nakreslenaTrasa.first.latitude,
        'startLon': _nakreslenaTrasa.first.longitude,
        // Zde jsou uložené souřadnice celé čáry chodníku
        'cestaChodniku': jsonTrasa, 
        'vytvorenoKdy': FieldValue.serverTimestamp(),
      };

      // 3. ZÁPIS DO FIREBASE: Uložíme do kolekce 'vsechny_mise'
      await _firestore.collection('vsechny_mise').add(novaMiseData);

      if (!mounted) return;
      
      // Vyčistíme data a zavřeme dialog
      setState(() {
        _nakreslenaTrasa.clear();
        _nazevController.clear();
        _podnadpisController.clear();
        _text1Controller.clear();
        _text2Controller.clear();
        _vzdalenostController.clear();
        _casController.clear();
      });

      Navigator.pop(context); // Zavře formulářový dialog

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(backgroundColor: Colors.green, content: Text('Mise byla úspěšně uložena do Firebase! 🎉')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text('Chyba při ukládání: $e')),
      );
    }
  }

  // Otevře vyskakovací okno s formulářem pro vyplnění textů mise
  void _ukazUkladaciFormular() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Uložit novou misi', style: TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: _nazevController, decoration: const InputDecoration(labelText: 'Název mise (např. Průzkum Klíše)')),
              const SizedBox(height: 8),
              TextField(controller: _podnadpisController, decoration: const InputDecoration(labelText: 'Podnadpis (např. Kočičí detektivka)')),
              const SizedBox(height: 8),
              TextField(controller: _text1Controller, maxLines: 3, decoration: const InputDecoration(labelText: 'Úvodní text (Část 1)')),
              const SizedBox(height: 8),
              TextField(controller: _text2Controller, maxLines: 3, decoration: const InputDecoration(labelText: 'Závěrečný text (Část 2)')),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: TextField(controller: _vzdalenostController, decoration: const InputDecoration(labelText: 'Vzdálenost', hintText: '1.2 km'))),
                  const SizedBox(width: 12),
                  Expanded(child: TextField(controller: _casController, decoration: const InputDecoration(labelText: 'Čas trvání', hintText: '30 min'))),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Zrušit', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFAED41), foregroundColor: Colors.black),
            onPressed: _ulozMisiDoDatabaze,
            child: const Text('Uložit do Firebase', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin: Kreslení a uložení tras', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFFAED41),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.black),
            onPressed: () => setState(() => _nakreslenaTrasa.clear()),
            tooltip: 'Smazat náčrt',
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            icon: const Icon(Icons.cloud_upload_outlined),
            label: const Text('Uložit misi'),
            onPressed: _ukazUkladaciFormular,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(50.665, 14.025), // UJEP Kampus
              initialZoom: 16.0,
              interactionOptions: InteractionOptions(
                flags: _rezimKresleni ? InteractiveFlag.none : InteractiveFlag.all,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'cz.ujep.admin',
              ),
              // OPRAVA: Zde je ta podmínka, která zabrání pádu
              if (_nakreslenaTrasa.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _nakreslenaTrasa,
                      color: Colors.blueAccent,
                      strokeWidth: 6.0,
                      borderColor: Colors.black,
                      borderStrokeWidth: 2.0,
                    ),
                  ],
                ),
            ],
          ),

          // Zachytávání pohybu myši / prstu
          if (_rezimKresleni)
            Positioned.fill(
              child: GestureDetector(
                onPanUpdate: (details) {
                  final latLng = _mapController.camera.screenOffsetToLatLng(details.localPosition);
                  
                  // OPTIMALIZACE (Prořeďování): Nový bod přidáme, pouze pokud je dál než 3 metry od posledního zaznamenaného bodu!
                  if (_nakreslenaTrasa.isEmpty) {
                    setState(() => _nakreslenaTrasa.add(latLng));
                  } else {
                    double vzdalenostODPosledniho = _vypocitejVzdalenost(_nakreslenaTrasa.last, latLng);
                    if (vzdalenostODPosledniho > 3.0) { // 3 metry limit
                      setState(() => _nakreslenaTrasa.add(latLng));
                    }
                  }
                },
              ),
            ),

          // Přepínač Tužka / Ruka
          Positioned(
            top: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))],
              ),
              child: Row(
                children: [
                  _buildToggleBtn(
                    titulek: 'Posun mapy',
                    ikona: Icons.pan_tool,
                    aktivni: !_rezimKresleni,
                    onTap: () => setState(() => _rezimKresleni = false),
                  ),
                  const SizedBox(width: 8),
                  _buildToggleBtn(
                    titulek: 'Kreslit trasu',
                    ikona: Icons.edit,
                    aktivni: _rezimKresleni,
                    onTap: () => setState(() => _rezimKresleni = true),
                  ),
                ],
              ),
            ),
          ),
          
          // Indikátor počtu bodů na mapě
          Positioned(
            bottom: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(20)),
              child: Text(
                'Optimalizováno na: ${_nakreslenaTrasa.length} GPS bodů',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildToggleBtn({required String titulek, required IconData ikona, required bool aktivni, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: aktivni ? const Color(0xFFFAED41) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: aktivni ? Colors.black : Colors.transparent, width: 2),
        ),
        child: Row(
          children: [
            Icon(ikona, color: aktivni ? Colors.black : Colors.grey, size: 20),
            const SizedBox(width: 8),
            Text(titulek, style: TextStyle(color: aktivni ? Colors.black : Colors.grey, fontWeight: aktivni ? FontWeight.bold : Alignment.center == null ? FontWeight.normal : FontWeight.normal)),
          ],
        ),
      ),
    );
  }
}