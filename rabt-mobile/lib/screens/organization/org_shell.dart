import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rabt_mobile/screens/organization/received_applications/organizer_received_applications.dart';
import 'my_adverts_screen.dart';
import 'organizer_profile_screen.dart';
import '../common/settings_screen.dart';

class OrgShell extends StatefulWidget {
  const OrgShell({super.key, required this.child});
  final Widget child;

  @override
  State<OrgShell> createState() => _OrgShellState();
}

class _OrgShellState extends State<OrgShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        unselectedItemColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
        unselectedLabelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5)),
        type: BottomNavigationBarType.shifting,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        onTap: (i) {
          setState(() => _index = i);
          switch (i) {
            case 0:
              context.go(MyAdvertsScreen.path);
              break;
            case 1:
              context.go(OrganizerReceivedApplications.path);
              break;
            case 2:
              context.go(OrganizerProfileScreen.organizerPathTemplate);
              break;
            case 3:
              context.go(SettingsScreen.orgPath);
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list_alt_outlined), label: 'My Adverts'),
          BottomNavigationBarItem(icon: Icon(Icons.folder_copy_outlined), label: 'Applications'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
      ),
    );
  }
}
