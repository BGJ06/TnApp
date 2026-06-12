import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/presentation/auth_state.dart';
import '../../auth/data/auth_repository.dart';
import '../../../core/theme.dart';
import '../../../core/routes.dart';
import '../../../core/localization.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final isGuest = authState is! AuthAuthenticated;
    final isTamil = ref.watch(languageProvider) == AppLanguage.tamil;

    if (isGuest) {
      return Scaffold(
        appBar: AppBar(
          title: Text(context.tr('profile', ref)),
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
            const SizedBox(width: 8),
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.person_outline,
                  size: 80,
                  color: AppTheme.accent,
                ),
                const SizedBox(height: 24),
                Text(
                  context.tr('profileDetails', ref),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  context.tr('profileGuestDesc', ref),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.login);
                  },
                  child: Text(context.tr('loginOrRegister', ref)),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final user = (authState as AuthAuthenticated).user;
    final isDark = Theme.of(context).brightness == Brightness.dark;



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

    // Generated static details for demonstration
    final mockDob = user.role == 'member' ? '12/08/1994' : '05/04/1982';
    final mockEmail = user.role == 'member' ? 'member@gmail.com' : '${user.uid}@tnpartyconnect.org';
    final mockMemberId = 'TN-${user.role.substring(0,2).toUpperCase()}-9841-2026';

    // Status mapping
    final isApproved = user.status == 'approved';
    final statusColor = isApproved ? Colors.green : Colors.orange;
    final statusText = isApproved ? context.tr('approved', ref) : context.tr('validationPending', ref);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('profile', ref)),
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
                        child: Text(
                          isTamil ? 'செயலில் உள்ள உறுப்பினர்' : 'ACTIVE MEMBER',
                          style: const TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.bold),
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
                          user.fullName.isNotEmpty ? user.fullName[0] : 'U',
                          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.trName(user.fullName, ref),
                              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              roleText,
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
                          Text(context.tr('membershipId', ref), style: const TextStyle(color: Colors.white60, fontSize: 9)),
                          Text(mockMemberId, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(context.tr('region', ref), style: const TextStyle(color: Colors.white60, fontSize: 9)),
                          Text(
                            localizedDistrict,
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
              title: context.tr('personalContactInfo', ref),
              items: [
                _buildInfoRow(context.tr('fullName', ref), context.trName(user.fullName, ref)),
                _buildInfoRow(context.tr('dob', ref), mockDob),
                _buildInfoRow(context.tr('primaryMobile', ref), user.mobileNumber ?? '+919999999999'),
                _buildInfoRow(context.tr('emailAddress', ref), mockEmail),
                _buildInfoRow(context.tr('stateScope', ref), isTamil ? 'தமிழ்நாடு, இந்தியா' : 'Tamil Nadu, India'),
              ],
            ),
            const SizedBox(height: 20),

            // 3. Status Card
            _buildCardSection(
              context,
              title: context.tr('integrityTitle', ref),
              items: [
                _buildInfoRow(context.tr('joinedDate', ref), '03/06/2026'),
                _buildInfoRow(context.tr('validationStatus', ref), statusText, valueColor: statusColor),
                _buildInfoRow(context.tr('securityLevel', ref), user.role == 'member' ? context.tr('l1MemberAccess', ref) : context.tr('l2ExecutiveAccess', ref)),
              ],
            ),
            const SizedBox(height: 20),

            // 4. Emergency Contacts Card
            _buildCardSection(
              context,
              title: context.tr('sosSettingsTitle', ref),
              items: [
                _buildInfoRow(context.tr('primaryResponder', ref), context.tr('localCoordinator', ref)),
                _buildInfoRow(context.tr('secondaryResponder', ref), context.tr('talukHelpCenter', ref)),
                _buildInfoRow(context.tr('fcmTokens', ref), context.tr('enabledActive', ref), valueColor: Colors.teal),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 11),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
