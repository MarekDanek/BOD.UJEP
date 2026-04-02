import 'package:flutter/material.dart';

class LockButton extends StatefulWidget {
  // Funkce, která vrátí true/false při kliknutí
  final ValueChanged<bool> onChanged;
  // Výchozí stav zámku (volitelný, standardně nastaven na zamčeno)
  final bool initialLocked;

  const LockButton({
    Key? key,
    required this.onChanged,
    this.initialLocked = true,
  }) : super(key: key);

  @override
  _LockButtonState createState() => _LockButtonState();
}

class _LockButtonState extends State<LockButton> {
  late bool jeBodZamknuty;

  @override
  void initState() {
    super.initState();
    // Nastavení výchozího stavu při inicializaci
    jeBodZamknuty = widget.initialLocked;
  }

  void _toggleLock() {
    setState(() {
      jeBodZamknuty = !jeBodZamknuty; // Přepnutí stavu
    });
    // Zavolání funkce a předání nového stavu (true = zamčeno, false = odemčeno)
    widget.onChanged(jeBodZamknuty);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 48.0, // Velikost ikony si můžeš upravit
      color: jeBodZamknuty ? Colors.red : Colors.green, // Změna barvy podle stavu
      icon: Icon(
        jeBodZamknuty ? Icons.lock : Icons.lock_open,
      ),
      onPressed: _toggleLock,
    );
  }
}