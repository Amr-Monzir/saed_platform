import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rabt_mobile/models/enums.dart';
import '../../state/auth/auth_providers.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_password_field.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../adverts/adverts_list_screen.dart';
import 'signup_volunteer_screen.dart';
import 'login_organizer_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  static const String path = '/login';

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
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
    try {
      await ref
          .read(authControllerProvider.notifier)
          .loginWithBackend(email: email, password: password, type: UserType.volunteer);
      if (!mounted) return;
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
                minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  Text('Voluneer login', style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  Text(
                    'Connect with organisations. Volunteer for Palestine.',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  Image.asset('assets/images/logo/logo_no_bg.png', width: MediaQuery.of(context).size.width, fit: BoxFit.contain),
                  const SizedBox(height: 40),
                  // Volunteer login only (switching to org login via link below)
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
                  AppButton(
                    onPressed: _canSubmit ? _handleLogin : null,
                    label: 'Login',
                  ),
                  const SizedBox(height: 12),
                  AppButton(
                    onPressed: () => context.go(AdvertsListScreen.guestPath),
                    label: 'Continue as Guest',
                    variant: AppButtonVariant.outline,
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      onPressed: () => context.push(SignupVolunteerScreen.path),
                      child: const Text('Need an account? Sign up'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: TextButton(
                      onPressed: () => context.push(OrganizerLoginScreen.path),
                      child: const Text('Login as Organization'),
                    ),
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
