import 'package:shared_preferences/shared_preferences.dart';

class ProfilUzivatele {
  String jmeno;
  String prijmeni;
  String prezdivka;
  String? idObrazku;

  ProfilUzivatele({
    this.jmeno = '',
    this.prijmeni = '',
    this.prezdivka = '',
    this.idObrazku,
  });

  ProfilUzivatele kopie() {
    return ProfilUzivatele(
      jmeno: jmeno,
      prijmeni: prijmeni,
      prezdivka: prezdivka,
      idObrazku: idObrazku,
    );
  }
}

const _klicJmeno = 'profil_jmeno';
const _klicPrijmeni = 'profil_prijmeni';
const _klicPrezdivka = 'profil_prezdivka';
const _klicObrazek = 'profil_obrazek_id';

Future<ProfilUzivatele> nactiProfil() async {
  final prefs = await SharedPreferences.getInstance();
  return ProfilUzivatele(
    jmeno: prefs.getString(_klicJmeno) ?? '',
    prijmeni: prefs.getString(_klicPrijmeni) ?? '',
    prezdivka: prefs.getString(_klicPrezdivka) ?? '',
    idObrazku: prefs.getString(_klicObrazek),
  );
}

Future<void> ulozProfil(ProfilUzivatele profil) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_klicJmeno, profil.jmeno);
  await prefs.setString(_klicPrijmeni, profil.prijmeni);
  await prefs.setString(_klicPrezdivka, profil.prezdivka);
  if (profil.idObrazku != null) {
    await prefs.setString(_klicObrazek, profil.idObrazku!);
  } else {
    await prefs.remove(_klicObrazek);
  }
}
