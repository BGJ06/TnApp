import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/auth/presentation/splash_screen.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/auth_state.dart';
import '../features/registration/presentation/registration_screen.dart';
import '../features/directory/presentation/directory_screen.dart';
import '../features/directory/presentation/hierarchy_screen.dart';
import '../features/dashboard/presentation/navigation_holder.dart';
import '../features/dashboard/presentation/member_management_screen.dart';
import '../features/it_wing/presentation/influencer_form.dart';
import '../features/it_wing/presentation/influencer_search.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String registration = '/registration';
  static const String navigationHolder = '/nav-holder';
  static const String publicDirectory = '/public-directory';
  static const String hierarchyExplorer = '/hierarchy';
  static const String memberManagement = '/member-management';
  static const String influencerForm = '/influencer-form';
  static const String influencerSearch = '/influencer-search';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case registration:
        return MaterialPageRoute(builder: (_) => const RegistrationScreen());
      case navigationHolder:
        return MaterialPageRoute(builder: (_) => const NavigationHolder());
      case publicDirectory:
        return MaterialPageRoute(builder: (_) => const DirectoryScreen());
      case hierarchyExplorer:
        return MaterialPageRoute(builder: (_) => const HierarchyScreen());
      case memberManagement:
        return MaterialPageRoute(
          builder: (_) => Consumer(
            builder: (context, ref, child) {
              final authState = ref.watch(authStateProvider);
              if (authState is! AuthAuthenticated) {
                return const LoginScreen();
              }
              return const MemberManagementScreen();
            },
          ),
        );
      case influencerForm:
        return MaterialPageRoute(
          builder: (_) => Consumer(
            builder: (context, ref, child) {
              final authState = ref.watch(authStateProvider);
              if (authState is! AuthAuthenticated) {
                return const LoginScreen();
              }
              return const InfluencerForm();
            },
          ),
        );
      case influencerSearch:
        return MaterialPageRoute(
          builder: (_) => Consumer(
            builder: (context, ref, child) {
              final authState = ref.watch(authStateProvider);
              if (authState is! AuthAuthenticated) {
                return const LoginScreen();
              }
              return const InfluencerSearch();
            },
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
