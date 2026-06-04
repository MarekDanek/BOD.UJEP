import 'package:flutter/material.dart';

class CenterUserButton extends StatelessWidget {
  final bool isFollowing;
  final int stavHry;
  final VoidCallback onPressed;
  final double size;

  const CenterUserButton({
    super.key,
    required this.isFollowing,
    required this.stavHry,
    required this.onPressed,
    this.size = 56,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: stavHry > 0 ? 150.0 : 0.0),
      child: SizedBox(
        width: size,
        height: size,
        child: FloatingActionButton(
          onPressed: onPressed,
          backgroundColor: const Color(0xFFFAED41),
          child: Icon(
            isFollowing ? Icons.my_location : Icons.location_searching,
            color: Colors.black,
            size: size * 0.5,
          ),
        ),
      ),
    );
  }
}