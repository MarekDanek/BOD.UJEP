import 'package:flutter/material.dart';

class AppBarPlay extends StatelessWidget implements PreferredSizeWidget {
  final String nazevMise;
  final String postup;
  final VoidCallback onMenuClick;
  final VoidCallback onCloseClick;

  const AppBarPlay({
    super.key,
    required this.nazevMise,
    required this.postup,
    required this.onMenuClick,
    required this.onCloseClick,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFAED41),
      padding: const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.menu, color: Colors.black, size: 30),
                onPressed: onMenuClick,
              ),
              const Icon(Icons.directions_walk, size: 40, color: Colors.black),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.black, size: 30),
                onPressed: onCloseClick,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                nazevMise,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                postup,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(130);
}