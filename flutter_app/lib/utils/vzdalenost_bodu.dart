import 'package:geolocator/geolocator.dart';

import '../data/mise_data.dart';

class VzdalenostBodu {
  static double spocitejVzdalenostMetry({
    required double userLat,
    required double userLon,
    required BodMise cilovyBod,
  }) {
    return Geolocator.distanceBetween(
      userLat,
      userLon,
      cilovyBod.lat,
      cilovyBod.lon,
    );
  }

  static bool jeUBodu({
    required double userLat,
    required double userLon,
    required BodMise cilovyBod,
    double perimetrMetry = 20,
  }) {
    final distanceMeters = spocitejVzdalenostMetry(
      userLat: userLat,
      userLon: userLon,
      cilovyBod: cilovyBod,
    );

    return distanceMeters <= perimetrMetry;
  }
}