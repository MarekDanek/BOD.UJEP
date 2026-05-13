import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../data/mise_data.dart'; 
import 'dokoncena_mise_bublina.dart';
import 'dart:math' as math;

class MarkerBuilder {

  // --- START MARKER ---
  static Marker buildStartMarker(Mise mise, VoidCallback onTap) {
    return Marker(
      point: LatLng(mise.startLat, mise.startLon), // UPRAVENO NA DYNAMICKÉ SOUŘADNICE MISE
      width: 40,
      height: 40,
      rotate: true,
      child: Builder(
        builder: (context) {
          final zoom = MapCamera.of(context).zoom;
          double myScale = ((zoom - 11.0) / 4.0).clamp(0.3, 1.0);

          return GestureDetector(
            onTap: onTap,
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

  // --- DOKONČENÁ MISE BUBLINA ---
  static Marker buildDokoncenaBublinaMarker(Mise mise, VoidCallback onTap) {
    return Marker(
      point: LatLng(mise.startLat, mise.startLon), // UPRAVENO NA DYNAMICKÉ SOUŘADNICE MISE
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
                  miseData: mise, 
                  pocetBodu: mise.trasa.length,
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

  // --- UŽIVATELSKÝ MARKER (PLYNULÁ ŠIPKA) ---
  static Marker buildUserMarker(LatLng point, double heading) {
    final double rotationRadians = heading * (math.pi / 180);

    return Marker(
      point: point,
      width: 45,
      height: 45,
      rotate: false, 
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: rotationRadians),
        duration: const Duration(milliseconds: 300), 
        curve: Curves.decelerate,
        builder: (context, value, child) {
          return Transform.rotate(
            angle: value,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withValues(alpha: 0.5),
                        blurRadius: 10,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.navigation,
                  size: 35,
                  color: Colors.blue,
                ),
                const Icon(
                  Icons.navigation_outlined,
                  size: 35,
                  color: Colors.white,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- VELKÝ AKTIVNÍ BOD ---
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

  // --- KULATÝ BOD ---
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

  // --- KULATÝ BOD S ONTAP ---
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