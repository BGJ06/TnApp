import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/presentation/auth_state.dart';
import '../../sos/presentation/sos_state.dart';
import '../../../core/theme.dart';
import '../../../core/routes.dart';

class MemberDashboard extends ConsumerStatefulWidget {
  const MemberDashboard({super.key});

  @override
  ConsumerState<MemberDashboard> createState() => _MemberDashboardState();
}

class _MemberDashboardState extends ConsumerState<MemberDashboard> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final sosAlerts = ref.watch(sosProvider);

    if (authState is! AuthAuthenticated) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final user = authState.user;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Filter alerts triggered by this specific member
    final myAlerts = sosAlerts.where((a) => a.memberUid == user.uid).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Member Portal'),
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
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // User Greeting & Welcome Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: isDark ? AppTheme.secondaryDark : AppTheme.primaryLight,
                      child: Text(
                        user.fullName[0],
                        style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Vanakkam, ${user.fullName}',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Region: ${user.assignedRegion['district'] ?? "Tamil Nadu"}, ${user.assignedRegion['taluk'] ?? ""}',
                            style: const TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Emergency SOS Panic Action Card
            Center(
              child: Column(
                children: [
                  const Text(
                    'EMERGENCY SOS ASSISTANCE',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Pressing this button shares your location and alerts the ward/taluk leadership instantly.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 32),
                  
                  // Pulsing SOS button
                  ScaleTransition(
                    scale: _pulseAnimation,
                    child: Container(
                      height: 160,
                      width: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.4),
                            blurRadius: 20,
                            spreadRadius: 10,
                          )
                        ],
                        gradient: AppTheme.sosGradient,
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: const CircleBorder(),
                        ),
                        onPressed: () async {
                          await ref.read(sosProvider.notifier).raiseSOS(
                            user.uid,
                            user.fullName,
                            user.mobileNumber ?? '+919999999999',
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('EMERGENCY ALERT BROADCASTED SUCCESSFULY!'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        },
                        child: const Text(
                          'SOS',
                          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),

            // Member-Specific Active Alerts Listing
            if (myAlerts.isNotEmpty) ...[
              const Text(
                'My Active SOS Logs',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: myAlerts.length,
                itemBuilder: (context, index) {
                  final alert = myAlerts[index];
                  final isResolved = alert.status == 'resolved';
                  return Card(
                    color: isResolved ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.05),
                    child: ListTile(
                      leading: Icon(
                        isResolved ? Icons.check_circle : Icons.warning,
                        color: isResolved ? Colors.green : Colors.red,
                      ),
                      title: Text('SOS Alert Raised'),
                      subtitle: Text(
                        'Time: ${alert.timestamp.hour}:${alert.timestamp.minute.toString().padLeft(2, '0')}\nCoords: ${alert.latitude.toStringAsFixed(4)}, ${alert.longitude.toStringAsFixed(4)}',
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isResolved ? Colors.green : Colors.orange,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          alert.status.toUpperCase(),
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],

            // IT Wing Navigation Shortcut
            Card(
              color: isDark ? const Color(0xFF152A22) : AppTheme.accentLight.withOpacity(0.4),
              child: ListTile(
                leading: const Icon(Icons.campaign, color: Colors.teal),
                title: const Text('IT Wing / Influencer Registry', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Register your social media reach and technical design skills.'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.influencerForm);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
