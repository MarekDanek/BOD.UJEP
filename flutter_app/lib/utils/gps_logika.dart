import 'package:geolocator/geolocator.dart';

class GpsLogika {
  static Future<void> checkPermissions() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Služby určování polohy jsou vypnuté.');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw Exception('Oprávnění k poloze bylo zamítnuto.');
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Oprávnění k poloze je trvale zamítnuté (povol v nastavení).');
    }
  }

  static Future<Position> getInitialPosition() async {
    await checkPermissions();

    // ZÁCHRANA 1: Zkusíme vzít poslední známou polohu z paměti (tohle nikdy nezamrzne)
    Position? lastKnown = await Geolocator.getLastKnownPosition();
    if (lastKnown != null) {
      return lastKnown;
    }

    // ZÁCHRANA 2: Pokud hledáme novou polohu, dáme mu limit 10 vteřin.
    // Jinak by emulátor mohl hledat do nekonečna a zabít aplikaci (Signal 3).
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 10),
    );
  }

  static Stream<Position> getPositionStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    );
  }
}