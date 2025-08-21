import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../state/auth/auth_providers.dart';
import '../../widgets/app_button.dart';
import '../../state/organizer/organizer_repository.dart';
import '../../widgets/app_password_field.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OrganizerLoginScreen extends ConsumerWidget {
  const OrganizerLoginScreen({super.key});

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
            Text('Login as Organisation', style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text('Post and manage activist job adverts.', style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Image.asset('assets/images/logo/rabt_logo_512.png', width: MediaQuery.of(context).size.width, fit: BoxFit.contain),
            const Spacer(),
            TextField(decoration: const InputDecoration(labelText: 'Email'), controller: emailController),
            const SizedBox(height: 8),
            AppPasswordField(controller: passController),
            const SizedBox(height: 12),
            AppButton(
              onPressed: () async {
                String email = emailController.text.trim();
                String password = passController.text;
                final env = (dotenv.env['ENV'] ?? '').toLowerCase();
                if ((email.isEmpty || password.isEmpty) && (env == 'local' || env == 'test' || env == 'testing')) {
                  email = 'organizer1@example.com';
                  password = email;
                  emailController.text = email;
                  passController.text = password;
                }
                final ok = await ref.read(authControllerProvider.notifier).loginWithBackend(email: email, password: password, role: UserRole.organization);
                if (!context.mounted) return;
                if (ok) {
                  try {
                    await ref.read(organizerRepositoryProvider).fetchOrganizerProfile();
                    if (!context.mounted) return;
                    context.go('/o/my-jobs');
                  } catch (_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('This account is not an organization')),
                    );
                  }
                }
              },
              label: 'Login',
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () => context.go('/signup/organization'),
                child: const Text('Need an account? Sign up'),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () => context.go('/login'),
                child: const Text('Login as Volunteer'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


