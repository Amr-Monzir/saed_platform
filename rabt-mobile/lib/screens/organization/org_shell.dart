import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
              context.go('/o/my-jobs');
              break;
            case 1:
              context.go('/o/create-job');
              break;
            case 2:
              context.go('/o/settings');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list_alt_outlined), label: 'My Jobs'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: 'Create Job'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
      ),
    );
  }
}


