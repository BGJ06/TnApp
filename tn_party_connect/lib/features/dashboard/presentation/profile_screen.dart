import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/presentation/auth_state.dart';
import '../../../core/theme.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    if (authState is! AuthAuthenticated) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final user = authState.user;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Generated static details for demonstration
    final mockDob = user.role == 'member' ? '12/08/1994' : '05/04/1982';
    final mockEmail = user.role == 'member' ? 'member@gmail.com' : '${user.uid}@tnpartyconnect.org';
    final mockMemberId = 'TN-${user.role.substring(0,2).toUpperCase()}-9841-2026';

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Membership ID Card Layout (Enterprise Gold/Red Badge)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'TN PARTY CONNECT',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.accent,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'ACTIVE MEMBER',
                          style: TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        child: Text(
                          user.fullName[0],
                          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.fullName,
                              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              user.role.replaceAll('_', ' ').toUpperCase(),
                              style: const TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('MEMBERSHIP ID', style: TextStyle(color: Colors.white60, fontSize: 9)),
                          Text(mockMemberId, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('REGION', style: TextStyle(color: Colors.white60, fontSize: 9)),
                          Text(
                            user.assignedRegion['district'] ?? 'Tamil Nadu',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 28),

            // 2. Personal Information Card
            _buildCardSection(
              context,
              title: 'Personal Information',
              items: [
                _buildInfoRow('Full Name', user.fullName),
                _buildInfoRow('Date of Birth', mockDob),
                _buildInfoRow('Primary Mobile', user.mobileNumber ?? '+919999999999'),
                _buildInfoRow('Email Address', mockEmail),
                _buildInfoRow('State Scope', 'Tamil Nadu, India'),
              ],
            ),
            const SizedBox(height: 20),

            // 3. Status Card
            _buildCardSection(
              context,
              title: 'Membership Integrity',
              items: [
                _buildInfoRow('Joined Date', '03/06/2026'),
                _buildInfoRow('Validation Status', 'APPROVED', valueColor: Colors.green),
                _buildInfoRow('Security Level', user.role == 'member' ? 'L1 Member Access' : 'L2 Executive Access'),
              ],
            ),
            const SizedBox(height: 20),

            // 4. Emergency Contacts Card
            _buildCardSection(
              context,
              title: 'SOS Settings & Emergency Contacts',
              items: [
                _buildInfoRow('Primary Responder', 'Local Ward Coordinator'),
                _buildInfoRow('Secondary Responder', 'Taluk Help Center'),
                _buildInfoRow('FCM Push Tokens', 'Enabled / Active', valueColor: Colors.teal),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardSection(BuildContext context, {
    required String title,
    required List<Widget> items,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            ...items,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
