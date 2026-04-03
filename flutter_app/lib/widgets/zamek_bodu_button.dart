import 'package:flutter/material.dart';

class LockButton extends StatefulWidget {
  final ValueChanged<bool> onChanged;
  final bool initialLocked;

  const LockButton({
    super.key, // OPRAVENO: Použití super parametru
    required this.onChanged,
    this.initialLocked = true,
  });

  @override
  State<LockButton> createState() => _LockButtonState();
}

class _LockButtonState extends State<LockButton> {
  late bool jeBodZamknuty;

  @override
  void initState() {
    super.initState();
    jeBodZamknuty = widget.initialLocked;
  }

  void _toggleLock() {
    setState(() {
      jeBodZamknuty = !jeBodZamknuty;
    });
    widget.onChanged(jeBodZamknuty);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 40.0,
      color: jeBodZamknuty ? Colors.red : Colors.green,
      icon: Icon(
        jeBodZamknuty ? Icons.lock : Icons.lock_open,
      ),
      onPressed: _toggleLock,
    );
  }
}