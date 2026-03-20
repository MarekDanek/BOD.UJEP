import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class RadarLayer extends StatelessWidget {
  final LatLng position;
  final Animation<double> animation;

  const RadarLayer({
    super.key,
    required this.position,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final radius = 20.0 + (animation.value * 6);
        return CircleLayer(
          circles: [
            CircleMarker(
              point: position,
              radius: radius,
              useRadiusInMeter: true,
              color: Colors.blue.withOpacity(0.15),
              borderColor: Colors.blue.withOpacity(0.5),
              borderStrokeWidth: 2,
            ),
          ],
        );
      },
    );
  }
}