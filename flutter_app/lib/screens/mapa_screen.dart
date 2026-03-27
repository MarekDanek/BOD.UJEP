import 'package:bod_ujep_app/screens/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/logika_cesty.dart';
import '../utils/dialog_manager.dart';
import '../utils/gps_logika.dart';
import '../widgets/app_bar.dart';
import '../widgets/app_bar_play.dart';
import '../widgets/mapa_markers.dart';
import '../widgets/panel_presun.dart';
import '../widgets/panel_dorazil.dart';
import '../widgets/gps_error_panel.dart';
import '../widgets/center_user_button.dart';
import '../widgets/radar_layer.dart';
import '../data/mise_data.dart';
import '../widgets/map_zoom_buttons.dart';
import '../widgets/audio_player.dart';
import '../widgets/bonus_popup.dart';
import '../utils/vzdalenost_bodu.dart';
import '../widgets/konec_mise_popup.dart';
import '../widgets/slide_bonus.dart'; // Ujisti se, že třída se jmenuje SlideBonus

class MapaScreen extends StatefulWidget {
  const MapaScreen({super.key});

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> with SingleTickerProviderStateMixin {
  int stavHry = 0; // 0: Start, 1: Přesun, 2: Dorazil, 3: Archiv (Prohlížení)
  int aktualniBod = 1;
  List<LatLng> trasaPoChodniku = [];
  List<LatLng> pevnaTrasa = [];
  BodMise? aktivniBonus;
  bool skrytyPrehravac = false;
  bool miseDokoncena = false;

  final MapController _mapController = MapController();
  StreamSubscription? _positionSub;
  LatLng? _userLatLng;
  String? _locationError;
  bool _followUser = true;

  late final AnimationController _radarController;
  late final Animation<double> _radarAnimation;

  @override
  void initState() {
    super.initState();
    _loadMiseState();
    _radarController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _radarAnimation = CurvedAnimation(parent: _radarController, curve: Curves.easeInOut);
    _startLocationTracking();
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    _radarController.dispose();
    super.dispose();
  }

  Future<void> _loadMiseState() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        miseDokoncena = prefs.getBool('mise_kunes_hotovo') ?? false;
      });
    }
  }

  Future<void> _saveMiseState(bool hotovo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('mise_kunes_hotovo', hotovo);
  }

  void _resetMise() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Resetovat misi?', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Opravdu chceš vymazat svůj postup a jít misi odznova?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Zrušit', style: TextStyle(color: Colors.black))),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                miseDokoncena = false;
                stavHry = 0;
                aktualniBod = 1;
                trasaPoChodniku.clear();
                pevnaTrasa.clear();
                aktivniBonus = null;
              });
              _saveMiseState(false);
            },
            child: const Text('Resetovat', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Future<void> _startLocationTracking() async {
    try {
      final pos = await GpsLogika.getInitialPosition();
      if (!mounted) return;

      final latLng = LatLng(pos.latitude, pos.longitude);
      setState(() {
        _userLatLng = latLng;
        _locationError = null;
      });
      if (_followUser) _mapController.move(latLng, 18.0);

      _positionSub?.cancel();
      _positionSub = GpsLogika.getPositionStream().listen(
        (newPos) {
          if (!mounted) return;
          final newLatLng = LatLng(newPos.latitude, newPos.longitude);
          setState(() => _userLatLng = newLatLng);
          if (_followUser) _mapController.move(newLatLng, _mapController.camera.zoom);

          if (stavHry == 1) vypocitejTrasu();
        },
        onError: (e) {
          if (!mounted) return;
          setState(() => _locationError = e.toString().replaceAll('Exception: ', ''));
        },
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _locationError = e.toString().replaceAll('Exception: ', ''));
    }
  }

  void _centerOnUser() {
    if (_userLatLng == null) return;
    setState(() => _followUser = true);
    _mapController.move(_userLatLng!, 18.0);
  }

  Future<void> vypocitejTrasu() async {
    if (_userLatLng == null || aktualniBod > trasaMise.length) return;
    final cilovyBod = trasaMise[aktualniBod - 1];
    final bodyKPropojeni = [_userLatLng!, LatLng(cilovyBod.lat, cilovyBod.lon)];
    final novaTrasa = await LogikaCesty.ziskejTrasuPoChodniku(bodyKPropojeni);
    if (mounted) setState(() => trasaPoChodniku = novaTrasa);
  }

  Future<void> vypocitejHistorickouTrasu() async {
    try {
      final List<LatLng> bodyKPropojeni;
      if (stavHry == 3) {
        bodyKPropojeni = trasaMise.map((b) => LatLng(b.lat, b.lon)).toList();
      } else {
        if (aktualniBod < 2) {
          setState(() => pevnaTrasa = []);
          return;
        }
        bodyKPropojeni = trasaMise.sublist(0, aktualniBod).map((b) => LatLng(b.lat, b.lon)).toList();
      }
      final novaTrasa = await LogikaCesty.ziskejTrasuPoChodniku(bodyKPropojeni);
      if (mounted) setState(() => pevnaTrasa = novaTrasa);
    } catch (e) {
      debugPrint('Chyba při stahování trasy: $e');
    }
  }

  void onStartVyrazit() {
    setState(() {
      stavHry = 1;
      aktualniBod = 1;
      trasaPoChodniku.clear();
      pevnaTrasa.clear();
      aktivniBonus = null;
      skrytyPrehravac = false;
    });
    vypocitejTrasu();
  }

  void _posunNaDalsiBod() {
    if (aktualniBod < trasaMise.length) {
      setState(() {
        aktualniBod++;
        stavHry = 1;
      });
      vypocitejTrasu();
      vypocitejHistorickouTrasu();
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => KonecMisePopup(
          historieBodu: trasaMise,
          miseData: dataMise,
          onUzavrit: () {
            Navigator.pop(context);
            setState(() {
              miseDokoncena = true;
              stavHry = 0;
              aktualniBod = 1;
              trasaPoChodniku.clear();
              pevnaTrasa.clear();
              aktivniBonus = null;
              skrytyPrehravac = false;
            });
            _saveMiseState(true);
          },
          onBonusy: () {
            List<ZiskanyBonus> vsetkyBonusy = [];
            for (var bod in trasaMise) {
              if (bod.bonusoveStranky != null) {
                for (var stranka in bod.bonusoveStranky!) {
                  vsetkyBonusy.add(ZiskanyBonus(stranka, bod.bonusAudioPath));
                }
              }
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => PrehledBonusuPopup(vsetkyBonusy: vsetkyBonusy),
              ),
            );
          },
        ),
      );
    }
  }

  void onPribehPokracovat() {
    final soucasnyBod = trasaMise[aktualniBod - 1];
    if (soucasnyBod.bonusoveStranky != null && soucasnyBod.bonusoveStranky!.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => BonusPopupMultipage(
            bodData: soucasnyBod,
            onVyrazitPokracovat: () {
              setState(() {
                if (soucasnyBod.bonusAudioPath != null) {
                  aktivniBonus = soucasnyBod;
                  skrytyPrehravac = false;
                }
              });
              _posunNaDalsiBod();
            },
          ),
        ),
      );
    } else {
      _posunNaDalsiBod();
    }
  }

  void onMarkerTap() {
    if (miseDokoncena) {
      // --- KLÍČOVÝ FIX PRO ARCHIV/EMULÁTOR ---
      setState(() {
        stavHry = 3; // Přejdeme do režimu prohlížení
        aktualniBod = trasaMise.length; // Odemkneme vizuálně celou trasu
      });
      vypocitejHistorickouTrasu(); // Černá trasa
    } else {
      if (stavHry == 0) {
        DialogManager.ukazStartPopup(context: context, miseData: dataMise, onVyrazit: onStartVyrazit);
      } else if (stavHry == 1) {
        // --- KLÍČOVÝ FIX PRO BĚŽNOU HRU (ZAMRZNUTÍ) ---
        // V emulátoru se to může zaseknout na GPS,
        // vynutíme přechod do stavu "dorazil" pro testování.
        setState(() => stavHry = 2);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool testBodJeBlizko = _userLatLng != null &&
        VzdalenostBodu.jeUBodu(userLat: _userLatLng!.latitude, userLon: _userLatLng!.longitude, cilovyBod: testBod, perimetrMetry: 28);

    return Scaffold(
      appBar: (stavHry == 0 || stavHry == 3)
          ? MyAppBar(
              levaIkona: Icons.menu,
              naLevaIkonaKlik: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const StartScreen())),
            )
          : AppBarPlay(
              nazevMise: dataMise.nazev,
              postup: '${aktualniBod - 1}/${trasaMise.length}',
              onMenuClick: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const StartScreen())),
              onCloseClick: () {
                setState(() {
                  stavHry = 0;
                  aktualniBod = 1;
                  trasaPoChodniku.clear();
                  pevnaTrasa.clear();
                  aktivniBonus = null;
                  skrytyPrehravac = false;
                });
              },
            ),
      floatingActionButton: CenterUserButton(isFollowing: _followUser, stavHry: stavHry, onPressed: _centerOnUser),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _userLatLng ?? const LatLng(50.6653, 14.0255),
              initialZoom: 16.5,
              onPositionChanged: (position, hasGesture) {
                if (hasGesture && _followUser) setState(() => _followUser = false);
              },
            ),
            children: [
              TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', userAgentPackageName: 'cz.ujep.bod'),

              if (pevnaTrasa.isNotEmpty) // Vykreslí trasu jen když existují body (fix mrazu)
                PolylineLayer(polylines: [Polyline(points: pevnaTrasa, color: Colors.black, strokeWidth: 5.0)]),

              if (stavHry == 1 && trasaPoChodniku.isNotEmpty)
                PolylineLayer(polylines: [Polyline(points: trasaPoChodniku, color: const Color(0xE6FAED41), strokeWidth: 5.0)]),

              if (_userLatLng != null) RadarLayer(position: _userLatLng!, animation: _radarAnimation),

              MarkerLayer(
                markers: [
                  if (_userLatLng != null) MarkerBuilder.buildUserMarker(_userLatLng!),
                  if (stavHry == 0) MarkerBuilder.buildStartMarker(trasaMise.first, onMarkerTap),
                  if (stavHry > 0)
                    for (int i = 0; i < trasaMise.length; i++)
                      if (stavHry == 3)
                        MarkerBuilder.buildNormalMarker(trasaMise[i], () {
                          DialogManager.ukazPribehPopup(
                            context: context,
                            historieBodu: trasaMise.sublist(0, i + 1),
                            miseData: dataMise,
                            // --- KLÍČOVÝ FIX PRO ARCHIV (ČERNÁ OBRAZOVKA) ---
                            // Záměrně prázdné - vyskakovací okno se zavře samo
                            onPokracovat: () {},
                          );
                        })
                      else if (i < aktualniBod)
                        if (i == aktualniBod - 1)
                          stavHry == 1 ? MarkerBuilder.buildNormalMarker(trasaMise[i], onMarkerTap) : MarkerBuilder.buildBigMarker(trasaMise[i])
                        else
                          MarkerBuilder.buildSmallDotMarker(trasaMise[i]),
                  MarkerBuilder.buildTestDotMarker(testBod, jeBlizko: testBodJeBlizko),
                ],
              ),
            ],
          ),

          if (_locationError != null) GpsErrorPanel(errorText: _locationError!, onRetry: _startLocationTracking),
          Positioned(top: 20, right: 20, child: MapZoomButtons(mapController: _mapController)),

          if (miseDokoncena && (stavHry == 0 || stavHry == 3))
            Positioned(
              top: 20, left: 20,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, foregroundColor: Colors.black,
                  elevation: 4, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                icon: const Icon(Icons.refresh, size: 20),
                label: const Text('Reset', style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: _resetMise,
              ),
            ),

          if (aktivniBonus != null && stavHry == 1 && skrytyPrehravac)
            Positioned(
              top: 20, left: 20,
              child: FloatingActionButton(
                heroTag: 'reopenAudioBtn', backgroundColor: const Color(0xFFFAED41), mini: true,
                child: const Icon(Icons.music_note, color: Colors.black),
                onPressed: () => setState(() => skrytyPrehravac = false),
              ),
            ),

          if (aktivniBonus != null && stavHry == 1 && !skrytyPrehravac)
            Positioned(
              top: 12, left: 0, right: 65,
              child: MiniAudioPlayer(
                nazevSkladby: aktivniBonus!.bonusoveStranky!.first.text, audioPath: aktivniBonus!.bonusAudioPath!,
                onZavrit: () => setState(() => skrytyPrehravac = true),
              ),
            ),

          if (stavHry == 1) PanelPresun(bodData: trasaMise[aktualniBod - 1], aktualniBod: aktualniBod),
          if (stavHry == 2) PanelDorazil(
            bodData: trasaMise[aktualniBod - 1], aktualniBod: aktualniBod,
            onOtevrit: () => DialogManager.ukazPribehPopup(
              context: context,
              historieBodu: trasaMise.sublist(0, aktualniBod),
              miseData: dataMise,
              // --- KLÍČOVÝ FIX PRO BĚŽNOU HRU ---
              onPokracovat: onPribehPokracovat
            )
          ),
        ],
      ),
    );
  }
}