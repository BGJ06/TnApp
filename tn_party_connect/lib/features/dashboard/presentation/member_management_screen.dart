import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'district_dashboard.dart'; // Import pendingApprovalsProvider & model
import '../../../core/theme.dart';
import '../../../core/localization.dart';

class MemberManagementScreen extends ConsumerStatefulWidget {
  const MemberManagementScreen({super.key});

  @override
  ConsumerState<MemberManagementScreen> createState() =>
      _MemberManagementScreenState();
}

class _MemberManagementScreenState
    extends ConsumerState<MemberManagementScreen> {
  String _searchQuery = '';
  String _selectedTaluk = 'All';

  @override
  Widget build(BuildContext context) {
    final pendingMembers = ref.watch(pendingApprovalsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isTamil = ref.watch(languageProvider) == AppLanguage.tamil;

    // Filter members dynamically
    final filteredMembers = pendingMembers.where((m) {
      final matchesSearch =
          m.fullName.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesTaluk = _selectedTaluk == 'All' || m.taluk == _selectedTaluk;
      return matchesSearch && matchesTaluk;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('memberManagementCrm', ref)),
      ),
      body: Column(
        children: [
          // Filter Panel
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: isDark ? AppTheme.surfaceDark : Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 4))
                ]),
            child: Column(
              children: [
                // Search Input
                TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    labelText: context.tr('searchMembersByName', ref),
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                    });
                  },
                ),
                const SizedBox(height: 12),
 
                // Dropdown Filter
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: context.tr('filterByTaluk', ref),
                    border: const OutlineInputBorder(),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  initialValue: _selectedTaluk,
                  items: [
                    DropdownMenuItem(value: 'All', child: Text(isTamil ? 'அனைத்து தாலுகாக்கள்' : 'All Taluks')),
                    DropdownMenuItem(value: 'Egmore', child: Text(isTamil ? 'எழும்பூர்' : 'Egmore')),
                    DropdownMenuItem(
                        value: 'Mylapore', child: Text(isTamil ? 'மயிலாப்பூர்' : 'Mylapore')),
                  ],
                  onChanged: (val) {
                    setState(() {
                      _selectedTaluk = val ?? 'All';
                    });
                  },
                ),
              ],
            ),
          ),

          // Helper instructions for swipes
          Container(
            color: AppTheme.primary.withValues(alpha: 0.05),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.swipe_left_alt, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(context.tr('swipeLeftToReject', ref),
                    style: const TextStyle(color: Colors.grey, fontSize: 11)),
                const SizedBox(width: 16),
                const Icon(Icons.swipe_right_alt, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(context.tr('swipeRightToApprove', ref),
                    style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ),

          // Members List
          Expanded(
            child: filteredMembers.isEmpty
                ? Center(
                    child: Text(context.tr('noPendingRecords', ref),
                        style: const TextStyle(color: Colors.grey)))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredMembers.length,
                    itemBuilder: (context, index) {
                      final member = filteredMembers[index];

                      return Dismissible(
                        key: Key(member.uid),
                        background: Container(
                          color: Colors.green,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 20),
                          child: const Icon(Icons.check_circle,
                              color: Colors.white, size: 30),
                        ),
                        secondaryBackground: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete,
                              color: Colors.white, size: 30),
                        ),
                        onDismissed: (direction) {
                          final displayName = isTamil ? context.trName(member.fullName, ref) : member.fullName;
                          if (direction == DismissDirection.startToEnd) {
                            ref
                                .read(pendingApprovalsProvider.notifier)
                                .approve(member.uid);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text(isTamil ? '$displayName அங்கீகரிக்கப்பட்டது!' : '$displayName Approved!')),
                            );
                          } else {
                            ref
                                .read(pendingApprovalsProvider.notifier)
                                .reject(member.uid);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(isTamil ? '$displayName நிராகரிக்கப்பட்டது' : '$displayName Rejected')),
                            );
                          }
                        },
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            title: Text(isTamil ? context.trName(member.fullName, ref) : member.fullName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                    isTamil ? 'வட்டம்: ${context.trTaluk(member.taluk, ref)} | வார்டு: ${member.ward}' : 'Taluk: ${member.taluk} | Ward: ${member.ward}'),
                                Text('${isTamil ? "கைபேசி" : "Mobile"}: ${member.mobileNumber}',
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 12)),
                              ],
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    context.tr('pendingLabel', ref),
                                    style: const TextStyle(
                                        color: Colors.orange,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                const Icon(Icons.drag_indicator,
                                    size: 16, color: Colors.grey),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
