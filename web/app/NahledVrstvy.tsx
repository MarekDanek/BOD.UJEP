import React from 'react';

export default function NahledVrstvy({ vrstva }: { vrstva: any }) {
  if (!vrstva) return null;

  const mise = vrstva.mise?.[0];
  const barva = vrstva.barva || '#FAED41';

  // Pomocná funkce pro bezpečné rozbalení JSON polí z databáze
  const parsujGalerii = (data: string | null) => {
    try {
      return data ? JSON.parse(data) : [];
    } catch (e) {
      return [];
    }
  };

  return (
    <div className="bg-white rounded-[2.5rem] shadow-2xl overflow-hidden border border-gray-100 flex flex-col min-h-[800px]">

      {/* HEADER S DYNAMICKOU BARVOU */}
      <div
        style={{ backgroundColor: barva }}
        className="p-10 pb-16 relative"
      >
        <div className="relative z-10">
          <span className="bg-black/10 text-black/60 px-3 py-1 rounded-full text-xs font-bold uppercase tracking-widest">
            Mobilní Náhled
          </span>
          <h2 className="text-4xl font-black text-gray-900 mt-4 leading-tight">
            {vrstva.nazev}
          </h2>
          <p className="text-gray-800/80 font-medium mt-2 max-w-md">
            {vrstva.popis || "Bez popisu vrstvy..."}
          </p>
        </div>

        {/* Dekorativní prvek barvy */}
        <div className="absolute -bottom-10 -right-10 w-64 h-64 bg-white/20 rounded-full blur-3xl" />
      </div>

      <div className="p-8 -mt-8 bg-white rounded-t-[2rem] flex-1">
        {mise ? (
          <div className="space-y-8">
            {/* HLAVNÍ BOD MISE (START) */}
            {(mise.hlavniLat && mise.hlavniLon) && (
              <div className="p-4 rounded-2xl bg-gray-50 border-2 border-dashed border-gray-200 flex items-center gap-4">
                <div className="w-12 h-12 bg-amber-400 rounded-full flex items-center justify-center text-2xl shadow-lg">
                  ⭐
                </div>
                <div>
                  <h4 className="font-bold text-gray-900">Hlavní startovní bod</h4>
                  <p className="text-xs text-gray-500">
                    {mise.hlavniLat.toFixed(4)}, {mise.hlavniLon.toFixed(4)}
                  </p>
                </div>
              </div>
            )}

            {/* SEZNAM BODŮ (TIMELINE) */}
            <div className="space-y-10 relative before:absolute before:left-6 before:top-2 before:bottom-2 before:w-0.5 before:bg-gray-100">
              {mise.bodyMise?.map((bod: any) => {
                const galerie = parsujGalerii(bod.obrazkyGalerie);
                const bonusy = parsujGalerii(bod.bonusObrazky);

                return (
                  <div key={bod.id} className="relative pl-14">
                    {/* Číslo bodu */}
                    <div
                      style={{ backgroundColor: barva }}
                      className="absolute left-0 w-12 h-12 rounded-full flex items-center justify-center font-black text-gray-900 border-4 border-white shadow-md z-10"
                    >
                      {bod.poradi}
                    </div>

                    <div className="bg-white rounded-2xl p-5 border border-gray-100 shadow-sm hover:shadow-md transition-shadow">
                      <h4 className="text-lg font-bold text-gray-900 mb-2">{bod.nazevBodu}</h4>
                      <p className="text-sm text-gray-600 leading-relaxed mb-4">{bod.textCast1}</p>

                      {/* GALERIE OBRÁZKŮ */}
                      {galerie.length > 0 && (
                        <div className="flex gap-2 overflow-x-auto pb-2 scrollbar-hide">
                          {galerie.map((url: string, i: number) => (
                            <div key={i} className="w-32 h-24 bg-gray-100 rounded-xl flex-shrink-0 overflow-hidden border border-gray-200 relative group">
                               <div className="absolute inset-0 flex items-center justify-center text-[10px] text-gray-400 font-bold">📷 FOTO {i+1}</div>
                               <img src={url} alt="" className="absolute inset-0 w-full h-full object-cover z-10" />
                            </div>
                          ))}
                        </div>
                      )}

                      {/* BONUSOVÁ SEKCE */}
                      {(bod.bonusAudioPath || bonusy.length > 0) && (
                        <div className="mt-4 p-3 bg-amber-50 rounded-xl border border-amber-100">
                          <span className="text-[10px] font-black text-amber-700 uppercase tracking-widest">🎁 Bonusový obsah</span>
                          <div className="flex gap-3 mt-2">
                            {bod.bonusAudioPath && <span className="text-xl" title="Audio">🎵</span>}
                            {bonusy.length > 0 && <span className="text-xl" title="Bonusové fotky">🖼️ ({bonusy.length})</span>}
                          </div>
                        </div>
                      )}
                    </div>
                  </div>
                );
              })}
            </div>
          </div>
        ) : (
          <div className="text-center py-20 text-gray-400">
            Zatím nebyly vytvořeny žádné mise pro tuto vrstvu.
          </div>
        )}
      </div>
    </div>
  );
}