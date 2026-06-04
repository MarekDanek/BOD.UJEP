import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KopirovatTlacitko extends StatelessWidget {
  final String textToCopy;
  final String uspesnaZprava;

  const KopirovatTlacitko({
    super.key,
    required this.textToCopy,
    this.uspesnaZprava = 'Souřadnice zkopírovány',
  });

  Future<void> _kopirovat(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: textToCopy));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(uspesnaZprava),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _kopirovat(context),
      icon: const Icon(Icons.copy, size: 18, color: Colors.black87),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
      tooltip: 'Kopírovat',
    );
  }
}