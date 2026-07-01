import 'package:flutter/material.dart';

import '../data/profil_data.dart';
import '../data/profil_obrazky.dart';

class UpravitProfilDialog extends StatefulWidget {
  final ProfilUzivatele profil;

  const UpravitProfilDialog({super.key, required this.profil});

  @override
  State<UpravitProfilDialog> createState() => _UpravitProfilDialogState();
}

class _UpravitProfilDialogState extends State<UpravitProfilDialog> {
  late final TextEditingController _jmenoController;
  late final TextEditingController _prijmeniController;
  late final TextEditingController _prezdivkaController;
  String? _idObrazku;

  @override
  void initState() {
    super.initState();
    _jmenoController = TextEditingController(text: widget.profil.jmeno);
    _prijmeniController = TextEditingController(text: widget.profil.prijmeni);
    _prezdivkaController = TextEditingController(text: widget.profil.prezdivka);
    _idObrazku = widget.profil.idObrazku;
  }

  @override
  void dispose() {
    _jmenoController.dispose();
    _prijmeniController.dispose();
    _prezdivkaController.dispose();
    super.dispose();
  }

  void _ulozit() {
    final profil = ProfilUzivatele(
      jmeno: _jmenoController.text.trim(),
      prijmeni: _prijmeniController.text.trim(),
      prezdivka: _prezdivkaController.text.trim(),
      idObrazku: _idObrazku,
    );
    Navigator.pop(context, profil);
  }

  Widget _buildVyberObrazku() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Profilový obrázek',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: profiloveObrazky.map((obrazek) {
            final jeVybrany = _idObrazku == obrazek.id;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _idObrazku = obrazek.id;
                });
              },
              child: buildProfilObrazek(
                idObrazku: obrazek.id,
                velikost: 56,
                jeVybrany: jeVybrany,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPole(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black54),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black38),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 2),
        ),
      ),
      style: const TextStyle(color: Colors.black, fontSize: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFFFCFCE4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Colors.black, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Upravit údaje',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: buildProfilObrazek(
                  idObrazku: _idObrazku,
                  velikost: 100,
                  jeVybrany: _idObrazku != null,
                ),
              ),
              const SizedBox(height: 20),
              _buildVyberObrazku(),
              const SizedBox(height: 24),
              _buildPole('Jméno', _jmenoController),
              const SizedBox(height: 12),
              _buildPole('Příjmení', _prijmeniController),
              const SizedBox(height: 12),
              _buildPole('Přezdívka', _prezdivkaController),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Zrušit',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: _ulozit,
                      child: const Text(
                        'Uložit',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
