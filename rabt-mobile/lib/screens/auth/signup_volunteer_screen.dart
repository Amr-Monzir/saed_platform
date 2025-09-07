import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rabt_mobile/models/enums.dart';
import 'package:rabt_mobile/screens/adverts/adverts_list_screen.dart';
import 'package:rabt_mobile/screens/organization/my_adverts_screen.dart';
import 'package:rabt_mobile/state/auth/auth_providers.dart';
import 'package:rabt_mobile/state/volunteer/volunteer_repository.dart';
import 'package:rabt_mobile/widgets/app_button.dart';
import 'package:rabt_mobile/widgets/app_text_field.dart';
import 'package:rabt_mobile/constants/lookups.dart';

class SignupVolunteerScreen extends ConsumerStatefulWidget {
  const SignupVolunteerScreen({super.key});

  static const String path = '/signup';

  @override
  ConsumerState<SignupVolunteerScreen> createState() => _SignupVolunteerScreenState();
}

class _SignupVolunteerScreenState extends ConsumerState<SignupVolunteerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final Set<String> _selectedSkills = {};

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider).isLoading;
    return Scaffold(
      appBar: AppBar(title: const Text('Create your volunteer account')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Basic Information Section
              const Text('Basic Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              AppTextField(
                controller: _nameController,
                label: 'Full Name *',
                validator: (v) => v != null && v.trim().isNotEmpty ? null : 'Name is required',
              ),
              const SizedBox(height: 12),

              AppTextField(
                controller: _emailController,
                label: 'Email *',
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v != null && v.contains('@') ? null : 'Enter a valid email',
              ),
              const Padding(
                padding: EdgeInsets.only(left: 12, top: 4),
                child: Text(
                  'We need your email for login and notifications about updates to your applications.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 12),

              AppTextField(
                controller: _passwordController,
                label: 'Password *',
                obscureText: true,
                validator: (v) => v != null && v.length >= 6 ? null : 'Password must be at least 6 characters',
              ),
              const SizedBox(height: 12),

              AppTextField(
                controller: _phoneController,
                label: 'Phone Number',
                keyboardType: TextInputType.phone,
                validator: (v) => v == null || v.trim().isEmpty || _isValidPhone(v) ? null : 'Enter a valid phone number',
              ),
              const Padding(
                padding: EdgeInsets.only(left: 12, top: 4),
                child: Text(
                  'Organizers may need to contact you on your phone number if they accept your applications.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 12),

              // Skills Section
              const SizedBox(height: 24),
              const Text('Skills (Optional)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    kSkillsChooseList.map((skill) {
                      final selected = _selectedSkills.contains(skill);
                      return FilterChip(
                        label: Text(skill),
                        selected: selected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedSkills.add(skill);
                            } else {
                              _selectedSkills.remove(skill);
                            }
                          });
                        },
                      );
                    }).toList(),
              ),
              const SizedBox(height: 32),

              AppButton(
                onPressed: isLoading ? null : _handleSignup,
                label: isLoading ? 'Creating account...' : 'Create volunteer account',
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isValidPhone(String phone) {
    // Basic phone validation - can be enhanced
    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]{10,}$');
    return phoneRegex.hasMatch(phone);
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      // First, create the user account
      final success = await ref
          .read(authControllerProvider.notifier)
          .signup(email: _emailController.text.trim(), password: _passwordController.text, type: UserType.volunteer);

      if (!context.mounted) return;

      if (success) {
        // Create volunteer profile with collected information
        await ref
            .read(volunteerRepositoryProvider)
            .update(
              name: _nameController.text.trim(),
              phoneNumber: _phoneController.text.trim().isNotEmpty ? _phoneController.text.trim() : null,
              skillIds: _selectedSkills.map((skill) => kSkillsCreateAdvert.indexOf(skill)).toList(),
            );

        // Navigate to appropriate screen
        final pending = ref.read(authControllerProvider).value?.pendingAdvertId;
        if (pending != null) {
          await ref.read(authControllerProvider.notifier).setPendingAdvert(null);
          if (mounted) {
            context.go(MyAdvertsScreen.path);
          }
        } else {
          if (mounted) {
            context.push(AdvertsListScreen.volunteerPath);
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error creating account: ${e.toString()}')));
      }
    }
  }
}
