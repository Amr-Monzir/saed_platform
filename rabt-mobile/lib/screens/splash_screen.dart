import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../state/auth/auth_providers.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 600), _navigateNext);
  }

  Future<void> _navigateNext() async {
    final session = await ref.read(authControllerProvider.notifier).restoreSession();
    if (session == null) {
      if (mounted) context.go('/login');
    } else {
      if (session.userRole == UserRole.organization) {
        if (mounted) context.go('/o/my-jobs');
      } else {
        if (mounted) context.go('/v/jobs');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(Icons.favorite_outline, color: Theme.of(context).colorScheme.primary, size: 36),
            ),
            const SizedBox(height: 16),
            Text('Rabt', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

