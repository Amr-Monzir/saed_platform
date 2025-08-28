import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../state/auth/auth_providers.dart';
import '../../theme/theme_providers.dart';
import '../../state/prefs/user_prefs.dart';
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: ref.watch(userPrefsProvider).city,
                      decoration: const InputDecoration(labelText: 'City (for distance filter)'),
                      onChanged: (v) => ref.read(userPrefsProvider.notifier).setCity(v),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<int>(
                      value: ref.watch(userPrefsProvider).distanceMiles,
                      items: const [5, 10, 25, 50]
                          .map((e) => DropdownMenuItem(value: e, child: Text('$e miles')))
                          .toList(),
                      onChanged: (v) => ref.read(userPrefsProvider.notifier).setDistance(v),
                      decoration: const InputDecoration(labelText: 'Max distance'),
                    ),
                  ],
                ),
              ),
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


