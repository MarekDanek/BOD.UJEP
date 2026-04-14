"use client";

import dynamic from 'next/dynamic';

// Tady už to Next.js dovolí, protože jsme v "use client" souboru
const MapTrasy = dynamic(() => import('./MapTrasy'), { ssr: false });

export default function MapTrasyWrapper() {
  return <MapTrasy />;
}