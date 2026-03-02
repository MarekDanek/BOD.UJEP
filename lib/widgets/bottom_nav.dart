import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});


@override
  Widget build(BuildContext context) {
      return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 12,
              offset: Offset(0, 5)
            )
          ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.grey, size: 25),
              onPressed: (){
                print("Klik na Home");
              },
            ),
             IconButton(
              icon: const Icon(Icons.layers, color: Colors.grey, size: 25),
              onPressed: (){
                print("Klik na Vrstvu");
              },
            ),
             IconButton(
              onPressed: (){
                print("Klik na Mapu ");
              },
              icon: ShaderMask(
                 shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      colors: [Colors.yellow, Colors.orangeAccent],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ).createShader(bounds);
                 },
              child: const Icon(Icons.map_outlined, color: Colors.white, size: 28),
            ),
          ),
        ],
      ),
    );
  }
}