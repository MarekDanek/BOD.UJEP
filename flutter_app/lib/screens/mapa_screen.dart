import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../utils/logika_cesty.dart';
import '../utils/dialog_manager.dart';
import '../widgets/app_bar.dart';
import '../widgets/app_bar_play.dart';
import '../widgets/mapa_markers.dart';
import '../widgets/panel_presun.dart';
import '../widgets/panel_dorazil.dart';
import '../data/mise_data.dart';

class MapaScreen extends StatefulWidget {
  const MapaScreen({super.key});

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  int stavHry = 0;
  int aktualniBod = 1;
  List<LatLng> trasaPoChodniku = [];

  Future<void> vypocitejTrasu() async {
    if (aktualniBod < 2) return;

    final bodyKPropojeni = trasaMise.sublist(0, aktualniBod);
    final novaTrasa = await LogikaCesty.ziskejTrasuPoChodniku(bodyKPropojeni);

    setState(() {
      trasaPoChodniku = novaTrasa;
    });
  }

  void onStartVyrazit() {
    setState(() {
      stavHry = 1;
      trasaPoChodniku.clear();
    });
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
      DialogManager.ukazStartPopup(
        context: context,
        miseData: dataMise,
        onVyrazit: onStartVyrazit,
      );
    } else if (stavHry == 1) {
      setState(() {
        stavHry = 2;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: stavHry == 0
          ? MyAppBar(
              levaIkona: Icons.menu,
              naLevaIkonaKlik: () => Navigator.pop(context),
            )
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
      body: Stack(
        children: [
          FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(50.6653, 14.0255),
              initialZoom: 16.5,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'cz.ujep.bod',
              ),
              if (stavHry > 0 && trasaPoChodniku.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: trasaPoChodniku,
                      color: Colors.blueAccent.withOpacity(0.7),
                      strokeWidth: 5.0,
                    ),
                  ],
                ),
              MarkerLayer(
                markers: [
                  if (stavHry == 0) MarkerBuilder.buildStartMarker(trasaMise.first, onMarkerTap),
                  if (stavHry == 1) MarkerBuilder.buildNormalMarker(trasaMise[aktualniBod - 1], onMarkerTap),
                  if (stavHry == 2) MarkerBuilder.buildBigMarker(trasaMise[aktualniBod - 1]),
                ],
              ),
            ],
          ),
          if (stavHry == 1)
            PanelPresun(
              bodData: trasaMise[aktualniBod - 1],
              aktualniBod: aktualniBod,
            ),
          if (stavHry == 2)
            PanelDorazil(
              bodData: trasaMise[aktualniBod - 1],
              aktualniBod: aktualniBod,
              onOtevrit: () => DialogManager.ukazPribehPopup(
                context: context,
                bodData: trasaMise[aktualniBod - 1],
                miseData: dataMise,
                onPokracovat: onPribehPokracovat,
              ),
            ),
        ],
      ),
    );
  }
}