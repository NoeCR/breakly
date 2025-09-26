import 'package:flutter/material.dart';

class ClearChip extends StatelessWidget {
  final Future<void> Function() onClear;

  const ClearChip({super.key, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClear,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white60),
        ),
        child: const Icon(Icons.close, color: Colors.white, size: 18),
      ),
    );
  }
}
