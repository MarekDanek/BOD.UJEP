import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/logika_cesty.dart';
import '../../utils/dialog_manager.dart';
import '../../utils/gps_logika.dart';
import '../../data/mise_data.dart';
import '../../widgets/bonus_popup.dart';
import '../../widgets/konec_mise_popup.dart';
import '../../widgets/slide_bonus.dart';
import '../../utils/vzdalenost_bodu.dart';



class MapaController {
  final VoidCallback notifyListeners;
  final TickerProvider vsync;
  final BuildContext context;
  final bool Function() isMounted;

  
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
  LatLng? userLatLng;
  String? locationError;
  bool followUser = true;

  bool jeBodZamknuty = false;

  late final AnimationController radarController;
  late final Animation<double> radarAnimation;

  MapaController({
    required this.notifyListeners,
    required this.vsync,
    required this.context,
    required this.isMounted,
  }) {
    _init();
  }

  void _init() {
    loadMiseState();
    radarController = AnimationController(vsync: vsync, duration: const Duration(seconds: 2))..repeat(reverse: true);
    radarAnimation = CurvedAnimation(parent: radarController, curve: Curves.easeInOut);
    startLocationTracking();
  }

  void dispose() {
    _positionSub?.cancel();
    radarController.dispose();
  }

  void zmenStav(VoidCallback akce) {
    akce();
    notifyListeners();
  }

  Future<void> loadMiseState() async {
    final prefs = await SharedPreferences.getInstance();
    if (isMounted()) {
      zmenStav(() {
        miseDokoncena = prefs.getBool('mise_kunes_hotovo') ?? false;
        celkovyCasSekundy = prefs.getInt('mise_kunes_cas') ?? 0;
        celkovaVzdalenostMetry = prefs.getDouble('mise_kunes_vzdalenost') ?? 0.0;
      });
    }
  }

  Future<void> saveMiseState(bool hotovo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('mise_kunes_hotovo', hotovo);
    await prefs.setInt('mise_kunes_cas', celkovyCasSekundy);
    await prefs.setDouble('mise_kunes_vzdalenost', celkovaVzdalenostMetry);
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
            onPressed: () {
              Navigator.pop(context);
              zmenStav(() {
                miseDokoncena = false; stavHry = 0; aktualniBod = 1;
                trasaPoChodniku.clear(); pevnaTrasa.clear(); aktivniBonus = null;
                startTime = null;
                celkovyCasSekundy = 0;
                celkovaVzdalenostMetry = 0.0;
                lastTrackedPosition = null;
              });
              saveMiseState(false);
            },
            child: const Text('Resetovat', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
    if (userLatLng == null || aktualniBod > trasaMise.length) return;
    final cilovyBod = trasaMise[aktualniBod - 1];
    final novaTrasa = await LogikaCesty.ziskejTrasuPoChodniku([userLatLng!, LatLng(cilovyBod.lat, cilovyBod.lon)]);
    if (isMounted()) zmenStav(() => trasaPoChodniku = novaTrasa);
  }

  Future<void> vypocitejHistorickouTrasu() async {
    try {
      final List<LatLng> body = (stavHry == 3)
          ? trasaMise.map((b) => LatLng(b.lat, b.lon)).toList()
          : (aktualniBod < 2) ? [] : trasaMise.sublist(0, aktualniBod).map((b) => LatLng(b.lat, b.lon)).toList();

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
  }

  void onStartVyrazit() {
    startTime = DateTime.now();
    celkovaVzdalenostMetry = 0.0;
    lastTrackedPosition = userLatLng;

    prepniNaStav(1);
    vypocitejTrasu();
  }

  void posunNaDalsiBod() {
    if (aktualniBod < trasaMise.length) {
      zmenStav(() => aktualniBod++);
      prepniNaStav(1);
      vypocitejTrasu();
      vypocitejHistorickouTrasu();
    } else {
      if (startTime != null) {
        celkovyCasSekundy = DateTime.now().difference(startTime!).inSeconds;
      }
      zobrazKonecMise();
    }
  }

  void zobrazKonecMise() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => KonecMisePopup(
        historieBodu: trasaMise,
        miseData: dataMise,
        onUzavrit: () {
          Navigator.pop(context);
          zmenStav(() => miseDokoncena = true);
          prepniNaStav(0);
          saveMiseState(true);
        },
        onBonusy: () {
          final vsetkyBonusy = trasaMise
              .where((bod) => bod.bonusoveStranky != null)
              .expand((bod) => bod.bonusoveStranky!.map((stranka) => ZiskanyBonus(stranka, bod.bonusAudioPath)))
              .toList();
          Navigator.push(context, MaterialPageRoute(fullscreenDialog: true, builder: (context) => PrehledBonusuPopup(vsetkyBonusy: vsetkyBonusy)));
        },
      ),
    );
  }

  void onPribehPokracovat() {
    final soucasnyBod = trasaMise[aktualniBod - 1];
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


 

  
  void onMarkerTap() {
        final bool bodJeBlizko = userLatLng != null && VzdalenostBodu.jeUBodu(
        userLat: userLatLng!.latitude, userLon: userLatLng!.longitude, cilovyBod: trasaMise[aktualniBod-1], perimetrMetry: 28);
    if (!bodJeBlizko &&  jeBodZamknuty){ return;}
    if (miseDokoncena) {
      zmenStav(() { stavHry = 3; aktualniBod = trasaMise.length; });
      vypocitejHistorickouTrasu();
    } else {
      if (stavHry == 0) {
        DialogManager.ukazStartPopup(context: context, miseData: dataMise, onVyrazit: onStartVyrazit);
      } else if (stavHry == 1) {
        prepniNaStav(2);
      }
    }
  }

  String getFormattedTime() {
    final int minuty = celkovyCasSekundy ~/ 60;
    return '$minuty min';
  }

  String getFormattedDistance() {
    if (celkovaVzdalenostMetry > 1000) {
      return '${(celkovaVzdalenostMetry / 1000).toStringAsFixed(1)} km';
    }
    return '${celkovaVzdalenostMetry.toInt()} m';
  }
}