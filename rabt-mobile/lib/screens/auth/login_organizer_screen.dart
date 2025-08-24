import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rabt_mobile/models/enums.dart';
import 'package:rabt_mobile/state/auth/auth_providers.dart';
import 'package:rabt_mobile/widgets/app_button.dart';
import 'package:rabt_mobile/widgets/app_password_field.dart';
import 'package:rabt_mobile/screens/organization/my_adverts_screen.dart';
import 'package:rabt_mobile/screens/auth/signup_organizer_screen.dart';
import 'package:rabt_mobile/screens/auth/login_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' ;

class OrganizerLoginScreen extends ConsumerWidget {
  const OrganizerLoginScreen({super.key});

  static const String path = '/login/organization';

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
            Text('Post and manage adverts.', style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
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
                  email = 'organizer2@example.com';
                  password = email;
                  emailController.text = email;
                  passController.text = password;
                }
                final ok = await ref
                    .read(authControllerProvider.notifier)
                    .loginWithBackend(email: email, password: password, type: UserType.organizer);
                if (!context.mounted) return;
                if (ok) {
                  try {
                    if (!context.mounted) return;
                    context.go(MyAdvertsScreen.path);
                  } catch (_) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('This account is not an organization')));
                  }
                }
              },
              label: 'Login',
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () => context.go(OrganizerSignupScreen.path),
                child: const Text('Need an account? Sign up'),
              ),
            ),
            const SizedBox(height: 8),
            Center(child: TextButton(onPressed: () => context.go(LoginScreen.path), child: const Text('Login as Volunteer'))),
          ],
        ),
      ),
    );
  }
}
