import { PrismaClient } from '@prisma/client'
const prisma = new PrismaClient()

async function main() {
  // 1. Vytvoříme Vrstvu
  const vrstva = await prisma.vrstva.create({
    data: {
      nazev: "Kampus UJEP",
      popis: "Noir příběhy z ústecké univerzity",
      barva: "#FAED41",
      ikona: "🏫",
    }
  })

  // 2. Vytvoříme Misi Kuneš
  const mise = await prisma.mise.create({
    data: {
      vrstvaId: vrstva.id,
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
    }
  })

  // 3. Vytvoříme první Bod (Menza)
  await prisma.bodMise.create({
    data: {
      miseId: mise.id,
      poradi: 1,
      nazevBodu: 'Menza',
      podnadpis: 'Případ předem ztraceného překvapení',
      textCast1: 'Vešel jsem do menzy.\n\nPodíval jsem se na menu.',
      obrazekCesta: 'assets/BOD4_2.png',
      textCast2: 'Už jsem ho znal. Musel jsem si oběd objednat včera. Žádné překvapení. Žádná záhada.\n\nJen tichá vůně rozvařených těstovin, která se vznášela ve vzduchu jako špatná životní rozhodnutí.\n\nChvíli jsem tam stál.\n\nPak jsem šel dál.',
      lat: 50.6647478,
      lon: 14.0258906,
    }
  })

  // 4. Vytvoříme druhý Bod (Existencionální pauza) i s bonusem
  await prisma.bodMise.create({
    data: {
      miseId: mise.id,
      poradi: 2,
      nazevBodu: 'Existencionální pauza',
      podnadpis: 'Soundtrack v předjaří',
      textCast1: 'Velké otevřené prostranství mezi budovami.\n\nVítr tam fouká tak, jako by chtěl lidem připomenout, že všechno jednou skončí.\n\nVytáhl jsem telefon.\n\nPustil jsem si jednu starou indie věc. Kytara zněla smutně.',
      obrazekCesta: 'assets/BOD2_1.png',
      textCast2: 'Přesně tak, jak má znít dobrý den.\n\nKampus kolem mě pokračoval ve svém pomalém životě.\n\nJá taky.',
      lat: 50.6650428,
      lon: 14.0257067,
      bonusAudioPath: 'assets/audio/music.mp3',
      bonusoveStranky: {
        create: [
          {
            poradi: 1,
            podnadpis: 'Bonus',
            obrazek: 'assets/BOD2_2.png',
            text: 'Tokio Drift — bejby navždy.',
            malyText: 'Skladbu můžeš poslouchat\nna cestě k dalšímu bodu',
            zaoblitObrazek: true,
          }
        ]
      }
    }
  })

  console.log("Data byla úspěšně nahrána do databáze!")
}

main()
  .catch((e) => {
    console.error(e)
    process.exit(1)
  })
  .finally(async () => {
    await prisma.$disconnect()
  })