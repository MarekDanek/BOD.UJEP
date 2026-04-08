import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../data/mise_data.dart';
import 'dokoncena_mise_bublina.dart';


class MarkerBuilder {

  // --- START MARKER ---
  static Marker buildStartMarker(BodMise point, VoidCallback onTap) {
    return Marker(
      point: LatLng(point.lat, point.lon),
      width: 40,
      height: 40,
      rotate: true,
      child: Builder(
        builder: (context) {

          final zoom = MapCamera.of(context).zoom;


          double myScale = ((zoom - 11.0) / 4.0).clamp(0.3, 1.0);

          return GestureDetector(
            onTap: onTap,
            // Aplikujeme zmenšení na celý bod
            child: Transform.scale(
              scale: myScale,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFAED41),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 2),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }

 static Marker buildDokoncenaBublinaMarker(BodMise point, VoidCallback onTap) {
    return Marker(
      point: LatLng(point.lat, point.lon),
      width: 300,
      height: 300,
      alignment: Alignment.center,
      rotate: true,
      child: Builder(
        builder: (context) {
          final zoom = MapCamera.of(context).zoom;

          if (zoom < 12.0) {
            return const SizedBox.shrink();
          }

          double myScale = ((zoom - 12.0) / 4.0).clamp(0.0, 1.0);

          return Transform.scale(
            scale: myScale,
            alignment: Alignment.center,
            child: Align(
              alignment: Alignment.center,
              child: FractionalTranslation(
                translation: const Offset(0, -0.5),
                child: DokoncenaMiseBublina(
                  miseData: dataMise,
                  pocetBodu: trasaMise.length,
                  onTap: onTap,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // --- MALÝ BOD (NEZJISTĚNÝ/HISTORIE) ---
  static Marker buildSmallDotMarker(BodMise bod) {
    return Marker(
      point: LatLng(bod.lat, bod.lon),
      width: 16,
      height: 16,
      rotate: true,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFAED41),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black, width: 2),
        ),
      ),
    );
  }

  // --- NORMÁLNÍ BĚŽNÝ BOD ---
  static Marker buildNormalMarker(BodMise point, VoidCallback onTap,{required bool jeBlizko}) {
    final Color barva = jeBlizko ? const Color(0xFF34C759) : const Color(0xFFFAED41);
    return Marker(
      point: LatLng(point.lat, point.lon),
      width: 60,
      height: 60,
      rotate: true,
      child: GestureDetector(
        onTap: onTap,
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
              angle: 0.771,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: barva,
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
              top: 18,
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

  // --- UŽIVATELSKÝ MARKER (LOKACE) ---
  static Marker buildUserMarker(LatLng point) {
    return Marker(
      point: point,
      width: 24,
      height: 24,
      rotate: true,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
        ),
      ),
    );
  }

  // --- VELKÝ AKTIVNÍ BOD (KTERÝ ZROVNA HRÁČ HLEDÁ) ---
  static Marker buildBigMarker(BodMise point) {
    return Marker(
      point: LatLng(point.lat, point.lon),
      width: 100,
      height: 100,
      rotate: true,
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

  // --- KULATÝ BOD (PROŠLÁ TRASA BĚHEM HRANÍ) ---
  static Marker buildPassedPointCircleMarker(BodMise bod) {
    return Marker(
      point: LatLng(bod.lat, bod.lon),
      width: 20.0,
      height: 20.0,
      alignment: Alignment.center,
      rotate: true,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFAED41),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black, width: 1.5),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 3,
              offset: Offset(0, 2),
            ),
          ],
        ),
      ),
    );
  }

  // --- KULATÝ BOD PRO ARCHIV S MOŽNOSTÍ KLIKNUTÍ ---
  static Marker buildPassedPointCircleMarkerWithOnTap(BodMise bod, VoidCallback onTap) {
    return Marker(
      point: LatLng(bod.lat, bod.lon),
      width: 40.0,
      height: 40.0,
      alignment: Alignment.center,
      rotate: true,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: Container(
            width: 20.0,
            height: 20.0,
            decoration: BoxDecoration(
              color: const Color(0xFFFAED41),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 1.5),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}