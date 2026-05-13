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
  final double startLat;
  final double startLon;
  final List<BodMise> trasa;

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
    required this.startLat,
    required this.startLon,
    required this.trasa,
  });
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
}

class ObrazekMise {
  final String? obrazek;

  ObrazekMise({
    this.obrazek,
  });
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
}

class ZiskanyBonus {
  final BonusovaStranka stranka;
  final String? audioPath;

  ZiskanyBonus(this.stranka, this.audioPath);
}

final List<Mise> vsechnyMise = [
  // --- MISE 1: KUNEŠ ---
  Mise(
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
    startLat: 50.6647478,
    startLon: 14.0258906,
    trasa: [
      BodMise(
        id: 1,
        nazevBodu: 'Menza',
        tipNaCestu: 'Drž se hlavní cesty kolem budov a sleduj značení kampusu.',
        podnadpis: 'Případ předem ztraceného překvapení',
        textCast1: 'Vešel jsem do menzy.\n\nPodíval jsem se na menu.',
        obrazekCesta: 'assets/BOD4_2.png',
        textCast2: 'Už jsem ho znal. Musel jsem si oběd objednat včera. Žádné překvapení. Žádná záhada.\n\nJen tichá vůně rozvařených těstovin, která se vznášela ve vzduchu jako špatná životní rozhodnutí.\n\nChvíli jsem tam stál.\n\nPak jsem šel dál.',
        lat: 50.6647478,
        lon: 14.0258906,
        obrazkyMise: [
            ObrazekMise(obrazek: 'assets/BOD4_2.png'),
            ObrazekMise(obrazek: 'assets/BOD4_2.png'),
        ]
      ),
      BodMise(
        id: 2,
        nazevBodu: 'Existencionální pauza',
        tipNaCestu: 'Projdi otevřeným prostorem mezi budovami a držte směr podle mapy.',
        podnadpis: 'Soundtrack v předjaří',
        textCast1: 'Velké otevřené prostranství mezi budovami.\n\nVítr tam fouká tak, jako by chtěl lidem připomenout, že všechno jednou skončí.\n\nVytáhl jsem telefon.\n\nPustil jsem si jednu starou indie věc. Kytara zněla smutně.',
        obrazekCesta: 'assets/BOD2_1.png',
        textCast2: 'Přesně tak, jak má znít dobrý den.\n\nKampus kolem mě pokračoval ve svém pomalém životě.\n\nJá taky.',
        lat: 50.6650428,
        lon: 14.0257067,
        bonusAudioPath: 'assets/audio/music.mp3',
        bonusoveStranky: [
          BonusovaStranka(
            podnadpis: 'Bonus',
            obrazek: 'assets/BOD2_2.png',
            text: 'Tokio Drift — bejby navždy.',
            malyText: 'Skladbu můžeš poslouchat\nna cestě k dalšímu bodu',
            zaoblitObrazek: true,
          )
        ],
      ),
      BodMise(
        id: 3,
        nazevBodu: 'Bankomat',
        tipNaCestu: 'Pokračuj po chodníku smeěem k vyšši budově a drž se hlavní trasy.',
        podnadpis: 'Případ mizících peněz',
        textCast1: 'Díval se na mě z výšky.\n\nMoudře.\n\nPřísně.\n\nVytáhl jsem kartu.\n\nBankomat chvíli přemýšlel, jestli si to zasloužím, ale nakonec mi vydal pár bankovek.',
        obrazekCesta: 'assets/BOD3_2.png',
        textCast2: 'Podíval jsem se nahoru na Purkyněho portrét. Napadlo mě, že to celé trochu připomíná výplatní pásku z univerzity.\n\nKrátká. A rychle pryč.',
        lat: 50.6657314,
        lon: 14.0255567,
        bonusoveStranky: [
          BonusovaStranka(
            obrazek: 'assets/BOD3_vtip_1.png',
            podnadpis: 'Petrovi se vybaví vtip.',
            text: 'Co dělá chorvatský zvěrolékař v důchodu?',
          ),
          BonusovaStranka(
            obrazek: 'assets/BOD3_vtip_2.png',
            text: 'Utrácí kuny.',
          ),
        ],
      ),
      BodMise(
        id: 4,
        nazevBodu: 'Bufet — Malé radosti',
        tipNaCestu: 'Udržuj tempo a pokračuj ke skleněné casti budovy s občerstvením.',
        podnadpis: 'Důležitý je základ...bramborový?',
        textCast1: 'Bufet byl plný světla a skla.\n\nZa vitrínou ležely chlebíčky.\nDokonalé.\nTiché.\nNeodsuzující.',
        obrazekCesta: 'assets/BOD4_2.png',
        textCast2: 'Chvíli jsem na ně jen koukal.\n\nNěkdy člověk nepotřebuje řešit velké věci.\nStačí vědět, že existují chlebíčky.',
        lat: 50.6656114,
        lon: 14.0249397,
        bonusoveStranky: [
          BonusovaStranka(
            podnadpis: 'Dostal jsi za odměnu:',
            obrazek: 'assets/BOD4_chlebicek.png',
            text: 'Chlebíček s debrecínkou!',
            malyText: 'Ale jsi vegetarián,\ntak jsi ho musel jít vyměnit\nza chlebíček s pórkem.',
          ),
        ],
      ),
      BodMise(
        id: 5,
        nazevBodu: 'FUD — Kouř',
        tipNaCestu: 'Poslední úsek vede kolem budov FUD, drž se chodníku až k cíli.',
        podnadpis: 'Poslední cigareta?',
        textCast1: 'Došel jsem před Fakulta umění a designu UJEP.\n\nVytáhl jsem cigaretu.\n\nZapálil ji.\n\nPrvní potáhnutí bylo dobré.\n\nDruhé ještě lepší.\n\nKampus šuměl kolem mě. Někde někdo mluvil o projektech, někdo o designu. Vyfoukl jsem kouř do studeného vzduchu.\n\nTeprve teď jsem byl připravený začít pracovat.',
        obrazekCesta: 'assets/BOD5_1.png',
        textCast2: 'Gratulujeme,\ndokončil jsi misi!',
        lat: 50.6659875,
        lon: 14.0246164,
        bonusoveStranky: [
          BonusovaStranka(
            obrazek: 'assets/BOD5_cigareta.png',
            podnadpis: 'Bonus',
            text: 'Cigareta s Mílou',
            malyText: 'Přišel kamarád Míla a Petr s ním dává \nvzápěťáka. Život nikdy nebyl krásnější.',
          ),
        ],
      ),
    ],
  ),
  
  // --- MISE 2: KOFINA ---
  Mise(
    nazev: 'Mise S Kofinou na kafe',
    podnadpis: 'Kočičí den v Ústí',
    textCast1: 'Jmenuju se Kofina a je mi osm, což je v kočičích letech něco mezi „zkušená dáma“ a „začneš syčet na děti bez důvodu“.',
    obrazekCesta: 'assets/Kofina_uvod.png', 
    textCast2: 'Mám lesklou černou srst, žluté oči a potřebuji dvě věci: klid a dobrý kafe. Rozhodla jsem se jít ven protáhnout si svoje ladný tělo.',
    pocetBodu: '7 bodů',
    vzdalenost: '1.2 km',
    obtiznost: 'Nízká',
    cas: '45 min',
    bonusy: '0 bonusů',
    typ: 'Příběh',
    startLat: 50.6680000, 
    startLon: 14.0170000,
    trasa: [
      BodMise(
        id: 1,
        nazevBodu: 'Vrchlického sady — Hřiště',
        tipNaCestu: 'Vem to tryskem pryč od hřiště směrem na východ mezi domy.',
        podnadpis: 'Trauma z dětství',
        textCast1: 'Vyjdu z domu a rovnou narazím na běhající, vřeštící a ulepené děti. U zmrzlinovýho stánku se tvoří fronta na barevný ledový cukr. Jeden malý člověk právě upustil zmrzlinu a spustil zvuk podobný skřekům papoušků Ara. Ach ne…',
        obrazekCesta: 'assets/Kofina_bod1.png', 
        textCast2: 'Vybavují se mi vzpomínky na předchozí majitele. Převlékání do oblečků od dětských členů rodiny nebylo výjimkou ..brr. Coffee jako čajová konvice, Coffee jako Johanka z Arku, Coffee jako kukuřice, Coffee jako Dinosaurus Rex. Rychle pryč. Musím běžet.',
        lat: 50.6677511,
        lon: 14.0175233,
      ),
      BodMise(
        id: 2,
        nazevBodu: 'Mezi domy — Kamarádka Garda',
        tipNaCestu: 'Proklouzni skrz zástavbu na jihovýchod k tenisovým kurtům.',
        podnadpis: 'Drbárna u muškátů',
        textCast1: 'Německá zástavba mezi domy vypadá, jako kdyby někdo chtěl postavit ideální život a pak ho nechal trochu zestárnout. Zeleň vybízí k průzkumnictví. Mám tu kamarádku Gardu, je bílá a celý dny sedí v okně mezi fialovými muškáty. Nehne se ani o píď a je trochu obtloustlá. Jakpak by ne, když celý den jen kouří a čumí z okna, ale ví všechno.',
        obrazekCesta: 'assets/Kofina_bod2.png',
        textCast2: '„Tak co novýho?“ ptám se.\n„Henrieta rozsekala Arnolda.“\n„Toho psa?“\n„Jo. Sral lidem před dveře.“\nTak prej Henrieta dala do držky otravnému psímu smetákovi Arnoldovi. A Henrieta není žádný párátko, za mlada byla boss party kočičích Britek z Krásňáku. Když Garda viděla Arnolda ten večer, ještě pořád mu z nosu tekla krev.',
        lat: 50.6672822,
        lon: 14.0198892,
      ),
      BodMise(
        id: 3,
        nazevBodu: 'Venkovní tenisové hřiště',
        tipNaCestu: 'Následuj vůni kávy dál do kampusu.',
        podnadpis: 'Konec civilizace',
        textCast1: 'Tohle místo vypadá jako konec civilizace – opuštěné a spustlé antukové hřiště. Síť zmizela, antuka potrhaná a starý tenisový míček přišel o svou svítící žlutou barvu a chuť žít. Škumpy, maliny, suchopýr.',
        obrazekCesta: 'assets/Kofina_bod3.png',
        textCast2: 'Co je to tam vzadu. Křoví se pohne, že by Hugo nebo Edward? Ale ne, dva zající vyběhli jako idioti. Chyť mne, křičí jeden. To určitě. Mám svou důstojnost, než se honit za nějakým hormonálně zmateným prcajícem. Slyším hlasy a něco tu voní.',
        lat: 50.6666225,
        lon: 14.0214717,
      ),
      BodMise(
        id: 4,
        nazevBodu: 'Pajda Bar — Kampus',
        tipNaCestu: 'S plným břichem kávy se vydej na jihozápad k vlnitým domům.',
        podnadpis: 'Terapie a Cold Brew',
        textCast1: 'Příjemní mladí lidé plní kofeinu, ambicí a nápadů, jak zlepšit svět. To jsou studenti. Ráda sem chodím, zvláště ti s dlouhými vlasy mají super mega nehty, které strašně dobře škrábou. Zvednu hřbet a trochu se přivrním, je to taková moje terapie zdarma.',
        obrazekCesta: 'assets/Kofina_bod4.png',
        textCast2: 'Paní Krupicová už mě zná. Přinese mi cold brew ve velkým hrnku s uchem a položí ho na můj speciální stolek u výlohy. Jsem pravděpodobně jediná kočka v Ústí, která má vlastní kavárenský servis. Dokonce mi studenti vyrobili i ručně šitý polštářek. Nenávidím ho. Používám ho každý den. A mléko? Ne ne, chcete abych byla tlustá?',
        lat: 50.6657764,
        lon: 14.0223244,
      ),
      BodMise(
        id: 5,
        nazevBodu: 'Ve Vlnovce s Egypťankou',
        tipNaCestu: 'Stočíme to zpátky na severozápad ulicemi na Klíších.',
        podnadpis: 'Atomová kočka',
        textCast1: 'Domů nechodím nikdy tou samou cestou. Znám jedno místo, ze kterého se vám zaručeně zamotá hlava. Domy se tam vlní jako u moře. Lehnu si na záda a pozoruju křivky střech. A pak ji uvidím. Holá kočka v zelené mikině.',
        obrazekCesta: 'assets/Kofina_bod5.png',
        textCast2: '„Co tu děláš? Kde máš chlupy?“ ptám se.\n„Přišla jsem o ně, když bouchnul Černobyl... snažím se z toho dostat.“\n„A ta mikina ti pomáhá?“\n„Tak asi když pod ní nemám kůži?“\n„Jó, jasně. A nechceš jít na bowling?“\n„Možná, až mi narostou chlupy.“\nMega divný, dneska ty vlny nakládaj.',
        lat: 50.6650889,
        lon: 14.0205328,
      ),
      BodMise(
        id: 6,
        nazevBodu: 'U jabloně s Charliem',
        tipNaCestu: 'Vem to s Charliem rovnou za roh na bowling.',
        podnadpis: 'Setkání s cizím psem',
        textCast1: 'Na Klíších máme problém s úzkými ulicemi. Chodím pěšinami nebo trávou, což zase skýtá jiná nebezpečí. Třeba psy. Psy jsou divný. Velký pes znamená automaticky bezodkladné opuštění prostoru.',
        obrazekCesta: 'assets/Kofina_bod6.png',
        textCast2: 'Takže vidím černýho malýho psa na volno, jak tohle setkání pod rozkvetlou jabloní dopadne. Je o trochu větší než já.\n„Co čumíš, kočko?“\n„Čau, nechceš jít na bowling?“\n„To bych šel moc rád. Je tam volná dráha?“',
        lat: 50.6664617,
        lon: 14.0178425,
      ),
      BodMise(
        id: 7,
        nazevBodu: 'Bowling',
        tipNaCestu: 'Mise splněna. Jdi spát.',
        podnadpis: 'Toy videa a šlofík',
        textCast1: 'Netušila jsem, že večer dopadne takhle. Charlie sedí na zadních a směje se vlastním fórům jak přerostlá surikata. Je to nakažlivý. Až na ty otravný fanoušky fotbalu, co tam měli vedle nás debilní kecy. Sprta a Šláfie.',
        obrazekCesta: 'assets/Kofina_bod7.png',
        textCast2: 'Ale jinak dobrý večer. Jo a na bowlingu vyměnili ty skvěle debilní 3D animace za nějaký toy videa s padajícíma lyžařema. Nikdo neví proč. Už se nemůžu dočkat, až to řeknu Gardě.\n\nJdu domů. Protáhnu se oknem a spim.',
        lat: 50.6675400,
        lon: 14.0160044,
      ),
    ],
  ),
];