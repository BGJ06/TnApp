import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/presentation/auth_state.dart';
import '../../auth/data/auth_repository.dart';
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

class NavigationHolder extends ConsumerStatefulWidget {
  const NavigationHolder({super.key});

  @override
  ConsumerState<NavigationHolder> createState() => _NavigationHolderState();
}

class _NavigationHolderState extends ConsumerState<NavigationHolder> {
  DateTime? _lastPressedAt;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final currentIndex = ref.watch(tabIndexProvider);

    final isGuest = authState is! AuthAuthenticated;
    final user = isGuest
        ? AuthUser(
            uid: 'guest',
            fullName: 'Guest User',
            role: 'guest',
            assignedRegion: {},
          )
        : (authState as AuthAuthenticated).user;

    final isLeader = !isGuest && user.role != 'member';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final List<Widget> screens = [];
    final List<BottomNavigationBarItem> navItems = [];

    if (isGuest) {
      // 0: Directory
      screens.add(const DirectoryScreen());
      navItems.add(BottomNavigationBarItem(
        icon: const Icon(Icons.map_outlined),
        activeIcon: const Icon(Icons.map),
        label: context.tr('directory', ref),
      ));

      // 1: Emergency (Middle of 3 tabs)
      screens.add(const MemberDashboard());
      navItems.add(BottomNavigationBarItem(
        icon: CircleAvatar(
          radius: 18,
          backgroundColor: isDark ? AppTheme.emergency : AppTheme.emergency.withOpacity(0.1),
          child: const Icon(Icons.emergency, color: Colors.white, size: 20),
        ),
        label: context.tr('emergency', ref),
      ));

      // 2: More (Welcome page/HomeDashboard)
      screens.add(const HomeDashboard());
      navItems.add(BottomNavigationBarItem(
        icon: const Icon(Icons.more_horiz_outlined),
        activeIcon: const Icon(Icons.more_horiz),
        label: context.tr('more', ref),
      ));
    } else {
      // 0: Directory
      screens.add(const DirectoryScreen());
      navItems.add(BottomNavigationBarItem(
        icon: const Icon(Icons.map_outlined),
        activeIcon: const Icon(Icons.map),
        label: context.tr('directory', ref),
      ));

      // 1: Notifications
      screens.add(const NotificationCenter());
      navItems.add(BottomNavigationBarItem(
        icon: const Icon(Icons.notifications_none_outlined),
        activeIcon: const Icon(Icons.notifications),
        label: context.tr('notifications', ref),
      ));

      // 2: Emergency (Middle of 5 tabs)
      screens.add(const MemberDashboard());
      navItems.add(BottomNavigationBarItem(
        icon: CircleAvatar(
          radius: 18,
          backgroundColor: isDark ? AppTheme.emergency : AppTheme.emergency.withOpacity(0.1),
          child: const Icon(Icons.emergency, color: Colors.white, size: 20),
        ),
        label: context.tr('emergency', ref),
      ));

      // 3: Profile
      screens.add(const ProfileScreen());
      navItems.add(BottomNavigationBarItem(
        icon: const Icon(Icons.person_outline),
        activeIcon: const Icon(Icons.person),
        label: context.tr('profile', ref),
      ));

      // 4: Welcome (Welcome page/HomeDashboard)
      screens.add(const HomeDashboard());
      navItems.add(BottomNavigationBarItem(
        icon: const Icon(Icons.home_outlined),
        activeIcon: const Icon(Icons.home),
        label: context.tr('welcome', ref),
      ));

      // 5: Dashboard (if leader)
      if (isLeader) {
        if (user.role == 'state_president' || user.role == 'state_it_head') {
          screens.add(const StateDashboard());
        } else {
          screens.add(const DistrictDashboard());
        }
        navItems.add(BottomNavigationBarItem(
          icon: const Icon(Icons.admin_panel_settings_outlined),
          activeIcon: const Icon(Icons.admin_panel_settings),
          label: context.tr('dashboard', ref),
        ));
      }
    }

    final maxIndex = isGuest ? 2 : (isLeader ? 5 : 4);
    int safeIndex = currentIndex;
    if (safeIndex > maxIndex) {
      safeIndex = 0;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(tabIndexProvider.notifier).state = 0;
      });
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) return;

        final now = DateTime.now();
        final backButtonHasNotBeenPressedOrTimeHasExpired =
            _lastPressedAt == null || now.difference(_lastPressedAt!) > const Duration(seconds: 2);

        if (backButtonHasNotBeenPressedOrTimeHasExpired) {
          _lastPressedAt = now;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.exit_to_app, color: Colors.white, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    context.tr('pressBackAgainToExit', ref),
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
                  ),
                ],
              ),
              behavior: SnackBarBehavior.floating,
              backgroundColor: AppTheme.emergency.withAlpha(230),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              duration: const Duration(seconds: 2),
            ),
          );
        } else {
          // Close the app programmatically
          await SystemNavigator.pop();
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: safeIndex,
          children: screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: safeIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            ref.read(tabIndexProvider.notifier).state = index;
          },
          items: navItems,
        ),
      ),
    );
  }
}
