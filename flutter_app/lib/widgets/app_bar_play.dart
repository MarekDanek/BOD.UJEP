import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 5,
          left: 20,
          right: 20,
          bottom: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: onMenuClick,
                child: const Icon(Icons.menu, color: Colors.black, size: 28),
              ),
              Expanded(
                child: Transform.translate(
                  offset: const Offset(15, 0),
                  child: Transform.scale(
                    scale: 5,
                    child: SvgPicture.asset(
                      'assets/logo.svg',
                      height: 40,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: onCloseClick,
                child: const Icon(Icons.close, color: Colors.black, size: 28),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // KLÍČOVÁ ZMĚNA: Přidán FittedBox, který text zmenší, pokud je moc dlouhý
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    nazevMise,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16), // Mezera mezi názvem a postupem
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
  Size get preferredSize => const Size.fromHeight(125); // Přidali jsme 10 pixelů k dobru
}