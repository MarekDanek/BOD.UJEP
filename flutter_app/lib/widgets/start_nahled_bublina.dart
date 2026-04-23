import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class StartNahledBublina extends StatelessWidget {
  final String nazev;
  final String podnadpis;
  final VoidCallback onTap;

  const StartNahledBublina({
    super.key,
    required this.nazev,
    required this.podnadpis,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final zoom = MapCamera.of(context).zoom;

    if (zoom < 12.0) {
      return const SizedBox.shrink();
    }

    final double scale = ((zoom - 12.0) / 4.0).clamp(0.0, 1.0);

    return Transform.scale(
      scale: scale,
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minWidth: 170, maxWidth: 230),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFFAED41),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black, width: 2),
            boxShadow: const [
              BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(nazev, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
              const SizedBox(height: 4),
              Text(
                podnadpis,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              const Text('Otevřít misi', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black)),
            ],
          ),
        ),
      ),
    );

  }
}