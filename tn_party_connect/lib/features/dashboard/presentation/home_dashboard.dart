import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/presentation/auth_state.dart';
import '../../auth/data/auth_repository.dart';
import 'navigation_holder.dart';
import 'notification_center.dart';
import '../../../core/theme.dart';
import '../../../core/routes.dart';
import '../../../core/localization.dart';

class HomeDashboard extends ConsumerWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final isGuest = authState is! AuthAuthenticated;
    final user = isGuest
        ? AuthUser(
            uid: 'guest',
            fullName: 'Guest User',
            role: 'guest',
            assignedRegion: {},
          )
        : (authState as AuthAuthenticated).user;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isTamil = ref.watch(languageProvider) == AppLanguage.tamil;

    // Translation helper maps


    final roleTranslations = {
      'guest': isTamil ? 'விருந்தினர்' : 'GUEST',
      'member': isTamil ? 'உறுப்பினர்' : 'MEMBER',
      'state_president': isTamil ? 'மாநிலத் தலைவர்' : 'STATE PRESIDENT',
      'state_it_head': isTamil ? 'மாநில IT பிரிவுத் தலைவர்' : 'STATE IT HEAD',
      'district_head': isTamil ? 'மாவட்டத் தலைவர்' : 'DISTRICT HEAD',
      'taluk_head': isTamil ? 'தாலுகா தலைவர்' : 'TALUK HEAD',
      'ward_head': isTamil ? 'வார்டு தலைவர்' : 'WARD HEAD',
    };

    final district = user.assignedRegion['district'] ?? 'Tamil Nadu';
    final localizedDistrict = isTamil ? (district == 'Tamil Nadu' ? 'தமிழ்நாடு' : context.trDistrict(district, ref)) : district;
    final roleText = roleTranslations[user.role] ?? user.role.replaceAll('_', ' ').toUpperCase();

    // Reconstruct list of action buttons based on permissions
    final List<Widget> actionButtons = [
      _buildActionButton(
        context,
        icon: Icons.emergency,
        label: context.tr('sosEmergency', ref),
        color: AppTheme.emergency,
        onTap: () => ref.read(tabIndexProvider.notifier).state = isGuest ? 1 : 2, // Switch to SOS tab
      ),
      _buildActionButton(
        context,
        icon: Icons.badge_outlined,
        label: context.tr('searchLeaders', ref),
        color: Colors.indigo,
        onTap: () => ref.read(tabIndexProvider.notifier).state = 0, // Switch to Directory tab
      ),
    ];

    // Hierarchy Chart only visible if not guest AND status is approved
    if (!isGuest && user.status == 'approved') {
      actionButtons.add(
        _buildActionButton(
          context,
          icon: Icons.lan_outlined,
          label: context.tr('hierarchyChart', ref),
          color: Colors.teal,
          onTap: () => Navigator.pushNamed(context, AppRoutes.hierarchyExplorer),
        ),
      );
    }

    // IT Wing CRM (Leader Search) hidden from guest
    if (!isGuest) {
      actionButtons.add(
        _buildActionButton(
          context,
          icon: Icons.campaign_outlined,
          label: context.tr('itWingCrm', ref),
          color: Colors.brown,
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.influencerSearch);
          },
        ),
      );
    }

    // IT Wing Registration Shortcut hidden from guest
    if (!isGuest) {
      actionButtons.add(
        _buildActionButton(
          context,
          icon: Icons.app_registration_outlined,
          label: context.tr('itWingShortcutTitle', ref),
          color: Colors.teal,
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.influencerForm);
          },
        ),
      );
    }

    actionButtons.add(
      _buildActionButton(
        context,
        icon: isGuest ? Icons.lock_outline : Icons.notifications_none_outlined,
        label: context.tr('notifications', ref),
        color: isGuest ? Colors.grey : Colors.amber[800]!,
        onTap: () {
          if (isGuest) {
            Navigator.pushNamed(context, AppRoutes.login);
          } else {
            ref.read(tabIndexProvider.notifier).state = 1; // Switch to Notifications tab
          }
        },
      ),
    );

    actionButtons.add(
      _buildActionButton(
        context,
        icon: Icons.groups_outlined,
        label: context.tr('partyEvents', ref),
        color: Colors.pink,
        onTap: () {
          if (isGuest) {
            Navigator.pushNamed(context, AppRoutes.login);
          } else {
            ref.read(notificationFilterProvider.notifier).state = 'Events';
            ref.read(tabIndexProvider.notifier).state = 1;
          }
        },
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(isGuest ? context.tr('more', ref) : context.tr('appName', ref)),
        centerTitle: false,
        actions: [
          // Language Switcher Toggle button inside app bar
          TextButton.icon(
            onPressed: () {
              ref.read(languageProvider.notifier).toggleLanguage();
            },
            icon: const Icon(Icons.language, color: Colors.white, size: 18),
            label: Text(
              isTamil ? 'English' : 'தமிழ்',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 4),
          if (isGuest)
            TextButton.icon(
              icon: const Icon(Icons.login, color: Colors.white),
              label: Text(context.tr('login', ref), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.login);
              },
            )
          else
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await ref.read(authStateProvider.notifier).logout();
                Navigator.pushReplacementNamed(context, AppRoutes.navigationHolder);
              },
            )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Welcome Section
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppTheme.accent,
                  child: Text(
                    user.fullName.isNotEmpty ? user.fullName[0] : 'U',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${isTamil ? "வணக்கம்" : "Vanakkam"}, ${isTamil && (user.fullName == "Guest User" || user.fullName == "Guest") ? "விருந்தினர்" : context.trName(user.fullName, ref)}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              roleText,
                              style: const TextStyle(
                                color: AppTheme.primary,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            localizedDistrict,
                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // 2. Statistics Grid Section
            Text(
              context.tr('partyStrengthOverview', ref),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.5,
              children: [
                _buildStatCard('38', context.tr('totalDistricts', ref), Icons.map_outlined, Colors.blue),
                _buildStatCard('310', context.tr('totalTaluks', ref), Icons.location_city_outlined, Colors.orange),
                _buildStatCard('17,680', context.tr('totalVillages', ref), Icons.holiday_village_outlined, Colors.teal),
                _buildStatCard('84.2K', context.tr('activeMembers', ref), Icons.people_outline, Colors.purple),
              ],
            ),
            const SizedBox(height: 28),

            // 3. Quick Actions Section
            Text(
              context.tr('quickActions', ref),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 0.95,
              children: actionButtons,
            ),
            const SizedBox(height: 28),

            // 4. Highlight Banner (Events Feed)
            InkWell(
              onTap: () {
                if (isGuest) {
                  Navigator.pushNamed(context, AppRoutes.login);
                } else {
                  ref.read(notificationFilterProvider.notifier).state = 'Announcements';
                  ref.read(tabIndexProvider.notifier).state = 1; // Switch to Notifications tab
                }
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.event_note, size: 40, color: AppTheme.accent),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.tr('upcomingConference', ref),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            context.tr('conferenceDetails', ref),
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String count, String title, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(count, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                Icon(icon, color: color, size: 24),
              ],
            ),
            Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppTheme.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.15)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }


}
