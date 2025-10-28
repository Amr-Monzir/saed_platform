import 'package:flutter/material.dart';

enum AppButtonVariant { primary, outline, inline }

enum AppButtonSize { normal, small }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.normal,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;

  @override
  Widget build(BuildContext context) {
    final child = Text(
      label,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color:
            variant == AppButtonVariant.inline || variant == AppButtonVariant.outline
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.surface,
      ),
    );
    final style = switch (size) {
      AppButtonSize.normal => null,
      AppButtonSize.small =>
        (variant == AppButtonVariant.primary
            ? ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10))
            : OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10))),
    };

    return switch (variant) {
      AppButtonVariant.primary => ElevatedButton(onPressed: onPressed, style: style, child: child),
      AppButtonVariant.outline => OutlinedButton(onPressed: onPressed, style: style, child: child),
      AppButtonVariant.inline => OutlinedButton(onPressed: onPressed, style: style, child: child),
    };
  }
}
