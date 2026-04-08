'use server'

import { prisma } from '../lib/prisma'
import { revalidatePath } from 'next/cache'

export async function pridatVrtsvu(formData: FormData) {
  const nazev = formData.get('nazev') as string
  const popis = formData.get('popis') as string
  const barva = formData.get('barva') as string || '#FAED41'
  const ikona = formData.get('ikona') as string || '🗺️'

  await prisma.vrstva.create({
    data: {
      nazev,
      popis,
      barva,
      ikona
    }
  })

  // Aktualizuje hlavní stránku, abychom hned viděli novou vrstvu
  revalidatePath('/')
}