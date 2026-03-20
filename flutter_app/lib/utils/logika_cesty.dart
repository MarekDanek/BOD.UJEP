import 'dart:convert';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class LogikaCesty {
  // ZMĚNA: Funkce teď bere List<LatLng> místo List<BodMise>
  static Future<List<LatLng>> ziskejTrasuPoChodniku(List<LatLng> body) async {
    if (body.length < 2) return [];

    // ZMĚNA: LatLng používá vlastnosti .longitude a .latitude
    final souradnice = body.map((b) => '${b.longitude},${b.latitude}').join(';');
    final url = 'http://router.project-osrm.org/route/v1/foot/$souradnice?overview=full&geometries=geojson';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List coords = data['routes'][0]['geometry']['coordinates'];

        return coords.map((c) => LatLng(c[1], c[0])).toList();
      }
    } catch (e) {
      return [];
    }

    return [];
  }
}