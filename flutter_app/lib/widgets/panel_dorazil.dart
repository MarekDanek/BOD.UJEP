import 'package:flutter/material.dart';
import '../data/mise_data.dart';

class PanelDorazil extends StatelessWidget {
  final BodMise bodData;
  final int aktualniBod;
  final VoidCallback onOtevrit;

  const PanelDorazil({
    super.key,
    required this.bodData,
    required this.aktualniBod,
    required this.onOtevrit,
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
          color: const Color(0xFFFAED41),
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Dorazil jsi na BOD$aktualniBod!', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
                      const SizedBox(height: 5),
                      Text(bodData.podnadpis, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black)),
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
            const SizedBox(height: 20),
            InkWell(
              onTap: onOtevrit,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 1.5), borderRadius: BorderRadius.circular(20)),
                child: const Text('Otevřít', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}