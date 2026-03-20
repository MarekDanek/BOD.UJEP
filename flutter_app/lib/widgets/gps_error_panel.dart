import 'package:flutter/material.dart';

class GpsErrorPanel extends StatelessWidget {
  final String errorText;
  final VoidCallback onRetry;

  const GpsErrorPanel({
    super.key,
    required this.errorText,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Material(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Icon(Icons.warning_amber, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(errorText, style: const TextStyle(color: Colors.white)),
                ),
                TextButton(
                  onPressed: onRetry,
                  child: const Text('Zkusit znovu', style: TextStyle(color: Color(0xFFFAED41))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}