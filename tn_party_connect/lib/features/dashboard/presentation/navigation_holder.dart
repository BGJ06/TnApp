import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/presentation/auth_state.dart';
import '../../../core/localization.dart';
import '../../../core/theme.dart';
import 'home_dashboard.dart';
import '../../directory/presentation/directory_screen.dart';
import 'member_dashboard.dart'; // Emergency SOS Page
import 'notification_center.dart';
import 'profile_screen.dart';
import 'state_dashboard.dart';
import 'district_dashboard.dart';

// Unified State Provider to sync tab index reactively
final tabIndexProvider = StateProvider<int>((ref) => 0);

class NavigationHolder extends ConsumerWidget {
  const NavigationHolder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final currentIndex = ref.watch(tabIndexProvider);

    if (authState is! AuthAuthenticated) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final user = authState.user;
    final isLeader = user.role != 'member';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final List<Widget> screens = [
      const HomeDashboard(),
      const DirectoryScreen(),
      const MemberDashboard(),
      const NotificationCenter(),
      const ProfileScreen(),
    ];

    if (isLeader) {
      if (user.role == 'state_president' || user.role == 'state_it_head') {
        screens.add(const StateDashboard());
      } else {
        screens.add(const DistrictDashboard());
      }
    }

    final navHome = context.tr('welcome', ref);
    final navDir = context.tr('directory', ref);
    final navSOS = context.tr('emergency', ref);
    final navNotif = context.tr('notifications', ref);
    final navProfile = context.tr('profile', ref);
    final navDashboard = context.tr('dashboard', ref);

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          ref.read(tabIndexProvider.notifier).state = index;
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: navHome,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.map_outlined),
            activeIcon: const Icon(Icons.map),
            label: navDir,
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              radius: 18,
              backgroundColor: isDark ? AppTheme.emergency : AppTheme.emergency.withOpacity(0.1),
              child: const Icon(Icons.emergency, color: Colors.white, size: 20),
            ),
            label: navSOS,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.notifications_none_outlined),
            activeIcon: const Icon(Icons.notifications),
            label: navNotif,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
            label: navProfile,
          ),
          if (isLeader)
            BottomNavigationBarItem(
              icon: const Icon(Icons.admin_panel_settings_outlined),
              activeIcon: const Icon(Icons.admin_panel_settings),
              label: navDashboard,
            ),
        ],
      ),
    );
  }
}
