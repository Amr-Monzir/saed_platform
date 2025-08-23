import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
        onTap: (i) {
          setState(() => _index = i);
          switch (i) {
            case 0:
              context.go(MyAdvertsScreen.path);
              break;
            case 1:
              context.go(OrganizerProfileScreen.path);
              break;
            case 2:
              context.go(SettingsScreen.orgPath);
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list_alt_outlined), label: 'My Adverts'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
      ),
    );
  }
}


