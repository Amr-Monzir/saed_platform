import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rabt_mobile/models/enums.dart';
import 'package:rabt_mobile/screens/adverts/advert_detail_screen.dart';
import 'package:rabt_mobile/screens/adverts/adverts_list_screen.dart';
import 'package:rabt_mobile/screens/auth/login_organizer_screen.dart';
import 'package:rabt_mobile/screens/auth/login_screen.dart';
import 'package:rabt_mobile/screens/auth/signup_organizer_screen.dart';
import 'package:rabt_mobile/screens/auth/signup_volunteer_screen.dart';
import 'package:rabt_mobile/screens/common/settings_screen.dart';
import 'package:rabt_mobile/screens/guest/guest_shell.dart';
import 'package:rabt_mobile/screens/organization/create_advert/create_advert_wizard.dart';
import 'package:rabt_mobile/screens/organization/my_adverts_screen.dart';
import 'package:rabt_mobile/screens/organization/org_shell.dart';
import 'package:rabt_mobile/screens/organization/organizer_profile_screen.dart';
import 'package:rabt_mobile/screens/organization/received_applications/advert_received_applications.dart';
import 'package:rabt_mobile/screens/organization/received_applications/organizer_received_applications.dart';
import 'package:rabt_mobile/screens/splash_screen.dart';
import 'package:rabt_mobile/screens/volunteer/profile_setup_screen.dart';
import 'package:rabt_mobile/screens/volunteer/volunteer_profile_screen.dart';
import 'package:rabt_mobile/screens/volunteer/volunteer_shell.dart';
import 'package:rabt_mobile/state/auth/auth_providers.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authControllerProvider);
  return GoRouter(
    initialLocation: SplashScreen.path,
    redirect: (context, state) {
      final loggedIn = auth.value != null;
      final isOrg = auth.value?.userType == UserType.organizer;
      final loggingIn = state.matchedLocation == LoginScreen.path || state.matchedLocation == SignupVolunteerScreen.path;
      if (state.matchedLocation == SplashScreen.path) {
        if (!loggedIn && !loggingIn) return AdvertsListScreen.guestPath;
        return isOrg ? MyAdvertsScreen.path : AdvertsListScreen.volunteerPath;
      }
      if (!loggedIn && state.matchedLocation.startsWith('/v')) return LoginScreen.path;
      if (!loggedIn && state.matchedLocation.startsWith('/o')) return LoginScreen.path;
      if (loggedIn && loggingIn) return isOrg ? MyAdvertsScreen.path : AdvertsListScreen.volunteerPath;
      return null;
    },
    routes: [
      GoRoute(path: SplashScreen.path, builder: (context, state) => const SplashScreen()),
      GoRoute(path: LoginScreen.path, builder: (context, state) => const LoginScreen()),
      GoRoute(path: OrganizerLoginScreen.path, builder: (context, state) => const OrganizerLoginScreen()),
      GoRoute(path: OrganizerSignupScreen.path, builder: (context, state) => const OrganizerSignupScreen()),
      GoRoute(path: SignupVolunteerScreen.path, builder: (context, state) => const SignupVolunteerScreen()),

      // Guest adverts listing
      ShellRoute(
        builder: (context, state, child) => GuestShell(child: child),
        routes: [
          GoRoute(
            path: AdvertsListScreen.guestPath,
            builder: (context, state) => const AdvertsListScreen(),
            routes: [
              GoRoute(
                path: AdvertDetailScreen.pathTemplate,
                builder: (context, state) {
                  final id = int.parse(state.pathParameters['id']!);
                  return AdvertDetailScreen(id: id);
                },
              ),
            ],
          ),
        ],
      ),
      // Volunteer app shell
      ShellRoute(
        builder: (context, state, child) => VolunteerShell(child: child),
        routes: [
          GoRoute(
            path: AdvertsListScreen.volunteerPath,
            builder: (context, state) => const AdvertsListScreen(),
            routes: [
              GoRoute(
                path: AdvertDetailScreen.pathTemplate,
                builder: (context, state) {
                  final id = int.parse(state.pathParameters['id']!);
                  return AdvertDetailScreen(id: id);
                },
                routes: [
                  GoRoute(
                    path: OrganizerProfileScreen.volunteerPathTemplate,
                    builder: (context, state) {
                      final advertId = int.parse(state.pathParameters['id']!);
                      final orgId = int.parse(state.pathParameters['orgId']!);
                      return OrganizerProfileScreen(orgId: orgId, advertId: advertId);
                    },
                  ),
                ],
              ),
            ],
          ),
          GoRoute(path: VolunteerProfileSetupScreen.path, builder: (context, state) => const VolunteerProfileSetupScreen()),
          GoRoute(path: SettingsScreen.volunteerPath, builder: (context, state) => const SettingsScreen()),
          GoRoute(path: VolunteerProfileScreen.path, builder: (context, state) => const VolunteerProfileScreen()),
        ],
      ),
      // Organization app shell
      ShellRoute(
        builder: (context, state, child) => OrgShell(child: child),
        routes: [
          GoRoute(
            path: MyAdvertsScreen.path,
            builder: (context, state) => const MyAdvertsScreen(),
            routes: [
              GoRoute(path: CreateAdvertWizard.pathTemplate, builder: (context, state) => const CreateAdvertWizard()),
              GoRoute(
                path: AdvertDetailScreen.pathTemplate,
                builder: (context, state) {
                  final advertId = int.tryParse(state.pathParameters['id']!);
                  if (advertId == null) {
                    return const Scaffold(body: Center(child: Text('Advert not found')));
                  }
                  return AdvertDetailScreen(id: advertId);
                },
                routes: [
                  GoRoute(
                    path: AdvertReceivedApplications.pathTemplate,
                    builder: (context, state) {
                      final advertId = int.parse(state.pathParameters['id']!);
                      return AdvertReceivedApplications(id: advertId);
                    },
                  ),
                ],
              ),
            ],
          ),
          GoRoute(path: OrganizerReceivedApplications.path, builder: (context, state) => const OrganizerReceivedApplications()),
          GoRoute(
            path: OrganizerProfileScreen.organizerPathTemplate,
            builder: (context, state) => const OrganizerProfileScreen(),
          ),
          GoRoute(path: SettingsScreen.orgPath, builder: (context, state) => const SettingsScreen()),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(body: Center(child: Text('Route not found: ${state.uri}'))),
    debugLogDiagnostics: true,
  );
});

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(title)), body: Center(child: Text(title)));
  }
}
