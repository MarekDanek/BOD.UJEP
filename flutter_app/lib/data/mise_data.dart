import 'package:cloud_firestore/cloud_firestore.dart';

class Mise {
  final String idMise; 
  final String nazev;
  final String podnadpis;
  final String textCast1;
  final String obrazekCesta;
  final String textCast2;
  final String pocetBodu;
  final String vzdalenost;
  final String obtiznost;
  final String cas;
  final String bonusy;
  final String typ;
  final double startLat;
  final double startLon;
  final List<BodMise> trasa;

  // --- NOVÁ POLE PRO ZÁVĚR MISE ---
  final String zaverecnyNadpis;
  final String zaverecnyText;
  final String zaverecnyObrazek;
  final String zaverecnaHudba;

  Mise({
    this.idMise = '',
    required this.nazev,
    required this.podnadpis,
    required this.textCast1,
    required this.obrazekCesta,
    required this.textCast2,
    required this.pocetBodu,
    required this.vzdalenost,
    required this.obtiznost,
    required this.cas,
    required this.bonusy,
    required this.typ,
    required this.startLat,
    required this.startLon,
    required this.trasa,
    required this.zaverecnyNadpis,
    required this.zaverecnyText,
    required this.zaverecnyObrazek,
    required this.zaverecnaHudba,
  });

  // TOVÁRNÍ METODA: Vyrobí Misi z dat stažených z Firebase
  factory Mise.fromJson(Map<String, dynamic> json, String docId, List<BodMise> nactenaTrasa) {
    return Mise(
      idMise: docId,
      nazev: json['nazev']?.toString() ?? '',
      podnadpis: json['podnadpis']?.toString() ?? '',
      textCast1: json['textCast1']?.toString() ?? '',
      obrazekCesta: json['obrazekCesta']?.toString() ?? '',
      textCast2: json['textCast2']?.toString() ?? '',
      pocetBodu: json['pocetBodu']?.toString() ?? '',
      vzdalenost: json['vzdalenost']?.toString() ?? '',
      obtiznost: json['obtiznost']?.toString() ?? '',
      cas: json['cas']?.toString() ?? '',
      bonusy: json['bonusy']?.toString() ?? '',
      typ: json['typ']?.toString() ?? '',
      startLat: json['startLat'] != null ? (json['startLat'] as num).toDouble() : 50.6647478,
      startLon: json['startLon'] != null ? (json['startLon'] as num).toDouble() : 14.0258906,
      trasa: nactenaTrasa,
      
      // Bezpečné načtení nových polí s výchozími hodnotami pro staré mise
      zaverecnyNadpis: json['zaverecnyNadpis']?.toString() ?? 'Mise splněna!',
      zaverecnyText: json['zaverecnyText']?.toString() ?? 'Skvělá práce! Prošel jsi celou trasu.',
      zaverecnyObrazek: json['zaverecnyObrazek']?.toString() ?? 'assets/placeholder_bod.png',
      zaverecnaHudba: json['zaverecnaHudba']?.toString() ?? '',
    );
  }
}

class BonusovaStranka {
  final String? obrazek;
  final String? podnadpis;
  final String text;
  final String? malyText;
  final bool? zaoblitObrazek;

  BonusovaStranka({
    this.obrazek,
    this.podnadpis,
    required this.text,
    this.malyText,
    this.zaoblitObrazek,
  });

  factory BonusovaStranka.fromJson(Map<String, dynamic> json) {
    return BonusovaStranka(
      obrazek: json['obrazek']?.toString(),
      podnadpis: json['podnadpis']?.toString(),
      text: json['text']?.toString() ?? '',
      malyText: json['malyText']?.toString(),
      zaoblitObrazek: json['zaoblitObrazek'] as bool?,
    );
  }
}

class ObrazekMise {
  final String? obrazek;

  ObrazekMise({
    this.obrazek,
  });

  factory ObrazekMise.fromJson(Map<String, dynamic> json) {
    return ObrazekMise(obrazek: json['obrazek']?.toString());
  }
}

class BodMise {
  final int id;
  final String nazevBodu;
  final String tipNaCestu;
  final String podnadpis;
  final String textCast1;
  final String obrazekCesta;
  final String textCast2;
  final double lat;
  final double lon;

  final String? bonusAudioPath;
  final List<BonusovaStranka>? bonusoveStranky;
  final List<ObrazekMise>? obrazkyMise;

  BodMise({
    required this.id,
    required this.nazevBodu,
    required this.tipNaCestu,
    required this.podnadpis,
    required this.textCast1,
    required this.obrazekCesta,
    required this.textCast2,
    required this.lat,
    required this.lon,
    this.bonusAudioPath,
    this.bonusoveStranky,
    this.obrazkyMise,
  });

  factory BodMise.fromJson(Map<String, dynamic> json) {
    return BodMise(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      nazevBodu: json['nazevBodu']?.toString() ?? '',
      tipNaCestu: json['tipNaCestu']?.toString() ?? '',
      podnadpis: json['podnadpis']?.toString() ?? '',
      textCast1: json['textCast1']?.toString() ?? '',
      obrazekCesta: json['obrazekCesta']?.toString() ?? '',
      textCast2: json['textCast2']?.toString() ?? '',
      lat: json['lat'] != null ? (json['lat'] as num).toDouble() : 0.0,
      lon: json['lon'] != null ? (json['lon'] as num).toDouble() : 0.0,
      bonusAudioPath: json['bonusAudioPath']?.toString() == "" ? null : json['bonusAudioPath']?.toString(),
      bonusoveStranky: json['bonusoveStranky'] != null
          ? (json['bonusoveStranky'] as List<dynamic>).map((e) => BonusovaStranka.fromJson(Map<String, dynamic>.from(e))).toList()
          : null,
      obrazkyMise: json['obrazkyMise'] != null
          ? (json['obrazkyMise'] as List<dynamic>).map((e) => ObrazekMise.fromJson(Map<String, dynamic>.from(e))).toList()
          : null,
    );
  }
}

class ZiskanyBonus {
  final BonusovaStranka stranka;
  final String? audioPath;

  ZiskanyBonus(this.stranka, this.audioPath);
}

// -------------------------------------------------------------
List<Mise> vsechnyMise = [];

Future<void> nactiMiseZFirebase() async {
  try {
    final querySnapshot = await FirebaseFirestore.instance.collection('mise').get();
    List<Mise> nacteneMise = [];

    for (var doc in querySnapshot.docs) {
      final data = doc.data();
      final bodySnapshot = await doc.reference.collection('body').get();
      
      List<BodMise> trasa = bodySnapshot.docs.map((bodDoc) {
        return BodMise.fromJson(bodDoc.data());
      }).toList();

      trasa.sort((a, b) => a.id.compareTo(b.id));
      nacteneMise.add(Mise.fromJson(data, doc.id, trasa));
    }

    vsechnyMise = nacteneMise;
    print('ÚSPĚCH: Načteno ${vsechnyMise.length} misí z Firebase!');
  } catch (e) {
    print("CHYBA PŘI NAČÍTÁNÍ Z FIREBASE: $e");
  }
}