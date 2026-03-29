import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final IconData levaIkona;
  final VoidCallback? naLevaIkonaKlik;
  final IconData? pravaIkona;
  final VoidCallback? naPravaIkonaKlik;
  final Color barvaPozadi;

  const MyAppBar({
    super.key,
    required this.levaIkona,
    this.naLevaIkonaKlik,
    this.pravaIkona,
    this.naPravaIkonaKlik,
    this.barvaPozadi = const Color(0xFFFCFCE4),
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: barvaPozadi,
      elevation: 0,
      centerTitle: true,
      title: const Text(
        'Navandr',
        style: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          letterSpacing: -0.5,
        ),
      ),
      leading: IconButton(
        icon: Icon(levaIkona, color: Colors.black, size: 28),
        onPressed: naLevaIkonaKlik,
      ),
      actions: [
        if (pravaIkona != null)
          IconButton(
            icon: Icon(pravaIkona, color: Colors.black, size: 28),
            onPressed: naPravaIkonaKlik,
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}