import 'package:flutter/material.dart';

class ProfilObrazek {
  final String id;
  final String assetPath;
  final Color placeholderBarva;
  final IconData placeholderIkona;

  const ProfilObrazek({
    required this.id,
    required this.assetPath,
    required this.placeholderBarva,
    required this.placeholderIkona,
  });
}

/// Předpřipravená nabídka profilových obrázků.
/// Až dodáš soubory, ulož je do assets/profil/ pod stejnými názvy.
const List<ProfilObrazek> profiloveObrazky = [
  ProfilObrazek(
    id: 'avatar_1',
    assetPath: 'assets/profil/avatar_1.png',
    placeholderBarva: Color(0xFFFAED41),
    placeholderIkona: Icons.face,
  ),
  ProfilObrazek(
    id: 'avatar_2',
    assetPath: 'assets/profil/avatar_2.png',
    placeholderBarva: Color(0xFFAEFFA4),
    placeholderIkona: Icons.face_3,
  ),
  ProfilObrazek(
    id: 'avatar_3',
    assetPath: 'assets/profil/avatar_3.png',
    placeholderBarva: Color(0xFFFCFCE4),
    placeholderIkona: Icons.face_4,
  ),
  ProfilObrazek(
    id: 'avatar_4',
    assetPath: 'assets/profil/avatar_4.png',
    placeholderBarva: Color(0xFFB8E8FF),
    placeholderIkona: Icons.face_6,
  ),
  ProfilObrazek(
    id: 'avatar_5',
    assetPath: 'assets/profil/avatar_5.png',
    placeholderBarva: Color(0xFFFFB8D9),
    placeholderIkona: Icons.sentiment_satisfied_alt,
  ),
];

ProfilObrazek? najdiProfilObrazek(String? id) {
  if (id == null) return null;
  for (final obrazek in profiloveObrazky) {
    if (obrazek.id == id) return obrazek;
  }
  return null;
}

Widget buildProfilObrazek({
  required String? idObrazku,
  required double velikost,
  bool jeVybrany = false,
}) {
  final obrazek = najdiProfilObrazek(idObrazku);
  final borderWidth = jeVybrany ? 3.0 : 2.0;

  if (obrazek == null) {
    return Container(
      width: velikost,
      height: velikost,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black, width: borderWidth),
      ),
      child: Icon(Icons.person, size: velikost * 0.55, color: Colors.black54),
    );
  }

  return Container(
    width: velikost,
    height: velikost,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(
        color: jeVybrany ? Colors.black : Colors.black54,
        width: borderWidth,
      ),
    ),
    child: ClipOval(
      child: Image.asset(
        obrazek.assetPath,
        width: velikost,
        height: velikost,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return Container(
            color: obrazek.placeholderBarva,
            child: Icon(
              obrazek.placeholderIkona,
              size: velikost * 0.55,
              color: Colors.black87,
            ),
          );
        },
      ),
    ),
  );
}
