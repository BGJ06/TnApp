import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/presentation/auth_state.dart';
import '../../sos/presentation/sos_state.dart';
import '../../../core/theme.dart';
import '../../../core/routes.dart';
import '../../../core/localization.dart';

class StateDashboard extends ConsumerWidget {
  const StateDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final sosAlerts = ref.watch(sosProvider);

    if (authState is! AuthAuthenticated) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final user = authState.user;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isTamil = ref.watch(languageProvider) == AppLanguage.tamil;

    // Separate active and resolved alerts
    final activeAlerts =
        sosAlerts.where((a) => a.status != 'resolved').toList();
    final resolvedAlerts =
        sosAlerts.where((a) => a.status == 'resolved').toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('stateHdTitle', ref)),
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
            // Banner Section
            Text(
              '${isTamil ? "வணக்கம்" : "Vanakkam"}, ${context.trName(user.fullName, ref)}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              context.tr('stateCommandSubtitle', ref),
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 24),

            // Statistics Grid (Aggregate Metrics)
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.4,
              children: [
                _buildStatCard(
                  context,
                  title: context.tr('totalMembers', ref),
                  value: '48,256',
                  icon: Icons.people,
                  color: Colors.blue,
                ),
                _buildStatCard(
                  context,
                  title: context.tr('activeSOS', ref),
                  value: '${activeAlerts.length}',
                  icon: Icons.emergency,
                  color: Colors.red,
                ),
                _buildStatCard(
                  context,
                  title: context.tr('itWings', ref),
                  value: '842',
                  icon: Icons.campaign,
                  color: Colors.teal,
                ),
                _buildStatCard(
                  context,
                  title: context.tr('districtsReached', ref),
                  value: '38/38',
                  icon: Icons.map,
                  color: Colors.orange,
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Emergency SOS Alerts Queue
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.tr('emergencyMonitoring', ref),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (activeAlerts.isNotEmpty)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${activeAlerts.length} ${context.tr('critical', ref)}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (activeAlerts.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: Text(
                        context.tr('noActiveSos', ref),
                        style: const TextStyle(color: Colors.grey)),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: activeAlerts.length,
                itemBuilder: (context, index) {
                  final alert = activeAlerts[index];
                  final statusText = isTamil
                      ? (alert.status == 'active' ? 'செயலில்' : 'அங்கீகரிக்கப்பட்டது')
                      : alert.status.toUpperCase();
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                          color: Colors.red.withValues(alpha: 0.5), width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                context.trName(alert.memberName, ref),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Text(
                                statusText,
                                style: TextStyle(
                                  color: alert.status == 'active'
                                      ? Colors.red
                                      : Colors.orange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.phone,
                                  size: 16, color: Colors.grey),
                              const SizedBox(width: 6),
                              Text(alert.contactNumber,
                                  style: const TextStyle(color: Colors.grey)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  size: 16, color: Colors.grey),
                              const SizedBox(width: 6),
                              Text(
                                'GPS: ${alert.latitude.toStringAsFixed(4)}, ${alert.longitude.toStringAsFixed(4)}',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              if (alert.status == 'active')
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      ref
                                          .read(sosProvider.notifier)
                                          .updateAlertStatus(
                                              alert.id, 'acknowledged');
                                    },
                                    icon: const Icon(Icons.check, size: 16),
                                    label: Text(context.tr('acknowledge', ref)),
                                    style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.orange),
                                  ),
                                ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    ref
                                        .read(sosProvider.notifier)
                                        .updateAlertStatus(
                                            alert.id, 'resolved');
                                  },
                                  icon: const Icon(Icons.done_all,
                                      size: 16, color: Colors.white),
                                  label: Text(context.tr('markResolved', ref)),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            const SizedBox(height: 32),

            // IT & Influencer Portal Navigation Banner
            Card(
              color: isDark
                  ? AppTheme.surfaceDark
                  : AppTheme.primary.withValues(alpha: 0.08),
              child: ListTile(
                contentPadding: const EdgeInsets.all(20),
                leading: const Icon(Icons.troubleshoot,
                    size: 40, color: Colors.teal),
                title: Text(
                  context.tr('itWingSearchMatrix', ref),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                subtitle: Text(context.tr('itWingSearchDesc', ref)),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.influencerSearch);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 28),
                Text(
                  value,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Text(
              title,
              style: TextStyle(
                  color: isDark ? Colors.white60 : Colors.grey[700],
                  fontSize: 12,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
