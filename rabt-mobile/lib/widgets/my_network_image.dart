

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rabt_mobile/services/api_service.dart';

class MyNetworkImage extends ConsumerWidget {
  const MyNetworkImage({super.key, required this.url, this.width, this.height});

  final String url;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Hero(
      tag: url,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          '${ref.read(apiServiceProvider).baseUrl}$url',
          fit: BoxFit.cover,
          width: width,
          height: height,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.image, size: 48, color: theme.colorScheme.primary),
            );
          },
        ),
      ),
    );
  }
}
