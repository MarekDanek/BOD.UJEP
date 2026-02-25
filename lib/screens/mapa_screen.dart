import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../widgets/point_popup.dart';

class MapaScreen extends StatelessWidget {
  const MapaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BOD. UJEP - Mapa'),
        backgroundColor: Colors.amber,
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: const LatLng(50.6607, 14.0322),
          initialZoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'cz.ujep.bod',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: const LatLng(50.6650, 14.0322),
                width: 50,
                height: 50,
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true, // Povolí oknu roztáhnout se do výšky
                      backgroundColor: Colors.transparent, // Průhledné pozadí za zaoblenými rohy okna
                      builder: (context) {
                        return const PointPopup(); // Načte design okna z druhého souboru
                      },
                    );
                  },
                  child: const Icon(Icons.location_on, color: Colors.red, size: 40),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}