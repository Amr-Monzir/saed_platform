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
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OrganizerLoginScreen extends ConsumerStatefulWidget {
  const OrganizerLoginScreen({super.key});

  static const String path = '/login/organization';

  @override
  ConsumerState<OrganizerLoginScreen> createState() => _OrganizerLoginScreenState();
}

class _OrganizerLoginScreenState extends ConsumerState<OrganizerLoginScreen> {
  late final TextEditingController emailController;
  late final TextEditingController passController;
  late final FocusNode emailFocusNode;
  late final FocusNode passwordFocusNode;
  final _formKey = GlobalKey<FormState>();

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email.trim());
  }

  bool get _canSubmit {
    return _isValidEmail(emailController.text) && passController.text.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passController = TextEditingController();
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    // Listeners to trigger rebuilds for button state updates
    emailController.addListener(() => setState(() {}));
    passController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    String email = emailController.text.trim();
    String password = passController.text;
    final env = (dotenv.env['ENV'] ?? '').toLowerCase();
    if ((email.isEmpty || password.isEmpty) && (env == 'local' || env == 'test' || env == 'testing')) {
      email = 'organizer2@example.com';
      password = email;
      emailController.text = email;
      passController.text = password;
    }
    try {
      final ok = await ref
          .read(authControllerProvider.notifier)
          .loginWithBackend(email: email, password: password, type: UserType.organizer);
      if (!mounted) return;
      if (ok) {
        try {
          if (!mounted) return;
          context.go(MyAdvertsScreen.path);
        } catch (_) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('This account is not an organization')));
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  Text('Organisation Login', style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  Text(
                    'Post and manage volunteering adverts',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  Image.asset('assets/images/logo/logo_no_bg.png', width: MediaQuery.of(context).size.width, fit: BoxFit.contain),
                  const SizedBox(height: 40),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                          ),
                          controller: emailController,
                          focusNode: emailFocusNode,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter an email';
                            }
                            if (!_isValidEmail(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) {
                            if (_formKey.currentState?.validate() ?? false) {
                              FocusScope.of(context).requestFocus(passwordFocusNode);
                            }
                          },
                        ),
                        const SizedBox(height: 8),
                        AppPasswordField(
                          controller: passController,
                          focusNode: passwordFocusNode,
                          textInputAction: TextInputAction.done,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onSubmitted: (_) {
                            if (_formKey.currentState?.validate() ?? false) {
                              _handleLogin();
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  AppButton(onPressed: _canSubmit ? _handleLogin : null, label: 'Login'),
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      onPressed: () => context.push(OrganizerSignupScreen.path),
                      child: const Text('Need an account? Sign up'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: TextButton(onPressed: () => context.push(LoginScreen.path), child: const Text('Login as Volunteer')),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
