import 'dart:convert';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'MOJE.dart';

class LogikaCesty {
  static const String apiKey = Moje.orsApiKey;

  static Future<List<LatLng>> ziskejTrasuPoChodniku(List<LatLng> body) async {
    if (body.length < 2) return [];


    const url = 'https://api.openrouteservice.org/v2/directions/foot-walking/geojson';


    final coordinates = body.map((b) => [b.longitude, b.latitude]).toList();

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json, application/geo+json, application/gpx+xml, img/png; charset=utf-8',
          'Authorization': apiKey,
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: json.encode({
          "coordinates": coordinates,
          "elevation": false,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final List coords = data['features'][0]['geometry']['coordinates'];

        return coords.map((c) => LatLng(c[1], c[0])).toList();
      } else {
        print('Chyba ORS API: ${response.statusCode} - ${response.body}');
        return [];
      }
    } catch (e) {
      print('Chyba při volání trasy: $e');
      return [];
    }
  }
}