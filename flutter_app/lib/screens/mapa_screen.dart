import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../widgets/mise_popup.dart';
import '../widgets/point_pop_up.dart';
import '../widgets/app_bar.dart';
import '../widgets/app_bar_play.dart';
import '../data/mise_data.dart';

class MapaScreen extends StatefulWidget {
  const MapaScreen({super.key});

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  int stavHry = 0;
  int aktualniBod = 1;

  void ukazStartPopup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return MisePopup(
          miseData: dataMise,
          onVyrazit: () {
            setState(() {
              stavHry = 1;
            });
          },
        );
      },
    );
  }

  void ukazPribehPopup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return BodPopup(
          bodData: trasaMise[aktualniBod - 1],
          onPokracovat: () {
            setState(() {
              if (aktualniBod < trasaMise.length) {
                aktualniBod++;
                stavHry = 1;
              } else {
                stavHry = 0;
                aktualniBod = 1;
              }
            });
          },
        );
      },
    );
  }

  Marker buildNormalMarker(BodMise point) {
    return Marker(
      point: LatLng(point.lat, point.lon),
      width: 60,
      height: 60,
      child: GestureDetector(
        onTap: () {
          if (stavHry == 0) {
            ukazStartPopup();
          } else if (stavHry == 1) {
            setState(() {
              stavHry = 2;
            });
          }
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              bottom: 4,
              child: Container(
                width: 20,
                height: 10,
                decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(10)),
              ),
            ),
            Transform.rotate(
              angle: 0.785,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFFAED41),
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8,
              child: Text(
                point.id.toString(),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Marker buildBigMarker(BodMise point) {
    return Marker(
      point: LatLng(point.lat, point.lon),
      width: 100,
      height: 100,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFAED41),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: Center(
          child: Text(
            'BOD${point.id}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      ),
    );
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
              if (stavHry > 0)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: trasaMise.sublist(0, aktualniBod).map((p) => LatLng(p.lat, p.lon)).toList(),
                      color: Colors.blueAccent.withOpacity(0.7),
                      strokeWidth: 5.0,
                    ),
                  ],
                ),
              MarkerLayer(
                markers: [
                  if (stavHry == 0) buildNormalMarker(trasaMise.first),
                  if (stavHry == 1) buildNormalMarker(trasaMise[aktualniBod - 1]),
                  if (stavHry == 2) buildBigMarker(trasaMise[aktualniBod - 1]),
                ],
              ),
            ],
          ),
          if (stavHry == 1)
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAF8F0),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(trasaMise[aktualniBod - 1].nazevBodu, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
                          const SizedBox(height: 5),
                          Text('Přesuň se na BOD$aktualniBod.\nOtevře se ti pokračování příběhu.', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black)),
                        ],
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black, width: 1.5)),
                      child: Center(child: Text(aktualniBod.toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                    ),
                  ],
                ),
              ),
            ),
          if (stavHry == 2)
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAED41),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Dorazil jsi na BOD$aktualniBod!', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
                              const SizedBox(height: 5),
                              Text(trasaMise[aktualniBod - 1].podnadpis, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black)),
                            ],
                          ),
                        ),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black, width: 1.5)),
                          child: Center(child: Text(aktualniBod.toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: ukazPribehPopup,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                        decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 1.5), borderRadius: BorderRadius.circular(20)),
                        child: const Text('Otevřít', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}