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
        final radius =  10+ (animation.value );
        return CircleLayer(
          circles: [
            CircleMarker(
              point: position,
              radius: radius,
              useRadiusInMeter: true,
              color: const Color(0x1A2196F3),
              borderColor: const Color(0x802196F3),
              borderStrokeWidth: 2,
            ),
          ],
        );
      },
    );
  }
}