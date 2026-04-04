'use server'

import { prisma } from '../lib/prisma'
import { revalidatePath } from 'next/cache'

export async function pridatTrasu(formData: FormData) {
  const nazev = formData.get('nazev') as string
  const popis = formData.get('popis') as string
  const delkaKm = parseFloat(formData.get('delkaKm') as string) || 0

  await prisma.trasa.create({
    data: {
      nazev,
      popis,
      delkaKm,
      bodyTrasy: "{}"
    }
  })

  revalidatePath('/')
}