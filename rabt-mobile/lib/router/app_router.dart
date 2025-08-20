import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../screens/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/login_organizer_screen.dart';
import '../screens/auth/signup_organizer_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/volunteer/volunteer_shell.dart';
import '../screens/organization/org_shell.dart';
import '../screens/jobs/jobs_list_screen.dart';
import '../screens/common/settings_screen.dart';
import '../screens/volunteer/profile_setup_screen.dart';
import '../screens/organization/create_job_screen.dart';
import '../screens/organization/my_jobs_screen.dart';
import '../state/auth/auth_providers.dart';
import '../screens/jobs/job_detail_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authControllerProvider);
  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final loggedIn = auth.session != null;
      final isOrg = auth.session?.userRole == UserRole.organization;
      final loggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/signup';
      if (!loggedIn && state.matchedLocation.startsWith('/v')) return '/login';
      if (!loggedIn && state.matchedLocation.startsWith('/o')) return '/login';
      if (loggedIn && loggingIn) return isOrg ? '/o/my-jobs' : '/v/jobs';
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/login/organization',
        builder: (context, state) => const OrganizerLoginScreen(),
      ),
      GoRoute(
        path: '/signup/organization',
        builder: (context, state) => const OrganizerSignupScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      // Guest jobs listing
      GoRoute(
        path: '/jobs',
        builder: (context, state) => const JobsListScreen(),
      ),
      GoRoute(
        path: '/jobs/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return JobDetailScreen(id: id);
        },
      ),
      // Volunteer app shell
      ShellRoute(
        builder: (context, state, child) => VolunteerShell(child: child),
        routes: [
          GoRoute(
            path: '/v/jobs',
            builder: (context, state) => const JobsListScreen(),
          ),
          GoRoute(
            path: '/v/profile-setup',
            builder: (context, state) => const VolunteerProfileSetupScreen(),
          ),
          GoRoute(
            path: '/v/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: '/v/profile',
            builder: (context, state) => const PlaceholderScreen(title: 'Profile'),
          ),
        ],
      ),
      // Organization app shell
      ShellRoute(
        builder: (context, state, child) => OrgShell(child: child),
        routes: [
          GoRoute(
            path: '/o/my-jobs',
            builder: (context, state) => const MyJobsScreen(),
          ),
          GoRoute(
            path: '/o/create-job',
            builder: (context, state) => const CreateJobScreen(),
          ),
          GoRoute(
            path: '/o/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Route not found: ${state.uri}')),
    ),
    debugLogDiagnostics: true,
  );
});

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title)),
    );
  }
}


