import 'package:flutter/material.dart';
import '../../../core/theme.dart';

class NotificationItem {
  final String title;
  final String description;
  final String category; // Emergency, Announcement, Approval, Task
  final String timestamp;
  final IconData icon;
  final Color color;

  NotificationItem({
    required this.title,
    required this.description,
    required this.category,
    required this.timestamp,
    required this.icon,
    required this.color,
  });
}

class NotificationCenter extends StatelessWidget {
  const NotificationCenter({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Mock timeline list items matching required sections
    final List<NotificationItem> notifications = [
      NotificationItem(
        title: 'SOS Emergency Alert Raised',
        description: 'Arun Mozhi raised a critical SOS in Egmore Ward 119.',
        category: 'Emergency',
        timestamp: '10 mins ago',
        icon: Icons.emergency,
        color: AppTheme.emergency,
      ),
      NotificationItem(
        title: 'New Member Registration Approved',
        description: 'Senthil Kumar (Egmore) was verified and approved into Chennai district.',
        category: 'Approval',
        timestamp: '1 hour ago',
        icon: Icons.check_circle,
        color: Colors.green,
      ),
      NotificationItem(
        title: 'State Conference Announcement',
        description: 'Vanakkam! The statewide leadership conference date has been set for June 15.',
        category: 'Announcement',
        timestamp: '3 hours ago',
        icon: Icons.campaign,
        color: Colors.blue,
      ),
      NotificationItem(
        title: 'Task Assigned: IT Wing Verification',
        description: 'Verify 4 new influencer profiles within Egmore region.',
        category: 'Task',
        timestamp: 'Yesterday',
        icon: Icons.assignment_turned_in,
        color: Colors.purple,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications Center'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Chips summary
          Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All', true, context),
                  const SizedBox(width: 8),
                  _buildFilterChip('Emergency', false, context),
                  const SizedBox(width: 8),
                  _buildFilterChip('Announcements', false, context),
                  const SizedBox(width: 8),
                  _buildFilterChip('Approvals', false, context),
                  const SizedBox(width: 8),
                  _buildFilterChip('Tasks', false, context),
                ],
              ),
            ),
          ),

          // Vertical timeline list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final item = notifications[index];
                final isLast = index == notifications.length - 1;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Timeline indicator (Dot and connecting Line)
                    Column(
                      children: [
                        Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: item.color,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(color: item.color.withOpacity(0.4), blurRadius: 4)
                            ]
                          ),
                        ),
                        if (!isLast)
                          Container(
                            width: 2,
                            height: 90,
                            color: Colors.grey.withOpacity(0.3),
                          ),
                      ],
                    ),
                    const SizedBox(width: 16),

                    // Message Card
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 24),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? AppTheme.surfaceDark : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.withOpacity(0.15)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Category Tag
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: item.color.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    item.category.toUpperCase(),
                                    style: TextStyle(
                                      color: item.color,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  item.timestamp,
                                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item.title,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.description,
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? AppTheme.primary
            : (isDark ? AppTheme.surfaceDark : Colors.white),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? AppTheme.primary : Colors.grey.withOpacity(0.3),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
