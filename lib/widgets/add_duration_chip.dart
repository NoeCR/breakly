import 'package:flutter/material.dart';

class AddDurationChip extends StatelessWidget {
  final Future<void> Function() onAdd;

  const AddDurationChip({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onAdd,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white60),
        ),
        child: const Text(
          'Add',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
