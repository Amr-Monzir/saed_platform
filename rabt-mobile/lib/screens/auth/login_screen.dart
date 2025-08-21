import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../state/auth/auth_providers.dart';
import '../../widgets/app_button.dart';
import '../../state/volunteer/volunteer_repository.dart';
import '../../widgets/app_password_field.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = TextEditingController();
    final passController = TextEditingController();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            Text('Rabt platform', style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text('Connect with organisations. Volunteer for Palestine.', style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Image.asset('assets/images/logo/rabt_logo_512.png', width: MediaQuery.of(context).size.width, fit: BoxFit.contain),
            const Spacer(),
            // Volunteer login only (switching to org login via link below)
            TextField(decoration: const InputDecoration(labelText: 'Email'), controller: emailController),
            const SizedBox(height: 8),
            AppPasswordField(controller: passController),
            const SizedBox(height: 12),
            AppButton(
              onPressed: () async {
                // Testing shortcut: if ENV indicates local/test and fields empty, auto-fill default
                String email = emailController.text.trim();
                String password = passController.text;
                final env = (dotenv.env['ENV'] ?? '').toLowerCase();
                if ((email.isEmpty || password.isEmpty) && (env == 'local' || env == 'test' || env == 'testing')) {
                  email = 'volunteer1@example.com';
                  password = email;
                  emailController.text = email;
                  passController.text = password;
                }
                final ok = await ref.read(authControllerProvider.notifier).loginWithBackend(email: email, password: password);
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
              onPressed: () => context.push('/jobs'),
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
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () => context.go('/login/organization'),
                child: const Text('Login as Organization'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


