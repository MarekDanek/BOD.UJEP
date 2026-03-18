class Mise {
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

  Mise({
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
  });
}

class BodMise {
  final int id;
  final String nazevBodu;
  final String podnadpis;
  final String textCast1;
  final String obrazekCesta;
  final String textCast2;
  final double lat;
  final double lon;

  BodMise({
    required this.id,
    required this.nazevBodu,
    required this.podnadpis,
    required this.textCast1,
    required this.obrazekCesta,
    required this.textCast2,
    required this.lat,
    required this.lon,
  });
}

final dataMise = Mise(
  nazev: 'Mise Kuneš',
  podnadpis: 'Noir příběh z kampusu',
  textCast1: 'Jmenuju se Petr Kuneš. Říkají o mně různé věci. Že vyprávím vtipy na potkání. Že poslouchám indie kapely, které znají jen tři lidi a pes zvukaře. Že kouřím víc, než je zdravé.',
  obrazekCesta: 'assets/MiseKunes_1.png',
  textCast2: 'Možná mají pravdu.\n\nTen den začal jako každý jiný, když jsem dorazil do kampusu UJEP. Než jsem vstoupil do labyrintu z krabic, čuměl jsem chvíli na páru valící se z komínů chemičky. Skvělý.\n\nMěl jsem před sebou jen jeden úkol. Dojít do práce.',
  pocetBodu: '5 bodů',
  vzdalenost: '800 m',
  obtiznost: 'Nízká',
  cas: '20 min',
  bonusy: '4 bonusy',
  typ: 'Zvuk',
);

final List<BodMise> trasaMise = [
  BodMise(
    id: 1,
    nazevBodu: 'Menza',
    podnadpis: 'Případ předem ztraceného překvapení',
    textCast1: 'Vešel jsem do menzy.\n\nPodíval jsem se na menu.',
    obrazekCesta: 'assets/MiseKunes_1.png',
    textCast2: 'Už jsem ho znal. Musel jsem si oběd objednat včera. Žádné překvapení. Žádná záhada.\n\nJen tichá vůně rozvařených těstovin, která se vznášela ve vzduchu jako špatná životní rozhodnutí.\n\nChvíli jsem tam stál.\n\nPak jsem šel dál.',
    lat: 50.6647478,
    lon: 14.0258906,
  ),
  BodMise(
    id: 2,
    nazevBodu: 'Záhada na Prostranství',
    podnadpis: 'V labyrintu kampusu',
    textCast1: 'Petr dorazil na Prostranství. Bylo to jiné než si pamatoval. Vzduch byl těžký a něco nebylo v pořádku.',
    obrazekCesta: 'assets/image_fallback.png',
    textCast2: 'Zastavil se a rozhlédl. Byly tam stopy. Cizí stopy.',
    lat: 50.6650428,
    lon: 14.0257067,
  ),
  BodMise(
    id: 3,
    nazevBodu: 'Bankovní stopa',
    podnadpis: 'Hledání odpovědí',
    textCast1: 'Cesta vedla k bankomatu. Petr si vzpomněl na staré schůzky.',
    obrazekCesta: 'assets/image_fallback.png',
    textCast2: 'Zde se něco dozví.',
    lat: 50.6657314,
    lon: 14.0255567,
  ),
  BodMise(
    id: 4,
    nazevBodu: 'Zastávka u Epultika',
    podnadpis: 'Oddech v chaosu',
    textCast1: 'Bufet. Petr potřeboval kafe a ticho.',
    obrazekCesta: 'assets/image_fallback.png',
    textCast2: 'Ale ticho nebylo.',
    lat: 50.6656114,
    lon: 14.0249397,
  ),
  BodMise(
    id: 5,
    nazevBodu: 'Finále na FUDu',
    podnadpis: 'Odhalení pravdy',
    textCast1: 'Konečně na FUDu. Labyrint končí.',
    obrazekCesta: 'assets/image_fallback.png',
    textCast2: 'Teď už to ví.',
    lat: 50.6659875,
    lon: 14.0246164,
  ),
];