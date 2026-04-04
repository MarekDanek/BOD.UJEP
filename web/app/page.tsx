import { prisma } from '../lib/prisma'
import { pridatTrasu } from './actions'

export default async function AdminDashboard() {
  const trasy = await prisma.trasa.findMany({
    orderBy: { vytvoreno: 'desc' }
  }).catch(() => []);

  return (
    // Hlavní obal - průhledný, aby prosvítal gradient z layoutu
    <div className="flex min-h-screen text-gray-800 font-sans">

      {/* BOČNÍ PANEL (SIDEBAR) - Tmavý se skleněným efektem */}
      <aside className="w-64 bg-gray-900/90 backdrop-blur-xl border-r border-gray-700 p-6 shadow-2xl flex flex-col z-10">
        <h2 className="text-2xl font-black mb-8 text-transparent bg-clip-text bg-gradient-to-r from-emerald-400 to-cyan-400">
          Admin Panel
        </h2>
        <nav className="space-y-3 flex-1">
          <div className="p-3 bg-white/10 rounded-xl text-white font-medium shadow-inner border border-white/10 cursor-pointer transition-all hover:bg-white/20 flex items-center gap-3">
            <span>🗺️</span> Trasy
          </div>
        </nav>
      </aside>

      {/* HLAVNÍ OBSAH */}
      <main className="flex-1 p-10 overflow-y-auto">
        <h1 className="text-4xl font-extrabold mb-10 tracking-tight text-gray-900 drop-shadow-sm">
          Správa <span className="text-emerald-600">Tras</span>
        </h1>

        <div className="grid grid-cols-1 lg:grid-cols-2 gap-10">

          {/* FORMULÁŘ - Skleněná karta */}
          <section className="bg-white/60 backdrop-blur-xl p-8 rounded-3xl shadow-xl border border-white/50">
            <h2 className="text-2xl font-bold mb-6 text-gray-800 flex items-center gap-2">
              <span>✨</span> Přidat novou trasu
            </h2>

            <form action={pridatTrasu} className="space-y-5">
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-1">Název trasy</label>
                <input type="text" name="nazev" placeholder="Např. Cesta lesem" required
                  className="w-full p-3 bg-white/70 border border-gray-300 rounded-xl focus:ring-4 focus:ring-emerald-500/20 focus:border-emerald-500 outline-none transition-all text-gray-900 placeholder-gray-400 shadow-sm" />
              </div>

              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-1">Popis</label>
                <textarea name="popis" placeholder="Co cestou uvidíme?" rows={3}
                  className="w-full p-3 bg-white/70 border border-gray-300 rounded-xl focus:ring-4 focus:ring-emerald-500/20 focus:border-emerald-500 outline-none transition-all text-gray-900 placeholder-gray-400 shadow-sm" />
              </div>

              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-1">Délka (km)</label>
                <input type="number" step="0.1" name="delkaKm" placeholder="0.0"
                  className="w-full p-3 bg-white/70 border border-gray-300 rounded-xl focus:ring-4 focus:ring-emerald-500/20 focus:border-emerald-500 outline-none transition-all text-gray-900 placeholder-gray-400 shadow-sm" />
              </div>

              <button type="submit"
                className="w-full mt-4 bg-gradient-to-r from-emerald-500 to-cyan-500 text-white font-bold py-3 px-4 rounded-xl shadow-lg hover:shadow-emerald-500/40 hover:scale-[1.02] active:scale-95 transition-all">
                Uložit trasu
              </button>
            </form>
          </section>

          {/* VÝPIS TRAS - Skleněná karta */}
          <section className="bg-white/60 backdrop-blur-xl p-8 rounded-3xl shadow-xl border border-white/50">
            <h2 className="text-2xl font-bold mb-6 text-gray-800 flex items-center gap-2">
              <span>📂</span> Uložené trasy
            </h2>

            {trasy.length === 0 ? (
              <div className="text-center py-12 text-gray-500 font-medium bg-white/40 rounded-2xl border-2 border-dashed border-gray-300">
                Zatím tu nejsou žádné trasy.<br/>Přidej svou první!
              </div>
            ) : (
              <ul className="space-y-4 max-h-[500px] overflow-y-auto pr-2">
                {trasy.map((t) => (
                  <li key={t.id} className="p-5 bg-white/80 hover:bg-white border border-gray-200 rounded-2xl shadow-sm transition-all hover:shadow-md group">
                    <div className="flex justify-between items-start">
                      <div>
                        <div className="font-bold text-lg text-gray-900 group-hover:text-emerald-600 transition-colors">
                          {t.nazev}
                        </div>
                        <div className="text-sm text-gray-600 mt-1 line-clamp-2">
                          {t.popis || 'Bez popisu'}
                        </div>
                      </div>
                      <span className="bg-emerald-100 text-emerald-800 text-xs font-black px-3 py-1 rounded-full whitespace-nowrap shadow-sm ml-4">
                        {t.delkaKm} km
                      </span>
                    </div>
                  </li>
                ))}
              </ul>
            )}
          </section>

        </div>
      </main>
    </div>
  )
}