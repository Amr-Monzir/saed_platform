import 'package:flutter/material.dart';

class BadgeChip extends StatelessWidget {
  const BadgeChip({super.key, required this.label, this.icon, this.color, this.isSelected = false, this.onTap});
  final String label;
  final IconData? icon;
  final Color? color;
  final bool isSelected;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    final bg = (color ?? Theme.of(context).colorScheme.primary).withValues(alpha: .12);
    final fg = color ?? Theme.of(context).colorScheme.primary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(color: isSelected ? fg : bg, borderRadius: BorderRadius.circular(999)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[Icon(icon, size: 14, color: fg), const SizedBox(width: 6)],
            Text(label, style: TextStyle(color: isSelected ? Colors.white : fg, fontWeight: FontWeight.w600, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
