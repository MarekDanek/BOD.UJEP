import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_compass/flutter_compass.dart';

import '../../utils/logika_cesty.dart';
import '../../utils/dialog_manager.dart';
import '../../utils/gps_logika.dart';
import '../../data/mise_data.dart';
import '../../widgets/bonus_popup.dart';
import '../../widgets/konec_mise_popup.dart';
import '../../widgets/slide_bonus.dart';
import '../../utils/vzdalenost_bodu.dart';

class MapaController with WidgetsBindingObserver {
  Mise mise;
  final VoidCallback notifyListeners;
  final TickerProvider vsync;
  final BuildContext context;
  final bool Function() isMounted;

  bool zobrazitStartNahled = false;

  int stavHry = 0;
  int aktualniBod = 1;
  List<LatLng> trasaPoChodniku = [];
  List<LatLng> pevnaTrasa = [];
  BodMise? aktivniBonus;
  bool skrytyPrehravac = false;
  bool miseDokoncena = false;

  DateTime? startTime;
  int celkovyCasSekundy = 0;
  double celkovaVzdalenostMetry = 0.0;
  LatLng? lastTrackedPosition;

  final MapController mapController = MapController();
  StreamSubscription? _positionSub;
  StreamSubscription? _compassSub;
  LatLng? userLatLng;
  double userHeading = 0.0;
  String? locationError;
  bool followUser = true;

  bool jeBodZamknuty = true;

  late final AnimationController radarController;
  late final Animation<double> radarAnimation;

  String get _klic => mise.nazev.replaceAll(' ', '_').toLowerCase();

  MapaController({
    required this.mise,
    required this.notifyListeners,
    required this.vsync,
    required this.context,
    required this.isMounted,
  }) {
    _init();
  }

  void _init() {
    WidgetsBinding.instance.addObserver(this); 
    loadMiseState(isInit: true); 
    radarController = AnimationController(vsync: vsync, duration: const Duration(seconds: 2))..repeat(reverse: true);
    radarAnimation = CurvedAnimation(parent: radarController, curve: Curves.easeInOut);
    startLocationTracking();
    startCompassTracking();
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this); 
    _positionSub?.cancel();
    _compassSub?.cancel();
    radarController.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive || state == AppLifecycleState.detached) {
      _ulozAktualniPostup();
    }
  }

  Future<void> _ulozAktualniPostup() async {
    if (stavHry == 0 || stavHry == 3) return; 

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('${_klic}_stavHry', stavHry);
    await prefs.setInt('${_klic}_aktualniBod', aktualniBod);
    await prefs.setDouble('${_klic}_vzdalenost', celkovaVzdalenostMetry);

    if (startTime != null) {
      final odpracovano = DateTime.now().difference(startTime!).inSeconds;
      await prefs.setInt('${_klic}_cas_docasny', celkovyCasSekundy + odpracovano);
    } else {
      await prefs.setInt('${_klic}_cas_docasny', celkovyCasSekundy);
    }
  }

  void zmenStav(VoidCallback akce) {
    akce();
    notifyListeners();
  }

  void startCompassTracking() {
    _compassSub = FlutterCompass.events?.listen((event) {
      if (event.heading != null && isMounted()) {
        zmenStav(() {
          userHeading = event.heading!;
        });
      }
    });
  }

  Future<void> loadMiseState({bool isInit = false}) async {
    final prefs = await SharedPreferences.getInstance();
    if (isMounted()) {
      zmenStav(() {
        miseDokoncena = prefs.getBool('${_klic}_hotovo') ?? false;

        if (miseDokoncena) {
          celkovyCasSekundy = prefs.getInt('${_klic}_cas') ?? 0;
          celkovaVzdalenostMetry = prefs.getDouble('${_klic}_vzdalenost') ?? 0.0;
          
          stavHry = 0; 
          
          if (isInit) {
            zobrazitStartNahled = true;
          }
        } else {
          stavHry = prefs.getInt('${_klic}_stavHry') ?? 0;
          aktualniBod = prefs.getInt('${_klic}_aktualniBod') ?? 1;
          celkovaVzdalenostMetry = prefs.getDouble('${_klic}_vzdalenost') ?? 0.0;

          int ulozenyCas = prefs.getInt('${_klic}_cas_docasny') ?? 0;
          if (ulozenyCas > 0 && stavHry > 0) {
            celkovyCasSekundy = ulozenyCas;
            startTime = DateTime.now(); 
          }
        }
      });

      if (stavHry > 0) {
        vypocitejHistorickouTrasu();
      }
    }
  }

  Future<void> saveMiseState(bool hotovo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('${_klic}_hotovo', hotovo);
    await prefs.setInt('${_klic}_cas', celkovyCasSekundy);
    await prefs.setDouble('${_klic}_vzdalenost', celkovaVzdalenostMetry);

    if (hotovo) {
      await prefs.remove('${_klic}_stavHry');
      await prefs.remove('${_klic}_aktualniBod');
      await prefs.remove('${_klic}_cas_docasny');
    }
  }

  void resetMise() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Resetovat misi?', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Opravdu chceš vymazat svůj postup a jít misi odznova?', style: TextStyle(fontWeight: FontWeight.bold),),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Zrušit', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              zmenStav(() {
                zobrazitStartNahled = false;
                miseDokoncena = false; stavHry = 0; aktualniBod = 1;
                trasaPoChodniku.clear(); pevnaTrasa.clear(); aktivniBonus = null;
                startTime = null;
                celkovyCasSekundy = 0;
                celkovaVzdalenostMetry = 0.0;
                lastTrackedPosition = null;
              });
              saveMiseState(false);

              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('${_klic}_stavHry');
              await prefs.remove('${_klic}_aktualniBod');
              await prefs.remove('${_klic}_cas_docasny');
            },
            child: const Text('Resetovat', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void opustitMapu() {
    showDialog(
      context: context,
      builder: (dCtx) => AlertDialog(
        title: const Text('Přerušit misi?', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Můžeš se bezpečně vrátit k náhledu mise. Tvá pozice zůstane uložena a po kliknutí na "Vyrazit" budeš moci pokračovat.',
          style: TextStyle(fontWeight: FontWeight.bold)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dCtx).pop(),
            child: const Text('Zrušit', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('${_klic}_stavHry');
              await prefs.remove('${_klic}_aktualniBod');
              await prefs.remove('${_klic}_cas_docasny');
              await prefs.remove('${_klic}_vzdalenost');

              zmenStav(() {
                stavHry = 0;
                aktualniBod = 1;
                trasaPoChodniku.clear();
                pevnaTrasa.clear();
                startTime = null;
                celkovyCasSekundy = 0;
                celkovaVzdalenostMetry = 0.0;
                zobrazitStartNahled = false;
              });

              if (!dCtx.mounted) return;
              Navigator.of(dCtx).pop();
            },
            child: const Text('Začít odznova', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () async {
              await _ulozAktualniPostup();

              zmenStav(() {
                stavHry = 0;
                trasaPoChodniku.clear(); 
                pevnaTrasa.clear(); 
                zobrazitStartNahled = false;
              });

              if (!dCtx.mounted) return;
              Navigator.of(dCtx).pop();
            },
            child: const Text('Uložit a odejít', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Future<void> startLocationTracking() async {
    try {
      final pos = await GpsLogika.getInitialPosition();
      if (!isMounted()) return;

      zmenStav(() { userLatLng = LatLng(pos.latitude, pos.longitude); locationError = null; });
      if (followUser) mapController.move(userLatLng!, 18.0);
      lastTrackedPosition = userLatLng;

      _positionSub?.cancel();
      _positionSub = GpsLogika.getPositionStream().listen(
        (newPos) {
          if (!isMounted()) return;
          final newLatLng = LatLng(newPos.latitude, newPos.longitude);

          zmenStav(() {
            userLatLng = newLatLng;

            if ((stavHry == 1 || stavHry == 2) && lastTrackedPosition != null) {
              final distance = const Distance().as(LengthUnit.Meter, lastTrackedPosition!, newLatLng);
              if (distance > 2) {
                celkovaVzdalenostMetry += distance;
                lastTrackedPosition = newLatLng;
              }
            } else {
              lastTrackedPosition = newLatLng;
            }
          });

          if (followUser) mapController.move(userLatLng!, mapController.camera.zoom);
          if (stavHry == 1) vypocitejTrasu();
        },
        onError: (e) { if (isMounted()) zmenStav(() => locationError = e.toString().replaceAll('Exception: ', '')); },
      );
    } catch (e) {
      if (isMounted()) zmenStav(() => locationError = e.toString().replaceAll('Exception: ', ''));
    }
  }

  void centerOnUser() {
    if (userLatLng == null) return;
    zmenStav(() => followUser = true);
    mapController.move(userLatLng!, 18.0);
  }

  Future<void> vypocitejTrasu() async {
    // KONTROLA: Zabrání výpočtu, pokud hledáme bod, který neexistuje
    if (userLatLng == null || aktualniBod > mise.trasa.length) {
      return; 
    }
    final cilovyBod = mise.trasa[aktualniBod - 1];
    final novaTrasa = await LogikaCesty.ziskejTrasuPoChodniku([userLatLng!, LatLng(cilovyBod.lat, cilovyBod.lon)]);
    if (isMounted()) zmenStav(() => trasaPoChodniku = novaTrasa);
  }

  Future<void> vypocitejHistorickouTrasu() async {
    try {
      final List<LatLng> body = (stavHry == 3 || aktualniBod > mise.trasa.length)
          ? mise.trasa.map((b) => LatLng(b.lat, b.lon)).toList()
          : (aktualniBod < 2) ? [] : mise.trasa.sublist(0, aktualniBod).map((b) => LatLng(b.lat, b.lon)).toList();

      if (body.isEmpty) { zmenStav(() => pevnaTrasa = []); return; }
      final novaTrasa = await LogikaCesty.ziskejTrasuPoChodniku(body);
      if (isMounted()) zmenStav(() => pevnaTrasa = novaTrasa);
    } catch (e) { debugPrint('Chyba trasy: $e'); }
  }

  void prepniNaStav(int novyStav) {
    zmenStav(() {
      stavHry = novyStav;
      if (novyStav == 0) {
        aktualniBod = 1; trasaPoChodniku.clear(); pevnaTrasa.clear(); aktivniBonus = null; skrytyPrehravac = false;
      }
    });
    _ulozAktualniPostup(); 
  }

  void onStartVyrazit() {
    zmenStav(() {
      zobrazitStartNahled = false;
      startTime ??= DateTime.now();
    });

    lastTrackedPosition = userLatLng;
    int cilovyStav = (stavHry == 0) ? 1 : stavHry;

    prepniNaStav(cilovyStav);
    vypocitejTrasu();

    if (aktualniBod > 1) vypocitejHistorickouTrasu();
  }

  void otevriArchivMise() {
    zmenStav(() {
      stavHry = 3;
      aktualniBod = mise.trasa.length;
      zobrazitStartNahled = false;
    });
    vypocitejHistorickouTrasu();
  }

  // --- OPRAVENÁ FUNKCE PRO PŘECHOD NA DALŠÍ BOD ---
  void posunNaDalsiBod() {
    // Zkontrolujeme, zda ještě MÁME nějaký další bod
    if (aktualniBod < mise.trasa.length) {
      zmenStav(() => aktualniBod++);
      prepniNaStav(1);
      vypocitejTrasu();
      vypocitejHistorickouTrasu();
    } else {
      // Pokud NE, jsme na konci mise!
      if (startTime != null) {
        final odpracovano = DateTime.now().difference(startTime!).inSeconds;
        celkovyCasSekundy += odpracovano; // Přičteme čas
        startTime = null; // Zastavíme stopky
      }
      
      // Místo zvyšování čísla bodu rovnou zobrazíme popup
      zobrazKonecMise();
    }
  }

  void zobrazKonecMise() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => KonecMisePopup(
        historieBodu: mise.trasa,
        odehranyCas: getFormattedTime(),
        miseData: mise,
        onUzavrit: () {
          Navigator.pop(context);
          zmenStav(() => miseDokoncena = true);
          prepniNaStav(0);
          saveMiseState(true);
        },
        onBonusy: () {
          final vsetkyBonusy = mise.trasa
              .where((bod) => bod.bonusoveStranky != null)
              .expand((bod) => bod.bonusoveStranky!.map((stranka) => ZiskanyBonus(stranka, bod.bonusAudioPath)))
              .toList();
          Navigator.push(context, MaterialPageRoute(fullscreenDialog: true, builder: (context) => PrehledBonusuPopup(vsetkyBonusy: vsetkyBonusy)));
        },
      ),
    );
  }

  void onPribehPokracovat() {
    final soucasnyBod = mise.trasa[aktualniBod - 1];
    if (soucasnyBod.bonusoveStranky?.isNotEmpty ?? false) {
      Navigator.of(context).push(MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => BonusPopupMultipage(
          bodData: soucasnyBod,
          onVyrazitPokracovat: () {
            if (soucasnyBod.bonusAudioPath != null) zmenStav(() { aktivniBonus = soucasnyBod; skrytyPrehravac = false; });
            posunNaDalsiBod();
          },
        ),
      ));
    } else {
      posunNaDalsiBod();
    }
  }

  void onMissionTap(Mise vybrana) async {
    if (stavHry != 0 && stavHry != 3) return;
    
    if (mise.nazev == vybrana.nazev && stavHry == 0) {
      zmenStav(() => zobrazitStartNahled = !zobrazitStartNahled);
    } else {
      zmenStav(() {
        mise = vybrana;
        zobrazitStartNahled = true; 
        trasaPoChodniku.clear();
        pevnaTrasa.clear();
        stavHry = 0; 
      });
      await loadMiseState(isInit: false);
    }
  }

  void onMarkerTap(int index) {
    if (stavHry == 0) return;
    
    final cilovyBod = mise.trasa[index];
    final bool bodJeBlizko = userLatLng != null && VzdalenostBodu.jeUBodu(
        userLat: userLatLng!.latitude, userLon: userLatLng!.longitude, cilovyBod: cilovyBod, perimetrMetry: 28);
    
    if (!bodJeBlizko && jeBodZamknuty && stavHry != 0){ return;}

    if (miseDokoncena) {
      zmenStav(() { stavHry = 3; aktualniBod = mise.trasa.length; });
      vypocitejHistorickouTrasu();
    } else {
      zmenStav(() {
        if (aktualniBod == index + 1) {
           if (stavHry == 1) stavHry = 2;
        } else {
           aktualniBod = index + 1;
           stavHry = 1;
        }
      });
      vypocitejTrasu();
      vypocitejHistorickouTrasu();
    }
  }

  String getFormattedTime() {
    final int hodiny = celkovyCasSekundy ~/ 3600;
    final int minuty = (celkovyCasSekundy % 3600) ~/ 60;
    final int sekundy = celkovyCasSekundy % 60;
    final List<String> casti = [];
    if (hodiny > 0) casti.add('$hodiny h');
    if (minuty > 0) casti.add('$minuty min');
    if (sekundy > 0) casti.add('$sekundy s');
    if (casti.isEmpty) return '0 s';
    return casti.join(' ');
  }

  String getFormattedDistance() {
    if (celkovaVzdalenostMetry > 1000) {
      return '${(celkovaVzdalenostMetry / 1000).toStringAsFixed(1)} km';
    }
    return '${celkovaVzdalenostMetry.toInt()} m';
  }

  void resetSmeru() {
    mapController.rotate(0);
    notifyListeners();
  }

  void onStartPreviewTap() {
    zmenStav(() => zobrazitStartNahled = false);
    DialogManager.ukazStartPopup(
      context: context,
      miseData: mise,
      onVyrazit: onStartVyrazit,
    );
  }
}