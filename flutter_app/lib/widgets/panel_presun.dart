import 'package:flutter/material.dart';
import '../data/mise_data.dart';

class PanelPresun extends StatelessWidget {
  final BodMise bodData;
  final int aktualniBod;

  const PanelPresun({
    super.key,
    required this.bodData,
    required this.aktualniBod,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 40,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFFAF8F0),
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(bodData.nazevBodu, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
                  const SizedBox(height: 5),
                  Text('Přesuň se na BOD$aktualniBod.\nOtevře se ti pokračování příběhu.', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black)),
                ],
              ),
            ),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black, width: 1.5)),
              child: Center(child: Text(aktualniBod.toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            ),
          ],
        ),
      ),
    );
  }
}