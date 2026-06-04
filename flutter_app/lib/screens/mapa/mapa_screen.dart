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
import '../../widgets/zamek_bodu_button.dart';
import '../../widgets/start_nahled_bublina.dart';

class MapaScreen extends StatefulWidget {
  final Mise vybranaMise; 

  const MapaScreen({super.key, required this.vybranaMise});

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> with SingleTickerProviderStateMixin {
  late MapaController c;

  @override
  void initState() {
    super.initState();
    c = MapaController(
      mise: widget.vybranaMise,
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
        nazevMise: 'Archiv: ${c.mise.nazev}',
        postup: '${c.mise.trasa.length}/${c.mise.trasa.length}',
        onMenuClick: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const StartScreen())),
        onCloseClick: () => c.prepniNaStav(0),
      );
    } else {
      return AppBarPlay(
        nazevMise: c.mise.nazev,
        postup: '${c.aktualniBod - 1}/${c.mise.trasa.length}',
        onMenuClick: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const StartScreen())),
        onCloseClick: () => c.opustitMapu(),
      );
    }
  }

  List<Marker> _buildMarkers(bool bodJeBlizko) {
    return [
      if (c.userLatLng != null)
        MarkerBuilder.buildUserMarker(c.userLatLng!, c.userHeading),

      // --- NÁHLED (stav 0): ZOBRAZÍME VŠECHNY MISE NAJEDNOU ---
      if (c.stavHry == 0)
        for (var m in vsechnyMise) ...[
          MarkerBuilder.buildStartMarker(m, () => c.onMissionTap(m)),
          
          // ZMĚNA: Zde se ošetřuje, jakou bublinu to má vyhodit po kliknutí
          if (c.zobrazitStartNahled && c.mise.nazev == m.nazev)
            if (c.miseDokoncena)
              // KDYŽ JE HOTOVO: Zobrazí "Dokončená bublina". Její kliknutí vede na otevriArchivMise!
              MarkerBuilder.buildDokoncenaBublinaMarker(m, c.otevriArchivMise)
            else
              // KDYŽ NENÍ HOTOVO: Zobrazí StartNáhledBublinu
              Marker(
                point: LatLng(m.startLat, m.startLon),
                width: 240,
                height: 140,
                alignment: Alignment.center,
                rotate: true,
                child: FractionalTranslation(
                  translation: const Offset(0, -0.1),
                  child: StartNahledBublina(
                    nazev: m.nazev,
                    podnadpis: m.podnadpis,
                    lat: m.startLat,
                    lon: m.startLon,
                    onTap: c.onStartPreviewTap,
                  ),
                ),
              )
        ],

      // --- HRA (stav > 0): ZOBRAZÍME BODY POSTUPNĚ ---
      if (c.stavHry > 0)
        for (int i = 0; i < c.mise.trasa.length; i++)
          if (c.stavHry == 3)
            MarkerBuilder.buildPassedPointCircleMarkerWithOnTap(c.mise.trasa[i], () => DialogManager.ukazPribehPopup(
                context: context, historieBodu: c.mise.trasa.sublist(0, i + 1), miseData: c.mise, onPokracovat: () {}))
          
          else if (i == c.aktualniBod - 1)
            c.stavHry == 1 
                ? MarkerBuilder.buildNormalMarker(c.mise.trasa[i], () => c.onMarkerTap(i), jeBlizko: bodJeBlizko) 
                : MarkerBuilder.buildBigMarker(c.mise.trasa[i])
          
          else if (i < c.aktualniBod - 1)
            MarkerBuilder.buildPassedPointCircleMarkerWithOnTap(c.mise.trasa[i], () => c.onMarkerTap(i)),
    ];
  }

 @override
  Widget build(BuildContext context) {
    final bool bodJeBlizko = c.userLatLng != null && c.stavHry != 0 && VzdalenostBodu.jeUBodu(
        userLat: c.userLatLng!.latitude, userLon: c.userLatLng!.longitude, cilovyBod: c.mise.trasa[c.aktualniBod-1], perimetrMetry: 12);

    return Scaffold(
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          FlutterMap(
            mapController: c.mapController,
            options: MapOptions(
              initialCenter: c.userLatLng ?? LatLng(c.mise.startLat, c.mise.startLon),
              initialZoom: 16.5,
              minZoom: 10.0,
              maxZoom: 19.0,
              onPositionChanged: (pos, hasGesture) { if (hasGesture && c.followUser) c.zmenStav(() => c.followUser = false); },
            ),
            children: [
              TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', userAgentPackageName: 'cz.ujep.bod', keepBuffer: 3,),

              if (c.stavHry == 0 && c.zobrazitStartNahled)
                Positioned.fill(
                child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => c.zmenStav(() => c.zobrazitStartNahled = false),
                child: const SizedBox.expand(),
                ),
              ),

              if (c.pevnaTrasa.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: c.pevnaTrasa,
                      color: const Color(0xFFFAED41),
                      strokeWidth: 5.0,
                      borderColor: Colors.black,
                      borderStrokeWidth: 2.0,
                    )
                  ]
                ),

              if (c.stavHry == 1 && c.trasaPoChodniku.isNotEmpty) PolylineLayer(polylines: [Polyline(points: c.trasaPoChodniku, color: const Color(0xE6FAED41), strokeWidth: 5.0)]),

              if (c.userLatLng != null) RadarLayer(position: c.userLatLng!, animation: c.radarAnimation),

              MarkerLayer(markers: _buildMarkers(bodJeBlizko)),
            ],
          ),
          Positioned(
          right: 22,
          top: 140,
          child: CenterUserButton(
          size: 40,
          isFollowing: c.followUser,
          stavHry: c.stavHry,
          onPressed: c.centerOnUser,
            ),
          ),
          Positioned(
            top: 80,
            left : 15,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
                ],
              ),
              child: LockButton(
                onChanged: (bool jeBodZamknuty) {
                  c.jeBodZamknuty = jeBodZamknuty;
                },
              ),
            ),
          ),
          Positioned(
            top: 150,
            left: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.explore, color: Colors.yellow),
                onPressed: () => c.resetSmeru(),
              ),
            ),
          ),

          if (c.locationError != null) GpsErrorPanel(errorText: c.locationError!, onRetry: c.startLocationTracking),
          Positioned(top: 20, right: 20, child: MapZoomButtons(mapController: c.mapController)),

          // --- OPRAVA TADY: Tlačítko se ukáže POUZE ve stavu 3 (když je otevřená archivní trasa mise) ---
          if (c.stavHry == 3)
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

          if (c.stavHry == 1)
            DraggableScrollableSheet(
              initialChildSize: 0.22,
              minChildSize: 0.22,
              maxChildSize: 0.5,
              snap: true,
              builder: (BuildContext context, ScrollController scrollController) {
                return PanelPresun(
                  bodData: c.mise.trasa[c.aktualniBod - 1],
                  aktualniBod: c.aktualniBod,
                  scrollController: scrollController,
                );
              },
            ),
          if (c.stavHry == 2) 
            PanelDorazil(
              bodData: c.mise.trasa[c.aktualniBod - 1], 
              aktualniBod: c.aktualniBod, 
              onOtevrit: () => DialogManager.ukazPribehPopup(
                context: context, 
                historieBodu: c.mise.trasa.sublist(0, c.aktualniBod), 
                miseData: c.mise, 
                onPokracovat: c.onPribehPokracovat
              )
            ),

          if (c.stavHry == 3) ...[
            DraggableScrollableSheet(
              initialChildSize: 0.35,
              minChildSize: 0.2,
              maxChildSize: 0.6,
              snap: true,
              builder: (BuildContext context, ScrollController scrollController) {
                return ArchivMisePopup(
                  miseData: c.mise, 
                  pocetBodu: c.mise.trasa.length, 
                  scrollController: scrollController,
                  odehranyCas: c.getFormattedTime(),
                  uslaVzdalenost: c.getFormattedDistance(),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}