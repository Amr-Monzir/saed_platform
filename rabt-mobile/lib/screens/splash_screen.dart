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
    if (!mounted) return;
    // Let router redirect decide destination to avoid navigation loops
    context.go('/splash');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Spacer(),
          Text('Welcome to Rabt', style: Theme.of(context).textTheme.titleLarge),
          Spacer(),
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: Image.asset(
              'assets/images/logo/rabt_logo_512.png',
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.contain,
            ),
          ),
          Spacer(),
          const CircularProgressIndicator(),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
