"use client";

import { useState, useEffect } from 'react';
import { MapContainer, TileLayer, Marker, Polyline, useMapEvents } from 'react-leaflet';
import 'leaflet/dist/leaflet.css';
import L from 'leaflet';
import { nahratSoubor } from './uploadActions';

// Oprava ikon Leafletu
delete (L.Icon.Default.prototype as any)._getIconUrl;
L.Icon.Default.mergeOptions({
  iconRetinaUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon-2x.png',
  iconUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon.png',
  shadowUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-shadow.png',
});

// Speciální ikona pro Hlavní bod mise (Hvězda/Zlatá)
const hlavniBodIcon = new L.Icon({
  iconUrl: 'https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-2x-gold.png',
  shadowUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/0.7.7/images/marker-shadow.png',
  iconSize: [25, 41],
  iconAnchor: [12, 41],
  popupAnchor: [1, -34],
  shadowSize: [41, 41]
});

type BodType = {
  id: number;
  lat: number;
  lon: number;
  nazev: string;
  pribeh: string;
  obrazkyGalerie: string[]; // Pole URL adres
  audioUrl: string;
  bonusObrazky: string[]; // Galerie pro bonusy
};

export default function MapTrasy() {
  const [rezim, setRezim] = useState<'HLAVNI' | 'TRASE'>('TRASE');
  const [hlavniBod, setHlavniBod] = useState<{ lat: number, lon: number } | null>(null);
  const [body, setBody] = useState<BodType[]>([]);
  const [vybranyBodId, setVybranyBodId] = useState<number | null>(null);
  const [nahravam, setNahravam] = useState(false);

  // Komponenta pro klikání do mapy
  const ZachytavaniKliknuti = () => {
    useMapEvents({
      click(e) {
        if (rezim === 'HLAVNI') {
          setHlavniBod({ lat: e.latlng.lat, lon: e.latlng.lng });
        } else {
          const novyId = Date.now();
          const novyBod: BodType = {
            id: novyId,
            lat: e.latlng.lat,
            lon: e.latlng.lng,
            nazev: `Bod ${body.length + 1}`,
            pribeh: '',
            obrazkyGalerie: [],
            audioUrl: '',
            bonusObrazky: [],
          };
          setBody([...body, novyBod]);
          setVybranyBodId(novyId);
        }
      },
    });
    return null;
  };

  const vybranyBod = body.find((b) => b.id === vybranyBodId);

  const upravitBod = (klic: keyof BodType, hodnota: any) => {
    if (!vybranyBodId) return;
    setBody(body.map((b) => (b.id === vybranyBodId ? { ...b, [klic]: hodnota } : b)));
  };

  // Hromadné nahrávání souborů
  const handleMultipleUpload = async (e: React.ChangeEvent<HTMLInputElement>, typ: 'obrazkyGalerie' | 'bonusObrazky') => {
    if (!e.target.files || e.target.files.length === 0 || !vybranyBodId) return;

    setNahravam(true);
    const noveUrl: string[] = [...(vybranyBod?.[typ] || [])];

    for (const soubor of Array.from(e.target.files)) {
      const formData = new FormData();
      formData.append('soubor', soubor);
      const vysledek = await nahratSoubor(formData);
      if (vysledek.success && vysledek.url) {
        noveUrl.push(vysledek.url);
      }
    }

    upravitBod(typ, noveUrl);
    setNahravam(false);
  };

  return (
    <div className="space-y-4">
      {/* PŘEPÍNAČ REŽIMŮ */}
      <div className="flex bg-gray-100 p-1 rounded-xl w-fit border border-gray-200 shadow-sm">
        <button
          type="button"
          onClick={() => setRezim('HLAVNI')}
          className={`px-4 py-2 rounded-lg text-sm font-bold transition-all ${rezim === 'HLAVNI' ? 'bg-white text-emerald-600 shadow-sm' : 'text-gray-500 hover:text-gray-700'}`}
        >
          📍 Hlavní bod mise
        </button>
        <button
          type="button"
          onClick={() => setRezim('TRASE')}
          className={`px-4 py-2 rounded-lg text-sm font-bold transition-all ${rezim === 'TRASE' ? 'bg-white text-emerald-600 shadow-sm' : 'text-gray-500 hover:text-gray-700'}`}
        >
          🛤️ Zastávky trasy
        </button>
      </div>

      {/* MAPA */}
      <div className="w-full h-[450px] rounded-2xl overflow-hidden border border-gray-300 shadow-xl z-0 relative">
        <MapContainer center={[50.665, 14.026]} zoom={15} className="w-full h-full">
          <TileLayer url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png" />
          <ZachytavaniKliknuti />

          {/* Vykreslení hlavního bodu */}
          {hlavniBod && <Marker position={[hlavniBod.lat, hlavniBod.lon]} icon={hlavniBodIcon} />}

          {/* Vykreslení trasy */}
          {body.map((bod) => (
            <Marker
              key={bod.id}
              position={[bod.lat, bod.lon]}
              eventHandlers={{ click: () => { setRezim('TRASE'); setVybranyBodId(bod.id); } }}
            />
          ))}

          {body.length > 1 && (
            <Polyline positions={body.map((b) => [b.lat, b.lon])} color="#10b981" weight={4} dashArray="5, 10" />
          )}
        </MapContainer>
      </div>

      {/* EDITOR VYBRANÉHO BODU */}
      {vybranyBod && (
        <div className="bg-white p-6 rounded-2xl shadow-2xl border-2 border-emerald-500/20 animate-in fade-in slide-in-from-bottom-4">
          <div className="flex justify-between items-center mb-6">
            <h3 className="text-xl font-black text-gray-800">Editace: {vybranyBod.nazev}</h3>
            <button type="button" onClick={() => setVybranyBodId(null)} className="text-gray-400 hover:text-gray-800">✕ Zavřít</button>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div className="space-y-4">
              <input type="text" value={vybranyBod.nazev} onChange={(e) => upravitBod('nazev', e.target.value)}
                className="w-full p-3 bg-gray-50 border border-gray-200 rounded-xl focus:ring-2 focus:ring-emerald-500 outline-none font-bold" placeholder="Název zastávky" />
              <textarea value={vybranyBod.pribeh} onChange={(e) => upravitBod('pribeh', e.target.value)} rows={4}
                className="w-full p-3 bg-gray-50 border border-gray-200 rounded-xl focus:ring-2 focus:ring-emerald-500 outline-none" placeholder="Příběh tohoto místa..." />
            </div>

            <div className="space-y-4">
              {/* GALERIE OBRÁZKŮ */}
              <div className="p-4 bg-emerald-50 rounded-xl border border-emerald-100">
                <label className="block text-xs font-black text-emerald-700 uppercase mb-2">📸 Galerie obrázků (i více)</label>
                <input type="file" multiple accept="image/*" onChange={(e) => handleMultipleUpload(e, 'obrazkyGalerie')}
                  className="w-full text-xs text-emerald-800 file:mr-2 file:py-2 file:px-4 file:rounded-full file:border-0 file:bg-emerald-600 file:text-white hover:file:bg-emerald-700 cursor-pointer" />
                <div className="flex gap-2 mt-2 overflow-x-auto">
                  {vybranyBod.obrazkyGalerie.map((img, i) => <div key={i} className="w-10 h-10 bg-gray-200 rounded-lg flex-shrink-0" title={img} />)}
                </div>
              </div>

              {/* BONUSY */}
              <div className="p-4 bg-amber-50 rounded-xl border border-amber-100">
                <label className="block text-xs font-black text-amber-700 uppercase mb-2">🎁 Bonusový obsah (Audio + Foto)</label>
                <div className="space-y-2">
                   <input type="file" accept="audio/*" onChange={async (e) => {
                     if (!e.target.files?.[0]) return;
                     const fd = new FormData(); fd.append('soubor', e.target.files[0]);
                     const res = await nahratSoubor(fd);
                     if (res.success) upravitBod('audioUrl', res.url);
                   }} className="text-xs w-full" />
                   <input type="file" multiple accept="image/*" onChange={(e) => handleMultipleUpload(e, 'bonusObrazky')} className="text-xs w-full" />
                </div>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Skrytá data pro uložení */}
      <input type="hidden" name="naklikaneBody" value={JSON.stringify(body)} />
      <input type="hidden" name="hlavniBod" value={JSON.stringify(hlavniBod)} />
    </div>
  );
}