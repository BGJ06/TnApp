import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/presentation/auth_state.dart';
import 'navigation_holder.dart';
import '../../../core/theme.dart';
import '../../../core/routes.dart';

class HomeDashboard extends ConsumerWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    if (authState is! AuthAuthenticated) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final user = authState.user;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('TN Party Connect'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authStateProvider.notifier).logout();
              Navigator.pushReplacementNamed(context, AppRoutes.login);
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
                    user.fullName[0],
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vanakkam, ${user.fullName}',
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
                              user.role.replaceAll('_', ' ').toUpperCase(),
                              style: const TextStyle(
                                color: AppTheme.primary,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            user.assignedRegion['district'] ?? 'Tamil Nadu',
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
            const Text(
              'Party Strength Overview',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
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
                _buildStatCard('38', 'Total Districts', Icons.map_outlined, Colors.blue),
                _buildStatCard('310', 'Total Taluks', Icons.location_city_outlined, Colors.orange),
                _buildStatCard('17,680', 'Total Villages', Icons.holiday_village_outlined, Colors.teal),
                _buildStatCard('84.2K', 'Active Members', Icons.people_outline, Colors.purple),
              ],
            ),
            const SizedBox(height: 28),

            // 3. Quick Actions Section
            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 0.95,
              children: [
                _buildActionButton(
                  context,
                  icon: Icons.emergency,
                  label: 'SOS Emergency',
                  color: AppTheme.emergency,
                  onTap: () => ref.read(tabIndexProvider.notifier).state = 2, // Switch to SOS tab
                ),
                _buildActionButton(
                  context,
                  icon: Icons.badge_outlined,
                  label: 'Search Leaders',
                  color: Colors.indigo,
                  onTap: () => ref.read(tabIndexProvider.notifier).state = 1, // Switch to Directory tab
                ),
                _buildActionButton(
                  context,
                  icon: Icons.lan_outlined,
                  label: 'Hierarchy Chart',
                  color: Colors.teal,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.hierarchyExplorer),
                ),
                _buildActionButton(
                  context,
                  icon: Icons.campaign_outlined,
                  label: 'IT Wing CRM',
                  color: Colors.brown,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.influencerSearch),
                ),
                _buildActionButton(
                  context,
                  icon: Icons.notifications_none_outlined,
                  label: 'Notifications',
                  color: Colors.amber[800]!,
                  onTap: () => ref.read(tabIndexProvider.notifier).state = 3, // Switch to Notifications tab
                ),
                _buildActionButton(
                  context,
                  icon: Icons.groups_outlined,
                  label: 'Party Events',
                  color: Colors.pink,
                  onTap: () => _showEventsDialog(context),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // 4. Highlight Banner (Events Feed)
            Container(
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
                      children: const [
                        Text(
                          'Upcoming State Conference',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'June 15, 2026 - Chennai Trade Centre',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
                ],
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

  void _showEventsDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Party Events Feed',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.campaign, color: Colors.blue),
                title: const Text('Statewide IT Wing BootCamp'),
                subtitle: const Text('Coimbatore - June 10, 2026'),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.volunteer_activism, color: Colors.red),
                title: const Text('Blood Donation Drive'),
                subtitle: const Text('Madurai North - June 12, 2026'),
              ),
            ],
          ),
        );
      },
    );
  }
}
