import 'package:flutter/material.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/registration/presentation/registration_screen.dart';
import '../features/directory/presentation/directory_screen.dart';
import '../features/dashboard/presentation/member_dashboard.dart';
import '../features/dashboard/presentation/state_dashboard.dart';
import '../features/dashboard/presentation/district_dashboard.dart';
import '../features/it_wing/presentation/influencer_form.dart';
import '../features/it_wing/presentation/influencer_search.dart';

class AppRoutes {
  static const String login = '/login';
  static const String registration = '/registration';
  static const String publicDirectory = '/public-directory';
  static const String memberDashboard = '/member-dashboard';
  static const String stateDashboard = '/state-dashboard';
  static const String districtDashboard = '/district-dashboard';
  static const String influencerForm = '/influencer-form';
  static const String influencerSearch = '/influencer-search';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case registration:
        return MaterialPageRoute(builder: (_) => const RegistrationScreen());
      case publicDirectory:
        return MaterialPageRoute(builder: (_) => const DirectoryScreen());
      case memberDashboard:
        return MaterialPageRoute(builder: (_) => const MemberDashboard());
      case stateDashboard:
        return MaterialPageRoute(builder: (_) => const StateDashboard());
      case districtDashboard:
        return MaterialPageRoute(builder: (_) => const DistrictDashboard());
      case influencerForm:
        return MaterialPageRoute(builder: (_) => const InfluencerForm());
      case influencerSearch:
        return MaterialPageRoute(builder: (_) => const InfluencerSearch());
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
