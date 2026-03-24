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

  final String? bonusNazev;
  final String? bonusObrazek;
  final String? bonusAudioPath;

  BodMise({
    required this.id,
    required this.nazevBodu,
    required this.podnadpis,
    required this.textCast1,
    required this.obrazekCesta,
    required this.textCast2,
    required this.lat,
    required this.lon,
    this.bonusNazev,
    this.bonusObrazek,
    this.bonusAudioPath,
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
    obrazekCesta: 'assets/BOD4_2.png',
    textCast2: 'Už jsem ho znal. Musel jsem si oběd objednat včera. Žádné překvapení. Žádná záhada.\n\nJen tichá vůně rozvařených těstovin, která se vznášela ve vzduchu jako špatná životní rozhodnutí.\n\nChvíli jsem tam stál.\n\nPak jsem šel dál.',
    lat: 50.6647478,
    lon: 14.0258906,
  ),
  BodMise(
    id: 2,
    nazevBodu: 'Existencionální pauza',
    podnadpis: 'Soundtrack v předjaří',
    textCast1: 'Velké otevřené prostranství mezi budovami.\n\nVítr tam fouká tak, jako by chtěl lidem připomenout, že všechno jednou skončí.\n\nVytáhl jsem telefon.\n\nPustil jsem si jednu starou indie věc. Kytara zněla smutně.',
    obrazekCesta: 'assets/BOD2_1.png',
    textCast2: 'Přesně tak, jak má znít dobrý den.\n\nKampus kolem mě pokračoval ve svém pomalém životě.\n\nJá taky.',
    lat: 50.6650428,
    lon: 14.0257067,

    bonusNazev: 'Tokio Drift — bejby navždy',
    bonusObrazek: 'assets/BOD2_2.png',
    bonusAudioPath: 'assets/audio/music.mp3',
  ),
  BodMise(
    id: 3,
    nazevBodu: 'Bankomat',
    podnadpis: 'Případ mizících peněz',
    textCast1: 'Díval se na mě z výšky.\n\nMoudře.\n\nPřísně.\n\nVytáhl jsem kartu.\n\nBankomat chvíli přemýšlel, jestli si to zasloužím, ale nakonec mi vydal pár bankovek.',
    obrazekCesta: 'assets/BOD3_2.png',
    textCast2: 'Podíval jsem se nahoru na Purkyněho portrét. Napadlo mě, že to celé trochu připomíná výplatní pásku z univerzity.\n\nKrátká. A rychle pryč.',
    lat: 50.6657314,
    lon: 14.0255567,
  ),
  BodMise(
    id: 4,
    nazevBodu: 'Bufet — Malé radosti',
    podnadpis: 'Důležitý je základ...bramborový?',
    textCast1: 'Bufet byl plný světla a skla.\n\nZa vitrínou ležely chlebíčky.\nDokonalé.\nTiché.\nNeodsuzující.',
    obrazekCesta: 'assets/BOD4_2.png',
    textCast2: 'Chvíli jsem na ně jen koukal.\n\nNěkdy člověk nepotřebuje řešit velké věci.\nStačí vědět, že existují chlebíčky.',
    lat: 50.6656114,
    lon: 14.0249397,
  ),
BodMise(
    id: 5,
    nazevBodu: 'FUD — Kouř',
    podnadpis: 'Poslední cigareta?',
    textCast1: 'Došel jsem před Fakulta umění a designu UJEP.\n\nVytáhl jsem cigaretu.\n\nZapálil ji.\n\nPrvní potáhnutí bylo dobré.\n\nDruhé ještě lepší.\n\nKampus šuměl kolem mě. Někde někdo mluvil o projektech, někdo o designu. Vyfoukl jsem kouř do studeného vzduchu.\n\nTeprve teď jsem byl připravený začít pracovat.',
    obrazekCesta: 'assets/BOD5_1.png',
    textCast2: 'Gratulujeme,\ndokončil jsi misi!',
    lat: 50.6659875,
    lon: 14.0246164,
  ),
];

// Testovací bod
final TestBod = BodMise(
  id: 6,
  nazevBodu: 'Testovací-BoD',
  podnadpis: 'TEST',
  textCast1: 'Test',
  obrazekCesta: 'Test',
  textCast2: 'Gratulujeme,\ndokončil jsi misi!',
  lat: 50.690399749967014,
  lon: 14.093647903993505,
);