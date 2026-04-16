import MapTrasyWrapper from './MapTrasyWrapper';

import { prisma } from '../lib/prisma'
import { pridatVrtsvu } from './actions'



export default async function AdminDashboard() {
  const vrstvy = await prisma.vrstva.findMany({
    orderBy: { vytvoreno: 'desc' },
    include: {
      _count: {
        select: { mise: true }
      }
    }
  }).catch((chyba : any) => {
    console.error(" CHYBA DATABÁZE V NEXT.JS:", chyba);
    return [];
  });

  return (
    <div className="flex min-h-screen text-gray-800 font-sans">

      {/* BOČNÍ PANEL (SIDEBAR) */}
      <aside className="w-64 bg-gray-900/90 backdrop-blur-xl border-r border-gray-700 p-6 shadow-2xl flex flex-col z-10">
        <h2 className="text-2xl font-black mb-8 text-transparent bg-clip-text bg-gradient-to-r from-emerald-400 to-cyan-400">
          Admin Panel
        </h2>
        <nav className="space-y-3 flex-1">
          <div className="p-3 bg-white/20 rounded-xl text-white font-medium shadow-inner border border-white/20 cursor-pointer transition-all flex items-center gap-3">
            <span>📚</span> Správa Vrstev
          </div>
        </nav>
      </aside>

      {/* HLAVNÍ OBSAH */}
      <main className="flex-1 p-10 overflow-y-auto">
        <h1 className="text-4xl font-extrabold mb-10 tracking-tight text-gray-900 drop-shadow-sm">
          Správa <span className="text-emerald-600">Vrstev</span>
        </h1>

        <div className="grid grid-cols-1 lg:grid-cols-2 gap-10">

          {/* FORMULÁŘ */}
          <section className="bg-white/60 backdrop-blur-xl p-8 rounded-3xl shadow-xl border border-white/50">
            <h2 className="text-2xl font-bold mb-6 text-gray-800 flex items-center gap-2">
              <span>✨</span> Vytvořit novou vrstvu
            </h2>

            <form action={pridatVrtsvu} className="space-y-5">
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-1">Název vrstvy</label>
                <input type="text" name="nazev" placeholder="Např. Kampus UJEP" required
                  className="w-full p-3 bg-white/70 border border-gray-300 rounded-xl focus:ring-4 focus:ring-emerald-500/20 focus:border-emerald-500 outline-none transition-all text-gray-900 placeholder-gray-400 shadow-sm" />
              </div>

              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-1">Popis</label>
                <textarea name="popis" placeholder="O čem tato vrstva je?" rows={2}
                  className="w-full p-3 bg-white/70 border border-gray-300 rounded-xl focus:ring-4 focus:ring-emerald-500/20 focus:border-emerald-500 outline-none transition-all text-gray-900 placeholder-gray-400 shadow-sm" />
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-1">Ikona (Emoji/Text)</label>
                  <input type="text" name="ikona" placeholder="🏫" defaultValue="🏫"
                    className="w-full p-3 bg-white/70 border border-gray-300 rounded-xl focus:ring-4 focus:ring-emerald-500/20 focus:border-emerald-500 outline-none transition-all text-gray-900 shadow-sm" />
                </div>
                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-1">Barva (HEX)</label>
                  <input type="color" name="barva" defaultValue="#FAED41"
                    className="w-full h-[50px] p-1 bg-white/70 border border-gray-300 rounded-xl cursor-pointer shadow-sm" />
                </div>
              </div>

            <div className="col-span-2">
                <label className="block text-sm font-semibold text-gray-700 mb-2">Nakreslit trasu mise</label>
                <MapTrasyWrapper />
              </div>

              <button type="submit"
                className="w-full mt-4 bg-gradient-to-r from-emerald-500 to-cyan-500 text-white font-bold py-3 px-4 rounded-xl shadow-lg hover:shadow-emerald-500/40 hover:scale-[1.02] active:scale-95 transition-all">
                Uložit vrstvu
              </button>
            </form>
          </section>

          {/* VÝPIS VRSTEV */}
          <section className="bg-white/60 backdrop-blur-xl p-8 rounded-3xl shadow-xl border border-white/50">
            <h2 className="text-2xl font-bold mb-6 text-gray-800 flex items-center gap-2">
              <span>📂</span> Aktivní vrstvy
            </h2>

            {vrstvy.length === 0 ? (
              <div className="text-center py-12 text-gray-500 font-medium bg-white/40 rounded-2xl border-2 border-dashed border-gray-300">
                Zatím tu nejsou žádné vrstvy.<br/>Vytvoř svou první!
              </div>
            ) : (
              <ul className="space-y-4 max-h-[500px] overflow-y-auto pr-2">
                {vrstvy.map((v : any) => (
                  <li key={v.id} className="p-5 bg-white/80 hover:bg-white border border-gray-200 rounded-2xl shadow-sm transition-all hover:shadow-md group flex items-start gap-4">

                    {/* Ikona s barvou vrstvy */}
                    <div
                      className="w-12 h-12 rounded-xl flex items-center justify-center text-2xl shadow-sm"
                      style={{ backgroundColor: v.barva || '#eee' }}
                    >
                      {v.ikona}
                    </div>

                    <div className="flex-1">
                      <div className="font-bold text-lg text-gray-900 group-hover:text-emerald-600 transition-colors">
                        {v.nazev}
                      </div>
                      <div className="text-sm text-gray-600 mt-1 line-clamp-2">
                        {v.popis || 'Bez popisu'}
                      </div>
                    </div>

                    <span className="bg-emerald-100 text-emerald-800 text-xs font-black px-3 py-1 rounded-full whitespace-nowrap shadow-sm">
                      Misí: {v._count.mise}
                    </span>
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