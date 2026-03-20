import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../data/mise_data.dart';

class MarkerBuilder {
  static Marker buildStartMarker(BodMise point, VoidCallback onTap) {
    return Marker(
      point: LatLng(point.lat, point.lon),
      width: 40,
      height: 40,
      child: GestureDetector(
        onTap: onTap,
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

  static Marker buildNormalMarker(BodMise point, VoidCallback onTap) {
    return Marker(
      point: LatLng(point.lat, point.lon),
      width: 60,
      height: 60,
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

  static Marker buildBigMarker(BodMise point) {
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
}