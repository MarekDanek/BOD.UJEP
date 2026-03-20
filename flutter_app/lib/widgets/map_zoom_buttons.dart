import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class MapZoomButtons extends StatelessWidget {
  final MapController mapController;

  const MapZoomButtons({
    super.key,
    required this.mapController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Tlačítko PŘIBLÍŽIT (+)
        FloatingActionButton.small(
          heroTag: 'zoomInBtn',
          backgroundColor: const Color(0xFFFAED41),
          onPressed: () {
            final currentZoom = mapController.camera.zoom;
            if (currentZoom < 18.5) {
              mapController.move(mapController.camera.center, currentZoom + 1);
            }
          },
          child: const Icon(Icons.add, color: Colors.black, size: 24),
        ),
        const SizedBox(height: 8),
        // Tlačítko ODDÁLIT (-)
        FloatingActionButton.small(
          heroTag: 'zoomOutBtn',
          backgroundColor: const Color(0xFFFAED41),
          onPressed: () {
            final currentZoom = mapController.camera.zoom;
            if (currentZoom > 13.0) {
              mapController.move(mapController.camera.center, currentZoom - 1);
            }
          },
          child: const Icon(Icons.remove, color: Colors.black, size: 24),
        ),
      ],
    );
  }
}