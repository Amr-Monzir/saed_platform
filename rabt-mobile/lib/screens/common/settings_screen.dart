import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rabt_mobile/models/enums.dart';
import '../../state/auth/auth_providers.dart';
import '../../theme/theme_providers.dart';
import '../auth/login_screen.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const String volunteerPath = '/v/settings';
  static const String orgPath = '/o/settings';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Column(
            children: [
              SwitchListTile.adaptive(
                title: const Text('Dark mode'),
                value: ref.watch(themeControllerProvider) == ThemeMode.dark,
                onChanged: (v) {
                  final mode = v ? ThemeMode.dark : ThemeMode.light;
                  ref.read(themeControllerProvider.notifier).setMode(mode);
                },
              ),
              ListTile(
                title: const Text('Logout'),
                leading: const Icon(Icons.logout),
                onTap: () async {
                  await ref.read(authControllerProvider.notifier).logout();
                  if (!context.mounted) return;
                  context.go(LoginScreen.path);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
