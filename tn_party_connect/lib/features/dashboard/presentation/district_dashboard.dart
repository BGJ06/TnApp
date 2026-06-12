import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/presentation/auth_state.dart';
import '../../../core/theme.dart';
import '../../../core/routes.dart';
import '../../../core/localization.dart';

// Struct modeling a member awaiting approval
class PendingApprovalMember {
  final String uid;
  final String fullName;
  final String mobileNumber;
  final String taluk;
  final String ward;
  final String requestTimestamp;

  PendingApprovalMember({
    required this.uid,
    required this.fullName,
    required this.mobileNumber,
    required this.taluk,
    required this.ward,
    required this.requestTimestamp,
  });
}

// Manage list state of approvals locally for UI interaction
class PendingApprovalsNotifier
    extends StateNotifier<List<PendingApprovalMember>> {
  PendingApprovalsNotifier()
      : super([
          PendingApprovalMember(
            uid: 'app-user-1',
            fullName: 'Senthil Kumar',
            mobileNumber: '+919840123456',
            taluk: 'Egmore',
            ward: '119',
            requestTimestamp: '2 hours ago',
          ),
          PendingApprovalMember(
            uid: 'app-user-2',
            fullName: 'Meenakshi Sundaram',
            mobileNumber: '+919444987654',
            taluk: 'Egmore',
            ward: '120',
            requestTimestamp: '4 hours ago',
          ),
          PendingApprovalMember(
            uid: 'app-user-3',
            fullName: 'Vijay Raghavan',
            mobileNumber: '+919003112233',
            taluk: 'Mylapore',
            ward: '142',
            requestTimestamp: 'Yesterday',
          ),
        ]);

  void approve(String uid) {
    state = state.where((m) => m.uid != uid).toList();
  }

  void reject(String uid) {
    state = state.where((m) => m.uid != uid).toList();
  }
}

final pendingApprovalsProvider = StateNotifierProvider<PendingApprovalsNotifier,
    List<PendingApprovalMember>>((ref) {
  return PendingApprovalsNotifier();
});

class DistrictDashboard extends ConsumerWidget {
  const DistrictDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final pendingMembers = ref.watch(pendingApprovalsProvider);

    if (authState is! AuthAuthenticated) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final user = authState.user;
    final districtName = user.assignedRegion['district'] ?? 'Chennai';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isTamil = ref.watch(languageProvider) == AppLanguage.tamil;

    final Map<String, String> timestampTranslations = {
      '2 hours ago': isTamil ? '2 மணிநேரத்திற்கு முன்' : '2 hours ago',
      '4 hours ago': isTamil ? '4 மணிநேரத்திற்கு முன்' : '4 hours ago',
      'Yesterday': isTamil ? 'நேற்று' : 'Yesterday',
    };

    final displayDistrictName = isTamil ? context.trDistrict(districtName, ref) : districtName;

    return Scaffold(
      appBar: AppBar(
        title: Text('$displayDistrictName ${context.tr('districtHubTitle', ref)}'),
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
            // Header Info
            Row(
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: AppTheme.accent,
                  child:
                      Icon(Icons.location_city, color: Colors.black, size: 28),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.trName(user.fullName, ref),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${context.tr('districtCoordinator', ref)} - $displayDistrictName',
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // District Stats Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildQuickStat(context.tr('districtMembers', ref), '1,420'),
                    const VerticalDivider(width: 20, thickness: 1),
                    _buildQuickStat(context.tr('activeLeaders', ref), '54'),
                    const VerticalDivider(width: 20, thickness: 1),
                    _buildQuickStat(
                        context.tr('pendingApprovals', ref), '${pendingMembers.length}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Pending Approvals Panel
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.tr('pendingRegistrations', ref),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${pendingMembers.length} ${context.tr('pendingCount', ref)}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (pendingMembers.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: Text(context.tr('allApproved', ref),
                        style: const TextStyle(color: Colors.grey)),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: pendingMembers.length,
                itemBuilder: (context, index) {
                  final member = pendingMembers[index];
                  final displayTaluk = isTamil ? context.trTaluk(member.taluk, ref) : member.taluk;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                context.trName(member.fullName, ref),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                timestampTranslations[member.requestTimestamp] ?? member.requestTimestamp,
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 12),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text('${context.tr('talukLabel', ref)}: $displayTaluk | ${isTamil ? "வார்டு" : "Ward"}: ${member.ward}'),
                          Text('${isTamil ? "தொலைபேசி" : "Phone"}: ${member.mobileNumber}',
                              style: const TextStyle(color: Colors.grey)),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    ref
                                        .read(pendingApprovalsProvider.notifier)
                                        .reject(member.uid);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              context.tr('memberRejectedMsg', ref))),
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.red),
                                  child: Text(context.tr('reject', ref)),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    ref
                                        .read(pendingApprovalsProvider.notifier)
                                        .approve(member.uid);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              context.tr('memberApprovedMsg', ref))),
                                    );
                                  },
                                  child: Text(context.tr('approve', ref)),
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
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStat(String title, String count) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
      ],
    );
  }
}
