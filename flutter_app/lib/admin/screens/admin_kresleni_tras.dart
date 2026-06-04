import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Pomocná třída pro ukládání dat rozpracovaného bodu (Všechna data podle DB)
class PracovniBod {
  LatLng pozice;
  String nazevBodu = '';
  String podnadpis = '';
  String tipNaCestu = '';
  String textCast1 = '';
  String textCast2 = '';
  String obrazekCesta = 'assets/placeholder_bod.png'; // Výchozí text
  String bonusAudioPath = '';

  PracovniBod({required this.pozice});
}

class KresleniTrasyScreen extends StatefulWidget {
  const KresleniTrasyScreen({super.key});

  @override
  State<KresleniTrasyScreen> createState() => _KresleniTrasyScreenState();
}

class _KresleniTrasyScreenState extends State<KresleniTrasyScreen> {
  final MapController _mapController = MapController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Data pro MISI
  final _nazevCtrl = TextEditingController();
  final _podnadpisCtrl = TextEditingController();
  final _text1Ctrl = TextEditingController();
  final _text2Ctrl = TextEditingController();
  final _obtiznostCtrl = TextEditingController();
  final _casCtrl = TextEditingController();
  final _vzdalenostCtrl = TextEditingController();
  final _pocetBoduCtrl = TextEditingController();
  final _typCtrl = TextEditingController();
  final _barvaCtrl = TextEditingController(text: '#FFD700'); // Výchozí žlutá
  final _bonusyCtrl = TextEditingController(text: '0 bonusů');
  final _obrazekCtrl = TextEditingController(text: 'assets/MiseKunes_1.png');

  // Seznam bodů (zastávek)
  List<PracovniBod> _vytvoreneBody = [];
  int? _vybranyIndexBodu;

  bool _ukladaSe = false;

  @override
  void dispose() {
    _nazevCtrl.dispose(); _podnadpisCtrl.dispose();
    _text1Ctrl.dispose(); _text2Ctrl.dispose();
    _obtiznostCtrl.dispose(); _casCtrl.dispose();
    _vzdalenostCtrl.dispose(); _pocetBoduCtrl.dispose();
    _typCtrl.dispose(); _barvaCtrl.dispose();
    _bonusyCtrl.dispose(); _obrazekCtrl.dispose();
    super.dispose();
  }

  // Funkce po kliknutí na mapu -> Vytvoří nový bod
  void _pridatBodNaMapu(TapPosition tapPosition, LatLng point) {
    setState(() {
      _vytvoreneBody.add(PracovniBod(pozice: point));
      _vybranyIndexBodu = _vytvoreneBody.length - 1; 
      _pocetBoduCtrl.text = "${_vytvoreneBody.length} bodů";
    });
  }

  // ULOŽENÍ DO FIREBASE PŘESNĚ PODLE TVÉ STRUKTURY
  Future<void> _ulozitCelouMisi() async {
    if (_nazevCtrl.text.trim().isEmpty || _vytvoreneBody.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Musíš zadat název mise a přidat alespoň jeden bod do mapy!')),
      );
      return;
    }

    setState(() => _ukladaSe = true);

    try {
      // 1. Data pro hlavní dokument (Mise)
      Map<String, dynamic> dataMise = {
        'barva': _barvaCtrl.text.trim(),
        'bonusy': _bonusyCtrl.text.trim(),
        'cas': _casCtrl.text.trim(),
        'nazev': _nazevCtrl.text.trim(),
        'obrazekCesta': _obrazekCtrl.text.trim(),
        'obtiznost': _obtiznostCtrl.text.trim(),
        'pocetBodu': _pocetBoduCtrl.text.trim(),
        'podnadpis': _podnadpisCtrl.text.trim(),
        'textCast1': _text1Ctrl.text.trim(),
        'textCast2': _text2Ctrl.text.trim(),
        'typ': _typCtrl.text.trim(),
        'vzdalenost': _vzdalenostCtrl.text.trim(),
        // Extra pozice startu pro mapu
        'startLat': _vytvoreneBody.first.pozice.latitude,
        'startLon': _vytvoreneBody.first.pozice.longitude,
      };

      // Uložení hlavní mise do kolekce 'mise'
      DocumentReference novaMiseRef = await _firestore.collection('mise').add(dataMise);

      // 2. Projdeme všechny body a uložíme je do podkolekce "body"
      for (int i = 0; i < _vytvoreneBody.length; i++) {
        var b = _vytvoreneBody[i];
        Map<String, dynamic> dataBodu = {
          'id': i + 1, 
          'lat': b.pozice.latitude,
          'lon': b.pozice.longitude,
          'nazevBodu': b.nazevBodu,
          'podnadpis': b.podnadpis,
          'tipNaCestu': b.tipNaCestu,
          'textCast1': b.textCast1,
          'textCast2': b.textCast2,
          'obrazekCesta': b.obrazekCesta,
          'bonusAudioPath': b.bonusAudioPath,
          // Prázdná pole přesně tak, jak to Firebase potřebuje
          'bonusoveStranky': [], 
          'obrazkyMise': [], 
        };
        // Uložení bodu
        await novaMiseRef.collection('body').doc((i + 1).toString()).set(dataBodu);
      }

      setState(() {
        _vytvoreneBody.clear();
        _vybranyIndexBodu = null;
        _nazevCtrl.clear(); _podnadpisCtrl.clear();
        _text1Ctrl.clear(); _text2Ctrl.clear();
        _casCtrl.clear(); _vzdalenostCtrl.clear();
        _obtiznostCtrl.clear(); _typCtrl.clear();
        _ukladaSe = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('MISE BYLA ÚSPĚŠNĚ ULOŽENA!', style: TextStyle(color: Colors.green))),
        );
      }

    } catch (e) {
      setState(() => _ukladaSe = false);
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tvorba nové mise", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Row(
        children: [
          // LEVÝ PANEL - FORMULÁŘE
          Container(
            width: 400,
            color: Colors.grey[100],
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const TabBar(
                    labelColor: Colors.black,
                    indicatorColor: Color(0xFFFAED41),
                    tabs: [
                      Tab(text: "INFO O MISI"),
                      Tab(text: "ZASTÁVKY (BODY)"),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // TAB 1: FORMULÁŘ MISE
                        ListView(
                          padding: const EdgeInsets.all(16),
                          children: [
                            TextField(controller: _nazevCtrl, decoration: const InputDecoration(labelText: "Název mise (např. Mise Kuneš)")),
                            TextField(controller: _podnadpisCtrl, decoration: const InputDecoration(labelText: "Podnadpis")),
                            TextField(controller: _text1Ctrl, maxLines: 3, decoration: const InputDecoration(labelText: "Příběh - část 1")),
                            TextField(controller: _text2Ctrl, maxLines: 3, decoration: const InputDecoration(labelText: "Příběh - část 2")),
                            Row(
                              children: [
                                Expanded(child: TextField(controller: _obtiznostCtrl, decoration: const InputDecoration(labelText: "Obtížnost"))),
                                const SizedBox(width: 10),
                                Expanded(child: TextField(controller: _casCtrl, decoration: const InputDecoration(labelText: "Čas (např. 20 min)"))),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(child: TextField(controller: _vzdalenostCtrl, decoration: const InputDecoration(labelText: "Vzdálenost (např. 800 m)"))),
                                const SizedBox(width: 10),
                                Expanded(child: TextField(controller: _typCtrl, decoration: const InputDecoration(labelText: "Typ (Zvuk / Čtení)"))),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(child: TextField(controller: _barvaCtrl, decoration: const InputDecoration(labelText: "Barva (např. #FFD700)"))),
                                const SizedBox(width: 10),
                                Expanded(child: TextField(controller: _bonusyCtrl, decoration: const InputDecoration(labelText: "Počet bonusů"))),
                              ],
                            ),
                            TextField(controller: _obrazekCtrl, decoration: const InputDecoration(labelText: "Cesta k obrázku (zatím jen text)")),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              onPressed: _ukladaSe ? null : _ulozitCelouMisi,
                              icon: const Icon(Icons.cloud_upload),
                              label: Text(_ukladaSe ? "Ukládám..." : "ULOŽIT MISI DO DATABÁZE"),
                              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFAED41), foregroundColor: Colors.black, padding: const EdgeInsets.all(16)),
                            )
                          ],
                        ),

                        // TAB 2: SEZNAM A EDITACE BODŮ
                        _vybranyIndexBodu == null 
                        ? const Center(child: Text("Klikni do mapy pro přidání bodu.", style: TextStyle(color: Colors.grey)))
                        : ListView(
                            padding: const EdgeInsets.all(16),
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                color: Colors.black87,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("UPRAVUJEŠ BOD: ${_vybranyIndexBodu! + 1}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                    IconButton(
                                      icon: const Icon(Icons.close, color: Colors.red),
                                      onPressed: () => setState(() => _vybranyIndexBodu = null),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                decoration: const InputDecoration(labelText: "Název zastávky"),
                                onChanged: (val) => _vytvoreneBody[_vybranyIndexBodu!].nazevBodu = val,
                                controller: TextEditingController(text: _vytvoreneBody[_vybranyIndexBodu!].nazevBodu),
                              ),
                              TextField(
                                decoration: const InputDecoration(labelText: "Podnadpis zastávky"),
                                onChanged: (val) => _vytvoreneBody[_vybranyIndexBodu!].podnadpis = val,
                                controller: TextEditingController(text: _vytvoreneBody[_vybranyIndexBodu!].podnadpis),
                              ),
                              TextField(
                                decoration: const InputDecoration(labelText: "Tip kudy jít"),
                                maxLines: 2,
                                onChanged: (val) => _vytvoreneBody[_vybranyIndexBodu!].tipNaCestu = val,
                                controller: TextEditingController(text: _vytvoreneBody[_vybranyIndexBodu!].tipNaCestu),
                              ),
                              TextField(
                                decoration: const InputDecoration(labelText: "Příběh bodu - část 1"),
                                maxLines: 3,
                                onChanged: (val) => _vytvoreneBody[_vybranyIndexBodu!].textCast1 = val,
                                controller: TextEditingController(text: _vytvoreneBody[_vybranyIndexBodu!].textCast1),
                              ),
                              TextField(
                                decoration: const InputDecoration(labelText: "Příběh bodu - část 2"),
                                maxLines: 3,
                                onChanged: (val) => _vytvoreneBody[_vybranyIndexBodu!].textCast2 = val,
                                controller: TextEditingController(text: _vytvoreneBody[_vybranyIndexBodu!].textCast2),
                              ),
                              TextField(
                                decoration: const InputDecoration(labelText: "Cesta k obrázku (zatím jen text)"),
                                onChanged: (val) => _vytvoreneBody[_vybranyIndexBodu!].obrazekCesta = val,
                                controller: TextEditingController(text: _vytvoreneBody[_vybranyIndexBodu!].obrazekCesta),
                              ),
                              TextField(
                                decoration: const InputDecoration(labelText: "Audio soubor (nepovinné)"),
                                onChanged: (val) => _vytvoreneBody[_vybranyIndexBodu!].bonusAudioPath = val,
                                controller: TextEditingController(text: _vytvoreneBody[_vybranyIndexBodu!].bonusAudioPath),
                              ),
                            ],
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // PRAVÝ PANEL - MAPA
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: const LatLng(50.6647, 14.0258), // UJEP kampus
                initialZoom: 16.0,
                onTap: _pridatBodNaMapu,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                // Vykreslení čáry mezi body (S podmínkou z minula, aby to nepadalo)
                if (_vytvoreneBody.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: _vytvoreneBody.map((b) => b.pozice).toList(),
                        strokeWidth: 4.0,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                // Vykreslení samotných bodů
                MarkerLayer(
                  markers: _vytvoreneBody.asMap().entries.map((entry) {
                    int idx = entry.key;
                    PracovniBod bod = entry.value;
                    bool isSelected = _vybranyIndexBodu == idx;

                    return Marker(
                      width: 40, height: 40,
                      point: bod.pozice,
                      child: GestureDetector(
                        onTap: () => setState(() => _vybranyIndexBodu = idx),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFFFAED41) : Colors.black,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Center(
                            child: Text(
                              "${idx + 1}",
                              style: TextStyle(color: isSelected ? Colors.black : Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}