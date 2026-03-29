import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'mapa_controller.dart';
import '../start_screen.dart';
import '../../utils/dialog_manager.dart';
import '../../utils/vzdalenost_bodu.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/app_bar_play.dart';
import '../../widgets/mapa_markers.dart';
import '../../widgets/panel_presun.dart';
import '../../widgets/panel_dorazil.dart';
import '../../widgets/gps_error_panel.dart';
import '../../widgets/center_user_button.dart';
import '../../widgets/radar_layer.dart';
import '../../data/mise_data.dart';
import '../../widgets/map_zoom_buttons.dart';
import '../../widgets/audio_player.dart';
import '../../widgets/archiv_mise_popup.dart';

class MapaScreen extends StatefulWidget {
  const MapaScreen({super.key});

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> with SingleTickerProviderStateMixin {
  late MapaController c;

  @override
  void initState() {
    super.initState();
    c = MapaController(
      notifyListeners: () => setState(() {}),
      vsync: this,
      context: context,
      isMounted: () => mounted,
    );
  }

  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  PreferredSizeWidget _buildAppBar() {
    if (c.stavHry == 0) {
      return MyAppBar(
        levaIkona: Icons.menu,
        naLevaIkonaKlik: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const StartScreen())),
      );
    } else if (c.stavHry == 3) {
      return AppBarPlay(
        nazevMise: 'Archiv: ${dataMise.nazev}',
        postup: '${trasaMise.length}/${trasaMise.length}',
        onMenuClick: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const StartScreen())),
        onCloseClick: () => c.prepniNaStav(0),
      );
    } else {
      return AppBarPlay(
        nazevMise: dataMise.nazev,
        postup: '${c.aktualniBod - 1}/${trasaMise.length}',
        onMenuClick: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const StartScreen())),
        onCloseClick: () => c.prepniNaStav(0),
      );
    }
  }

  List<Marker> _buildMarkers(bool testBodJeBlizko) {
    return [
      if (c.userLatLng != null) MarkerBuilder.buildUserMarker(c.userLatLng!),

      if (c.stavHry == 0) MarkerBuilder.buildStartMarker(trasaMise.first, c.onMarkerTap),

      // Zobrazení "bubliny" POD startovním bodem, pokud je mise dokončena
      if (c.stavHry == 0 && c.miseDokoncena)
        MarkerBuilder.buildDokoncenaBublinaMarker(trasaMise.first, c.onMarkerTap),

      if (c.stavHry > 0)
        for (int i = 0; i < trasaMise.length; i++)
          if (c.stavHry == 3)
            MarkerBuilder.buildNormalMarker(trasaMise[i], () => DialogManager.ukazPribehPopup(
                context: context, historieBodu: trasaMise.sublist(0, i + 1), miseData: dataMise, onPokracovat: () {}))
          else if (i < c.aktualniBod)
            if (i == c.aktualniBod - 1)
              c.stavHry == 1 ? MarkerBuilder.buildNormalMarker(trasaMise[i], c.onMarkerTap) : MarkerBuilder.buildBigMarker(trasaMise[i])
            else
              MarkerBuilder.buildSmallDotMarker(trasaMise[i]),

      MarkerBuilder.buildTestDotMarker(testBod, jeBlizko: testBodJeBlizko),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final bool testBodJeBlizko = c.userLatLng != null && VzdalenostBodu.jeUBodu(
        userLat: c.userLatLng!.latitude, userLon: c.userLatLng!.longitude, cilovyBod: testBod, perimetrMetry: 28);

    return Scaffold(
      appBar: _buildAppBar(),
      floatingActionButton: CenterUserButton(isFollowing: c.followUser, stavHry: c.stavHry, onPressed: c.centerOnUser),
      body: Stack(
        children: [
          FlutterMap(
            mapController: c.mapController,
            options: MapOptions(
              initialCenter: c.userLatLng ?? const LatLng(50.6653, 14.0255),
              initialZoom: 16.5,
              onPositionChanged: (pos, hasGesture) { if (hasGesture && c.followUser) c.zmenStav(() => c.followUser = false); },
            ),
            children: [
              TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', userAgentPackageName: 'cz.ujep.bod', keepBuffer: 3,),

              if (c.pevnaTrasa.isNotEmpty) PolylineLayer(polylines: [Polyline(points: c.pevnaTrasa, color: Colors.black, strokeWidth: 5.0)]),
              if (c.stavHry == 1 && c.trasaPoChodniku.isNotEmpty) PolylineLayer(polylines: [Polyline(points: c.trasaPoChodniku, color: const Color(0xE6FAED41), strokeWidth: 5.0)]),

              if (c.userLatLng != null) RadarLayer(position: c.userLatLng!, animation: c.radarAnimation),

              MarkerLayer(markers: _buildMarkers(testBodJeBlizko)),
            ],
          ),

          if (c.locationError != null) GpsErrorPanel(errorText: c.locationError!, onRetry: c.startLocationTracking),
          Positioned(top: 20, right: 20, child: MapZoomButtons(mapController: c.mapController)),

          if (c.miseDokoncena && (c.stavHry == 0 || c.stavHry == 3))
            Positioned(
              top: 20, left: 20,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 4, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10)),
                icon: const Icon(Icons.refresh, size: 20), label: const Text('Reset', style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: c.resetMise,
              ),
            ),

          if (c.aktivniBonus != null && c.stavHry == 1 && c.skrytyPrehravac)
            Positioned(
              top: 20, left: 20,
              child: FloatingActionButton(heroTag: 'audioBtn', backgroundColor: const Color(0xFFFAED41), mini: true, onPressed: () => c.zmenStav(() => c.skrytyPrehravac = false), child: const Icon(Icons.music_note, color: Colors.black)),
            ),

          if (c.aktivniBonus != null && c.stavHry == 1 && !c.skrytyPrehravac)
            Positioned(
              top: 12, left: 0, right: 65,
              child: MiniAudioPlayer(nazevSkladby: c.aktivniBonus!.bonusoveStranky!.first.text, audioPath: c.aktivniBonus!.bonusAudioPath!, onZavrit: () => c.zmenStav(() => c.skrytyPrehravac = true)),
            ),

          if (c.stavHry == 1) PanelPresun(bodData: trasaMise[c.aktualniBod - 1], aktualniBod: c.aktualniBod),
          if (c.stavHry == 2) PanelDorazil(bodData: trasaMise[c.aktualniBod - 1], aktualniBod: c.aktualniBod, onOtevrit: () => DialogManager.ukazPribehPopup(context: context, historieBodu: trasaMise.sublist(0, c.aktualniBod), miseData: dataMise, onPokracovat: c.onPribehPokracovat)),

          // --- NOVINKA: INTERAKTIVNÍ VYSOUVACÍ PANEL V ARCHIVU ---
          if (c.stavHry == 3)
            DraggableScrollableSheet(
              initialChildSize: 0.35,
              minChildSize: 0.12,
              maxChildSize: 0.45,
              snap: true,
              builder: (BuildContext context, ScrollController scrollController) {
                return ArchivMisePopup(
                  miseData: dataMise,
                  pocetBodu: trasaMise.length,
                  scrollController: scrollController,
                );
              },
            ),
        ],
      ),
    );
  }
}