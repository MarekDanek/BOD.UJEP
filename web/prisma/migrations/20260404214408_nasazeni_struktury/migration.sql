-- CreateTable
CREATE TABLE "Vrstva" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "nazev" TEXT NOT NULL,
    "popis" TEXT,
    "barva" TEXT,
    "ikona" TEXT,
    "vytvoreno" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "upraveno" DATETIME NOT NULL
);

-- CreateTable
CREATE TABLE "Mise" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "vrstvaId" TEXT NOT NULL,
    "nazev" TEXT NOT NULL,
    "podnadpis" TEXT NOT NULL,
    "textCast1" TEXT NOT NULL,
    "obrazekCesta" TEXT NOT NULL,
    "textCast2" TEXT NOT NULL,
    "pocetBodu" TEXT NOT NULL,
    "vzdalenost" TEXT NOT NULL,
    "obtiznost" TEXT NOT NULL,
    "cas" TEXT NOT NULL,
    "bonusy" TEXT NOT NULL,
    "typ" TEXT NOT NULL,
    "vytvoreno" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "upraveno" DATETIME NOT NULL,
    CONSTRAINT "Mise_vrstvaId_fkey" FOREIGN KEY ("vrstvaId") REFERENCES "Vrstva" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "BodMise" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "miseId" TEXT NOT NULL,
    "poradi" INTEGER NOT NULL,
    "nazevBodu" TEXT NOT NULL,
    "podnadpis" TEXT NOT NULL,
    "textCast1" TEXT NOT NULL,
    "obrazekCesta" TEXT NOT NULL,
    "textCast2" TEXT NOT NULL,
    "lat" REAL NOT NULL,
    "lon" REAL NOT NULL,
    "bonusAudioPath" TEXT,
    CONSTRAINT "BodMise_miseId_fkey" FOREIGN KEY ("miseId") REFERENCES "Mise" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "BonusovaStranka" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "bodMiseId" TEXT NOT NULL,
    "poradi" INTEGER NOT NULL,
    "obrazek" TEXT,
    "podnadpis" TEXT,
    "text" TEXT NOT NULL,
    "malyText" TEXT,
    "zaoblitObrazek" BOOLEAN NOT NULL DEFAULT false,
    CONSTRAINT "BonusovaStranka_bodMiseId_fkey" FOREIGN KEY ("bodMiseId") REFERENCES "BodMise" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateIndex
CREATE UNIQUE INDEX "BodMise_miseId_poradi_key" ON "BodMise"("miseId", "poradi");
