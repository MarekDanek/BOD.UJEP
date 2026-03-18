import 'package:flutter/material.dart';
import '../data/mise_data.dart';

class BodPopup extends StatelessWidget {
  final BodMise bodData;
  final VoidCallback onPokracovat;

  const BodPopup({
    super.key,
    required this.bodData,
    required this.onPokracovat,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFAED41),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Center(
              child: Container(
                width: 40,
                height: 3,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    bodData.nazevBodu,
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w500, color: Colors.black, letterSpacing: -0.5),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 1.5),
                    ),
                    child: Center(
                      child: Text(
                        bodData.id.toString(),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                bodData.podnadpis,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                bodData.textCast1,
                style: const TextStyle(fontSize: 15, height: 1.2, color: Colors.black),
              ),
            ),
            const SizedBox(height: 20),
            Image.asset(
              bodData.obrazekCesta,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity, height: 200, color: Colors.black12,
                  child: const Center(child: Icon(Icons.image, size: 50, color: Colors.black54)),
                );
              },
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                bodData.textCast2,
                style: const TextStyle(fontSize: 15, height: 1.2, color: Colors.black),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  onPokracovat();
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 1.5), borderRadius: BorderRadius.circular(20)),
                  child: const Text('Pokračovat', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black)),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}