import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rabt_mobile/models/enums.dart';
import 'package:rabt_mobile/screens/adverts/advert_detail_screen.dart';
import 'package:rabt_mobile/screens/adverts/adverts_list_screen.dart';
import 'package:rabt_mobile/screens/organization/my_adverts_screen.dart';
import 'package:rabt_mobile/screens/volunteer/profile_setup_screen.dart';
import 'package:rabt_mobile/state/auth/auth_providers.dart';
import 'package:rabt_mobile/state/volunteer/volunteer_repository.dart';
import 'package:rabt_mobile/widgets/app_button.dart';
import 'package:rabt_mobile/widgets/app_text_field.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  static const String path = '/signup';

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  UserType _type = UserType.volunteer;

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
              DropdownButtonFormField<UserType>(
                value: _type,
                items: const [
                  DropdownMenuItem(value: UserType.volunteer, child: Text('Volunteer')),
                  DropdownMenuItem(value: UserType.organizer, child: Text('Organization')),
                ],
                onChanged: (v) => setState(() => _type = v ?? UserType.volunteer),
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
                onPressed:
                    isLoading
                        ? null
                        : () async {
                          if (!_formKey.currentState!.validate()) return;
                          final success = await ref
                              .read(authControllerProvider.notifier)
                              .signup(email: _emailController.text.trim(), password: _passwordController.text, type: _type);
                          if (!context.mounted) return;
                          if (success) {
                            if (_type == UserType.organizer) {
                              if (!context.mounted) return;
                              context.go(MyAdvertsScreen.path);
                            } else {
                              final me = await ref.read(volunteerRepositoryProvider).fetchVolunteerProfile();
                              final pending = ref.read(authControllerProvider).value?.pendingAdvertId;
                              if (!context.mounted) return;
                              if (!me.onboardingCompleted) {
                                context.push(VolunteerProfileSetupScreen.path);
                              } else if (pending != null) {
                                await ref.read(authControllerProvider.notifier).setPendingAdvert(null);
                                if (context.mounted) {
                                  context.push(AdvertDetailScreen.pathFor(int.parse(pending)));
                                }
                              } else {
                                context.push(AdvertsListScreen.volunteerPath);
                              }
                            }
                          }
                        },
                label: isLoading ? 'Please wait...' : 'Create account',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
