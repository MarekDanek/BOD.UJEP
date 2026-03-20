import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:async';
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

class MapaScreen extends StatefulWidget {
  const MapaScreen({super.key});

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> with SingleTickerProviderStateMixin {
  int stavHry = 0;
  int aktualniBod = 1;
  List<LatLng> trasaPoChodniku = [];

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
    // Pokud nemáme GPS polohu nebo jsme na konci, nepočítáme
    if (_userLatLng == null || aktualniBod > trasaMise.length) return;

    final cilovyBod = trasaMise[aktualniBod - 1];

    // TADY JE TA KRÁSA: Prostě jen vytvoříme seznam dvou souřadnic (Hráč -> Cíl)
    final bodyKPropojeni = [
      _userLatLng!,
      LatLng(cilovyBod.lat, cilovyBod.lon),
    ];

    // A pošleme je do naší upravené univerzální funkce
    final novaTrasa = await LogikaCesty.ziskejTrasuPoChodniku(bodyKPropojeni);

    if (mounted) {
      setState(() {
        trasaPoChodniku = novaTrasa;
      });
    }
  }

void onStartVyrazit() {
    setState(() {
      stavHry = 1;
      aktualniBod = 1;
      trasaPoChodniku.clear();
    });
    vypocitejTrasu();
  }

  void onPribehPokracovat() {
    if (aktualniBod < trasaMise.length) {
      setState(() {
        aktualniBod++;
        stavHry = 1;
      });
      vypocitejTrasu();
    } else {
      setState(() {
        stavHry = 0;
        aktualniBod = 1;
        trasaPoChodniku.clear();
      });
    }
  }

  void onMarkerTap() {
    if (stavHry == 0) {
      DialogManager.ukazStartPopup(context: context, miseData: dataMise, onVyrazit: onStartVyrazit);
    } else if (stavHry == 1) {
      setState(() => stavHry = 2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: stavHry == 0
          ? MyAppBar(levaIkona: Icons.menu, naLevaIkonaKlik: () => Navigator.pop(context))
          : AppBarPlay(
              nazevMise: dataMise.nazev,
              postup: '${aktualniBod - 1}/${trasaMise.length}',
              onMenuClick: () {},
              onCloseClick: () {
                setState(() {
                  stavHry = 0;
                  aktualniBod = 1;
                  trasaPoChodniku.clear();
                });
              },
            ),
      floatingActionButton: CenterUserButton(
        isFollowing: _followUser,
        stavHry: stavHry,
        onPressed: _centerOnUser,
      ),
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
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'cz.ujep.bod',
              ),
              if (stavHry > 0 && trasaPoChodniku.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(points: trasaPoChodniku, color: Colors.blueAccent.withOpacity(0.7), strokeWidth: 5.0),
                  ],
                ),
              if (_userLatLng != null) RadarLayer(position: _userLatLng!, animation: _radarAnimation),
              MarkerLayer(
                markers: [
                  if (_userLatLng != null) MarkerBuilder.buildUserMarker(_userLatLng!),
                  if (stavHry == 0) MarkerBuilder.buildStartMarker(trasaMise.first, onMarkerTap),
                  if (stavHry == 1) MarkerBuilder.buildNormalMarker(trasaMise[aktualniBod - 1], onMarkerTap),
                  if (stavHry == 2) MarkerBuilder.buildBigMarker(trasaMise[aktualniBod - 1]),
                ],
              ),
            ],
          ),
          Positioned(
            top: 20,
            right: 20,
            child: MapZoomButtons(mapController: _mapController),
          ),

          if (_locationError != null) GpsErrorPanel(errorText: _locationError!, onRetry: _startLocationTracking),

          if (stavHry == 1) PanelPresun(bodData: trasaMise[aktualniBod - 1], aktualniBod: aktualniBod),
          if (stavHry == 2) PanelDorazil(bodData: trasaMise[aktualniBod - 1], aktualniBod: aktualniBod, onOtevrit: () => DialogManager.ukazPribehPopup(context: context, bodData: trasaMise[aktualniBod - 1], miseData: dataMise, onPokracovat: onPribehPokracovat)),
        ],
      ),
    );
  }
}