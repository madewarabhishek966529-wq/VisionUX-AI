import 'package:go_router/go_router.dart';
import '../features/authentication/authentication_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/upload/upload_screen.dart';
import '../features/analysis/analysis_screen.dart';
import '../features/comparison/comparison_screen.dart';
import '../features/reports/reports_screen.dart';
import '../features/history/project_history_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/settings/settings_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/dashboard',
  routes: [
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthenticationScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/upload',
      builder: (context, state) => const UploadScreen(),
    ),
    GoRoute(
      path: '/analysis',
      builder: (context, state) => const AnalysisScreen(),
    ),
    GoRoute(
      path: '/comparison',
      builder: (context, state) => const ComparisonScreen(),
    ),
    GoRoute(
      path: '/reports',
      builder: (context, state) => const ReportsScreen(),
    ),
    GoRoute(
      path: '/history',
      builder: (context, state) => const ProjectHistoryScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);
