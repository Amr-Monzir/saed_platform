import 'package:flutter/material.dart';

enum AppButtonVariant { primary, outline }
enum AppButtonSize { normal, small }

class AppButton extends StatelessWidget {
  const AppButton({super.key, required this.label, this.onPressed, this.variant = AppButtonVariant.primary, this.size = AppButtonSize.normal});

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;

  @override
  Widget build(BuildContext context) {
    final child = Text(label);
    final style = switch (size) {
      AppButtonSize.normal => null,
      AppButtonSize.small => (variant == AppButtonVariant.primary
          ? ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10))
          : OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10))),
    };

    return switch (variant) {
      AppButtonVariant.primary => ElevatedButton(onPressed: onPressed, style: style, child: child),
      AppButtonVariant.outline => OutlinedButton(onPressed: onPressed, style: style, child: child),
    };
  }
}


