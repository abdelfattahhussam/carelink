import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../config/rbac_config.dart';
import 'route_permissions.dart';
import '../../data/models/medicine_model.dart';
import '../../presentation/blocs/auth/auth_bloc.dart';
import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/onboarding/onboarding_screen.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/register_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';
import '../../presentation/screens/onboarding/language_selection_screen.dart';
import '../../presentation/screens/dashboard/pharmacist_dashboard_screen.dart';
import '../../presentation/screens/home/home_router_screen.dart';
import '../../presentation/screens/home/user_home_screen.dart';
import '../../presentation/screens/donation/donation_screen.dart';
import '../../presentation/screens/donation/my_donations_screen.dart';
import '../../presentation/screens/medicine/medicine_list_screen.dart';
import '../../presentation/screens/request/request_screen.dart';
import '../../presentation/screens/request/my_requests_screen.dart';
import '../../presentation/screens/pharmacist/pharmacist_review_screen.dart';
import '../../presentation/screens/pharmacist/manage_requests_screen.dart';
import '../../presentation/screens/qr/qr_display_screen.dart';
import '../../presentation/screens/qr/qr_scan_screen.dart';
import '../../presentation/screens/notifications/notifications_screen.dart';

/// Helper class to make GoRouter react to BLoC state changes
class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<AuthState> _subscription;

  GoRouterRefreshStream(Stream<AuthState> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

/// GoRouter configuration with all application routes
class AppRouter {
  AppRouter._();

  static GoRouter getRouter(AuthBloc authBloc) {
    return GoRouter(
      initialLocation: '/splash',
      refreshListenable: GoRouterRefreshStream(authBloc.stream),
      redirect: (context, state) {
        final authState = authBloc.state;
        if (state.matchedLocation == '/splash') {
          return null;
        }

        final bool publicRoute =
            state.matchedLocation == '/login' ||
            state.matchedLocation == '/register' ||
            state.matchedLocation == '/onboarding' ||
            state.matchedLocation == '/language-selection';

        if (authState is AuthInitial || authState is AuthLoading) {
          return null;
        }

        if (authState is AuthUnauthenticated) {
          if (publicRoute) return null;
          return '/login';
        }

        if (authState is AuthAuthenticated) {
          final user = authState.user;

          if (publicRoute || state.matchedLocation == '/home') {
            return RBACConfig.homeRouteFor(user.role);
          }

          final path = state.matchedLocation;

          // Check permissions for the current path
          for (final entry in routePermissions.entries) {
            if (path.startsWith(entry.key)) {
              if (!RBACConfig.can(user, entry.value)) {
                return RBACConfig.homeRouteFor(user.role);
              }
            }
          }
        }

        return null;
      },
      routes: [
        GoRoute(path: '/', redirect: (context, state) => '/splash'),
        GoRoute(
          path: '/splash',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/language-selection',
          builder: (context, state) => const LanguageSelectionScreen(),
        ),

        // Home Router (now just a fallback/loading shell)
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeRouterScreen(),
        ),

        // Role specific homes
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const PharmacistDashboardScreen(),
        ),
        // Unified user home
        GoRoute(
          path: '/user-home',
          builder: (context, state) => const UserHomeScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),

        GoRoute(
          path: '/donate',
          builder: (context, state) => const DonationScreen(),
        ),
        GoRoute(
          path: '/my-donations',
          builder: (context, state) => const MyDonationsScreen(),
        ),
        GoRoute(
          path: '/medicines',
          builder: (context, state) => const MedicineListScreen(),
        ),
        GoRoute(
          path: '/request/:id',
          builder: (context, state) {
            final medicine = state.extra as MedicineModel?;
            return RequestScreen(medicine: medicine);
          },
        ),
        GoRoute(
          path: '/my-requests',
          builder: (context, state) => const MyRequestsScreen(),
        ),
        GoRoute(
          path: '/review',
          builder: (context, state) => const PharmacistReviewScreen(),
        ),
        GoRoute(
          path: '/manage-requests',
          builder: (context, state) => const ManageRequestsScreen(),
        ),
        GoRoute(
          path: '/qr-display',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>? ?? {};
            return QrDisplayScreen(
              qrData: extra['qrCode'] as String?,
              itemId: extra['id'] as String?,
              itemType: extra['type'] as String?,
            );
          },
        ),
        GoRoute(
          path: '/qr-scan',
          builder: (context, state) => const QrScanScreen(),
        ),
        GoRoute(
          path: '/notifications',
          builder: (context, state) => const NotificationsScreen(),
        ),
      ],
    );
  }
}
