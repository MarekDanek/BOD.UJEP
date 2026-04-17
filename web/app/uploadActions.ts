'use server'

import { writeFile } from 'fs/promises';
import { existsSync, mkdirSync } from 'fs';
import path from 'path';
import crypto from 'crypto';

export async function nahratSoubor(formData: FormData) {
  const soubor = formData.get('soubor') as File;

  if (!soubor) {
    return { success: false, error: 'Nebyl vybrán žádný soubor.' };
  }

  try {
    // 1. Převedeme soubor na Buffer (čistá data)
    const bytes = await soubor.arrayBuffer();
    const buffer = Buffer.from(bytes);

    // 2. Vytvoříme unikátní otisk (Hash) z obsahu souboru
    // Tím zaručíme, že stejný obrázek bude mít vždy stejný název
    const hash = crypto.createHash('sha256').update(buffer).digest('hex');

    // 3. Získáme původní příponu (např. .jpg, .png)
    const pripona = path.extname(soubor.name);

    // Nový název bude např: 8f434346648f6b96df89dda901c5176b10a6d83961dd3c1ac88b59b2dc327aa4.jpg
    const novyNazev = `${hash}${pripona}`;

    // 4. Připravíme cestu ke složce a k souboru
    const slozkaUploads = path.join(process.cwd(), 'public/uploads');
    const cestaKSouboru = path.join(slozkaUploads, novyNazev);

    // 5. Ujistíme se, že složka /uploads existuje (pokud ne, vytvoříme ji)
    if (!existsSync(slozkaUploads)) {
      mkdirSync(slozkaUploads, { recursive: true });
    }

    // 6. KOUZLO: Pokud soubor s tímto jménem (obsahem) ještě neexistuje, teprve ho uložíme na disk
    if (!existsSync(cestaKSouboru)) {
      await writeFile(cestaKSouboru, buffer);
    }

    // 7. Vrátíme cestu pro uložení do databáze
    return { success: true, url: `/uploads/${novyNazev}` };

  } catch (error) {
    console.error('Chyba při ukládání souboru:', error);
    return { success: false, error: 'Soubor se nepodařilo uložit.' };
  }
}