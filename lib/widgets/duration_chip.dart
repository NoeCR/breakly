import 'package:flutter/material.dart';

class DurationChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const DurationChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? Colors.white70 : Colors.white24,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white60),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.black87 : Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
