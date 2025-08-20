import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../state/auth/auth_providers.dart';
import '../../widgets/app_button.dart';
import '../../state/volunteer/volunteer_repository.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = TextEditingController();
    final passController = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            Text('Activist Job Platform', style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text('Connect with causes. Volunteer with purpose.', style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
            const Spacer(),
            TextField(decoration: const InputDecoration(labelText: 'Email'), controller: emailController),
            const SizedBox(height: 8),
            TextField(decoration: const InputDecoration(labelText: 'Password'), controller: passController, obscureText: true),
            const SizedBox(height: 12),
            AppButton(
              onPressed: () async {
                final ok = await ref.read(authControllerProvider.notifier).loginWithBackend(email: emailController.text.trim(), password: passController.text);
                if (!context.mounted) return;
                if (ok) {
                  final me = await ref.read(volunteerRepositoryProvider).me();
                  if (!context.mounted) return;
                  if (me.onboardingCompleted) {
                    context.go('/v/jobs');
                  } else {
                    context.go('/v/profile-setup');
                  }
                }
              },
              label: 'Login',
            ),
            const SizedBox(height: 12),
            AppButton(
              onPressed: () => context.go('/jobs'),
              label: 'Continue as Guest Volunteer',
              variant: AppButtonVariant.outline,
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () => context.go('/signup'),
                child: const Text('Need an account? Sign up'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


