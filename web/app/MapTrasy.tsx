"use client";

import { useState } from 'react';
import { MapContainer, TileLayer, Marker, Polyline, useMapEvents } from 'react-leaflet';
import 'leaflet/dist/leaflet.css';
import L from 'leaflet';

// Tento kousek kódu opravuje chybu Next.js, kdy se nenačítají špendlíky (ikony) mapy
delete (L.Icon.Default.prototype as any)._getIconUrl;
L.Icon.Default.mergeOptions({
  iconRetinaUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon-2x.png',
  iconUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon.png',
  shadowUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-shadow.png',
});

export default function MapTrasy() {
  // Zde si pamatuje všechny naklikané body
  const [body, setBody] = useState<{ lat: number; lon: number }[]>([]);

  // Tato skrytá komponenta "poslouchá" na kliknutí myší do mapy
  const ZachytavaniKliknuti = () => {
    useMapEvents({
      click(e) {
        // Při kliknutí přidáme nový bod do našeho seznamu
        const noveBody = [...body, { lat: e.latlng.lat, lon: e.latlng.lng }];
        setBody(noveBody);
      },
    });
    return null;
  };

  return (
    <div className="space-y-3">
      {/* Rámeček s mapou */}
      <div className="w-full h-[400px] rounded-xl overflow-hidden border border-gray-300 shadow-inner z-0 relative">
        <MapContainer
          center={[50.665, 14.026]} // Vycentrováno na Kampus UJEP
          zoom={16}
          scrollWheelZoom={true}
          className="w-full h-full"
        >
          <TileLayer
            url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
            attribution='&copy; OpenStreetMap'
          />

          <ZachytavaniKliknuti />

          {/* Vykreslení špendlíků pro každý bod */}
          {body.map((bod, i) => (
            <Marker key={i} position={[bod.lat, bod.lon]} />
          ))}

          {/* Vykreslení modré čáry spojující body (musí být aspoň 2) */}
          {body.length > 1 && (
            <Polyline positions={body.map((b) => [b.lat, b.lon])} color="#10b981" weight={4} />
          )}
        </MapContainer>
      </div>

      {/* Ovládací panel pod mapou */}
      <div className="flex gap-4">
        <button
          type="button"
          onClick={() => setBody(body.slice(0, -1))}
          className="px-4 py-2 bg-gray-200 hover:bg-gray-300 text-gray-800 rounded-lg font-medium transition-colors"
        >
          Smazat poslední bod
        </button>
        <button
          type="button"
          onClick={() => setBody([])}
          className="px-4 py-2 bg-red-100 hover:bg-red-200 text-red-700 rounded-lg font-medium transition-colors"
        >
          Vymazat vše
        </button>
      </div>

      {/* Tady si ukážeme, jak vypadají vygenerovaná data (GeoJSON struktura) pro databázi */}
      <div className="p-3 bg-gray-900 text-green-400 font-mono text-xs rounded-lg overflow-x-auto">
        {body.length === 0 ? "Zatím žádná trasa. Klikni do mapy!" : JSON.stringify(body)}
      </div>
    </div>
  );
}