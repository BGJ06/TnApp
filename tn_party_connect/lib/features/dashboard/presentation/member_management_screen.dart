import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'district_dashboard.dart'; // Import pendingApprovalsProvider & model
import '../../../core/theme.dart';

class MemberManagementScreen extends ConsumerStatefulWidget {
  const MemberManagementScreen({super.key});

  @override
  ConsumerState<MemberManagementScreen> createState() => _MemberManagementScreenState();
}

class _MemberManagementScreenState extends ConsumerState<MemberManagementScreen> {
  String _searchQuery = '';
  String _selectedTaluk = 'All';

  @override
  Widget build(BuildContext context) {
    final pendingMembers = ref.watch(pendingApprovalsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Filter members dynamically
    final filteredMembers = pendingMembers.where((m) {
      final matchesSearch = m.fullName.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesTaluk = _selectedTaluk == 'All' || m.taluk == _selectedTaluk;
      return matchesSearch && matchesTaluk;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Member Management CRM'),
      ),
      body: Column(
        children: [
          // Filter Panel
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.surfaceDark : Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 4))
              ]
            ),
            child: Column(
              children: [
                // Search Input
                TextFormField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    labelText: 'Search Members by Name',
                    border: OutlineInputBorder(),
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
                  decoration: const InputDecoration(
                    labelText: 'Filter by Taluk',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  value: _selectedTaluk,
                  items: const [
                    DropdownMenuItem(value: 'All', child: Text('All Taluks')),
                    DropdownMenuItem(value: 'Egmore', child: Text('Egmore')),
                    DropdownMenuItem(value: 'Mylapore', child: Text('Mylapore')),
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
            color: AppTheme.primary.withOpacity(0.05),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.swipe_left_alt, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text('Swipe Left to Reject', style: TextStyle(color: Colors.grey, fontSize: 11)),
                SizedBox(width: 16),
                Icon(Icons.swipe_right_alt, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text('Swipe Right to Approve', style: TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ),

          // Members List
          Expanded(
            child: filteredMembers.isEmpty
                ? const Center(child: Text('No matching pending member records.', style: TextStyle(color: Colors.grey)))
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
                          child: const Icon(Icons.check_circle, color: Colors.white, size: 30),
                        ),
                        secondaryBackground: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white, size: 30),
                        ),
                        onDismissed: (direction) {
                          if (direction == DismissDirection.startToEnd) {
                            ref.read(pendingApprovalsProvider.notifier).approve(member.uid);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${member.fullName} Approved!')),
                            );
                          } else {
                            ref.read(pendingApprovalsProvider.notifier).reject(member.uid);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${member.fullName} Rejected')),
                            );
                          }
                        },
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            title: Text(member.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text('Taluk: ${member.taluk} | Ward: ${member.ward}'),
                                Text('Mobile: ${member.mobileNumber}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                              ],
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'PENDING',
                                    style: TextStyle(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                const Icon(Icons.drag_indicator, size: 16, color: Colors.grey),
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
