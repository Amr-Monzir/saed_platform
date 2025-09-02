import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rabt_mobile/screens/auth/login_screen.dart';

class GuestShell extends StatelessWidget {
  const GuestShell({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      appBar: AppBar(
        title: Text('Ready to join the struggle?  Login here', style: Theme.of(context).textTheme.titleMedium),
        centerTitle: false,
        actionsPadding: const EdgeInsets.only(right: 16),
        actions: [
          IconButton(
            onPressed: () {
              context.go(LoginScreen.path);
            },
            icon: const Icon(Icons.login),
          ),
        ],
      ),
    );
  }
}
