class Odznak {
  final String id;
  final String nazev;
  final String popis;
  final String? obrazek;

  const Odznak({
    required this.id,
    required this.nazev,
    required this.popis,
    this.obrazek,
  });
}

/// Dočasný seznam odznaků – později se nahradí daty z databáze.
const List<Odznak> ziskaneOdznaky = [
  Odznak(
    id: 'prvni_krok',
    nazev: 'První krok',
    popis: 'Dokončil jsi svou první trasu v Navandru.',
  ),
  Odznak(
    id: 'pruzkumnik',
    nazev: 'Průzkumník',
    popis: 'Navštívil jsi 3 různé body na mapě.',
  ),
  Odznak(
    id: 'maraton',
    nazev: 'Maraton',
    popis: 'Ušel jsi trasu delší než 5 km.',
  ),
  Odznak(
    id: 'bonus_hunter',
    nazev: 'Lovec bonusů',
    popis: 'Našel jsi všechny bonusové stránky v misi.',
  ),
  Odznak(
    id: 'rychla_noha',
    nazev: 'Rychlá noha',
    popis: 'Dokončil jsi trasu rychleji než odhadovaný čas.',
  ),
  Odznak(
    id: 'mistni_znalost',
    nazev: 'Místní znalost',
    popis: 'Dokončil jsi 5 různých tras v Ústí nad Labem.',
  ),
];
