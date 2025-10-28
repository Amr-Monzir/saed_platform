import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rabt_mobile/screens/volunteer/volunteer_profile_screen.dart';
import '../adverts/adverts_list_screen.dart';
import '../common/settings_screen.dart';

class VolunteerShell extends StatefulWidget {
  const VolunteerShell({super.key, required this.child});
  final Widget child;

  @override
  State<VolunteerShell> createState() => _VolunteerShellState();
}

class _VolunteerShellState extends State<VolunteerShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        unselectedItemColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
        unselectedLabelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5)),
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        onTap: (i) {
          setState(() => _index = i);
          switch (i) {
            case 0:
              context.go(AdvertsListScreen.volunteerPath);
              break;
            case 1:
              context.go(VolunteerProfileScreen.path);
              break;
            case 2:
              context.go(SettingsScreen.volunteerPath);
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.work_outline), label: 'Adverts'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
      ),
    );
  }
}


