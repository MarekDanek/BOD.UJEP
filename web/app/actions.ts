'use server'

import { prisma } from '../lib/prisma'
import { revalidatePath } from 'next/cache'

export async function smazatVrstvu(formData: FormData) {
  const id = formData.get('id') as string

  if (id) {
    await prisma.vrstva.delete({
      where: { id }
    })
    revalidatePath('/') // Obnoví stránku
  }
}

export async function pridatVrtsvu(formData: FormData) {
  // 1. Získáme základní data z formuláře (ikonu jsme z databáze smazali, takže ji tu už nečteme)
  const nazev = formData.get('nazev') as string
  const popis = formData.get('popis') as string
  const barva = formData.get('barva') as string

  // Získáme i náš tajný balíček s daty z mapy!
  const naklikaneBodyText = formData.get('naklikaneBody') as string
  const hlavniBodText = formData.get('hlavniBod') as string

  // Zkusíme rozbalit hlavní bod, pokud ho admin naklikal
  const hlavniBod = hlavniBodText ? JSON.parse(hlavniBodText) : null

  // 2. Vytvoříme samotnou Vrstvu
  const novaVrstva = await prisma.vrstva.create({
    data: { nazev, popis, barva }
  })

  // 3. Pokud admin v mapě naklikal nějaké body, zpracujeme je
  if (naklikaneBodyText) {
    const bodyZMapy = JSON.parse(naklikaneBodyText) // Rozbalíme JSON do pole

    if (bodyZMapy.length > 0) {
      // Protože Body musí patřit do Mise (podle tvého schématu),
      // vytvoříme rovnou i výchozí Misi pro tuto novou vrstvu.
      const novaMise = await prisma.mise.create({
        data: {
          vrstvaId: novaVrstva.id,
          nazev: `Hlavní trasa - ${nazev}`,
          podnadpis: 'Základní mise',
          textCast1: 'Tato mise byla vytvořena přes mapu.',
          obrazekCesta: '',
          textCast2: '',
          pocetBodu: `${bodyZMapy.length} bodů`,
          vzdalenost: 'Neznámá',
          obtiznost: 'Normální',
          cas: 'Dle tempa',
          bonusy: '0',
          typ: 'Mapa',
          // NOVÉ: Uložíme souřadnice zlaté hvězdy (hlavního bodu)!
          hlavniLat: hlavniBod?.lat || null,
          hlavniLon: hlavniBod?.lon || null,
        }
      })

      // Nyní projdeme všechny naklikané body z mapy a uložíme je do databáze
      for (let i = 0; i < bodyZMapy.length; i++) {
        const bod = bodyZMapy[i];

        await prisma.bodMise.create({
          data: {
            miseId: novaMise.id,
            poradi: i + 1, // Tohle pořadí je klíčové, aby Flutter věděl, jak ty body spojit čárou!
            nazevBodu: bod.nazev || `Zastávka ${i + 1}`,
            podnadpis: '',
            textCast1: bod.pribeh || '',
            textCast2: '',
            lat: bod.lat,
            lon: bod.lon,

            // NOVÉ: Ukládáme pole obrázků jako JSON text
            obrazkyGalerie: JSON.stringify(bod.obrazkyGalerie || []),
            bonusObrazky: JSON.stringify(bod.bonusObrazky || []),
            bonusAudioPath: bod.audioUrl || null,
          }
        })
      }
    }
  }

  // Nakonec řekneme Next.js, ať obnoví stránku, abychom tu novou vrstvu hned viděli v seznamu
  revalidatePath('/')
}