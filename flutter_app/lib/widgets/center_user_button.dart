import 'package:flutter/material.dart';

class CenterUserButton extends StatelessWidget {
  final bool isFollowing;
  final int stavHry;
  final VoidCallback onPressed;

  const CenterUserButton({
    super.key,
    required this.isFollowing,
    required this.stavHry,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: stavHry > 0 ? 150.0 : 0.0),
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: const Color(0xFFFAED41),
        child: Icon(isFollowing ? Icons.my_location : Icons.location_searching, color: Colors.black),
      ),
    );
  }
}