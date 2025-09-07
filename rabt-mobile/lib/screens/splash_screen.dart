import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  static const String path = '/splash';

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
    if (!mounted) return;
    // Let router redirect decide destination to avoid navigation loops
    context.go(SplashScreen.path);
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
              'assets/images/logo/logo_no_bg.png',
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
