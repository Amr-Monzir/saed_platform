import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/app_button.dart';
import '../../services/api_service.dart';

class OrganizerSignupScreen extends ConsumerStatefulWidget {
  const OrganizerSignupScreen({super.key});

  @override
  ConsumerState<OrganizerSignupScreen> createState() => _OrganizerSignupScreenState();
}

class _OrganizerSignupScreenState extends ConsumerState<OrganizerSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _websiteCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _websiteCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create organisation account')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              AppTextField(
                controller: _nameCtrl,
                label: 'Organisation name',
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              AppTextField(
                controller: _emailCtrl,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v != null && v.contains('@') ? null : 'Enter a valid email',
              ),
              AppTextField(
                controller: _passCtrl,
                label: 'Password',
                obscureText: true,
                validator: (v) => v != null && v.length >= 6 ? null : 'Min 6 chars',
              ),
              AppTextField(controller: _websiteCtrl, label: 'Website (optional)'),
              AppTextField(controller: _descCtrl, label: 'Description (optional)', maxLines: 3),
              const SizedBox(height: 16),
              AppButton(
                label: _loading ? 'Please wait…' : 'Create account',
                onPressed:
                    _loading
                        ? null
                        : () async {
                          if (!_formKey.currentState!.validate()) return;
                          setState(() => _loading = true);
                          try {
                            await ApiService.instance.post('/api/v1/organizers/register', {
                              'name': _nameCtrl.text.trim(),
                              'email': _emailCtrl.text.trim(),
                              'password': _passCtrl.text,
                              if (_websiteCtrl.text.trim().isNotEmpty) 'website': _websiteCtrl.text.trim(),
                              if (_descCtrl.text.trim().isNotEmpty) 'description': _descCtrl.text.trim(),
                            });
                            if (!mounted) return;
                            if (context.mounted) {
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(const SnackBar(content: Text('Account created. Please log in.')));
                              context.go('/login/organization');
                            }
                          } catch (e) {
                            if (!mounted) return;
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Signup failed: $e')));
                            }
                          } finally {
                            if (mounted) setState(() => _loading = false);
                          }
                        },
              ),
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  onPressed: () => context.go('/login/organization'),
                  child: const Text('Already have an account? Log in'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
