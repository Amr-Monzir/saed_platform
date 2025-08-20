import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../state/auth/auth_providers.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/app_button.dart';
import '../../state/volunteer/volunteer_repository.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  UserRole _role = UserRole.volunteer;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider).isLoading;
    return Scaffold(
      appBar: AppBar(title: const Text('Create your account')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<UserRole>(
                value: _role,
                items: const [
                  DropdownMenuItem(value: UserRole.volunteer, child: Text('Volunteer')),
                  DropdownMenuItem(value: UserRole.organization, child: Text('Organization')),
                ],
                onChanged: (v) => setState(() => _role = v ?? UserRole.volunteer),
                decoration: const InputDecoration(labelText: 'Role'),
              ),
              AppTextField(
                controller: _emailController,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v != null && v.contains('@') ? null : 'Enter a valid email',
              ),
              AppTextField(
                controller: _passwordController,
                label: 'Password',
                obscureText: true,
                validator: (v) => v != null && v.length >= 6 ? null : 'Min 6 chars',
              ),
              const SizedBox(height: 16),
              AppButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        if (!_formKey.currentState!.validate()) return;
                        final success = await ref.read(authControllerProvider.notifier).signup(
                              email: _emailController.text.trim(),
                              password: _passwordController.text,
                              role: _role,
                            );
                        if (!context.mounted) return;
                        if (success) {
                          if (_role == UserRole.organization) {
                            if (!context.mounted) return;
                            context.go('/o/my-jobs');
                          } else {
                            final me = await ref.read(volunteerRepositoryProvider).me();
                            final pending = ref.read(authControllerProvider).session?.pendingAdvertId;
                            if (!context.mounted) return;
                            if (!me.onboardingCompleted) {
                              context.push('/v/profile-setup');
                            } else if (pending != null) {
                              await ref.read(authControllerProvider.notifier).setPendingAdvert(null);
                              context.push('/jobs/$pending');
                            } else {
                              context.push('/v/jobs');
                            }
                          }
                        }
                      },
                label: isLoading ? 'Please wait...' : 'Create account',
              )
            ],
          ),
        ),
      ),
    );
  }
}


