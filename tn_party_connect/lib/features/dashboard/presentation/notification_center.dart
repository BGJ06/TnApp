import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/presentation/auth_state.dart';
import 'navigation_holder.dart';
import '../../../core/routes.dart';
import '../../../core/theme.dart';
import '../../../core/localization.dart';

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

final notificationFilterProvider = StateProvider<String>((ref) => 'All');

class NotificationCenter extends ConsumerWidget {
  const NotificationCenter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final isGuest = authState is! AuthAuthenticated;
    final selectedFilter = ref.watch(notificationFilterProvider);
    final isTamil = ref.watch(languageProvider) == AppLanguage.tamil;

    if (isGuest) {
      return Scaffold(
        appBar: AppBar(
          title: Text(isTamil ? 'அறிவிப்பு மையம்' : 'Notifications Center'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.notifications_off_outlined,
                  size: 80,
                  color: AppTheme.accent,
                ),
                const SizedBox(height: 24),
                Text(
                  isTamil ? 'அறிவிப்பு உள்நுழைவு தேவை' : 'Notifications Login Required',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  isTamil 
                      ? 'உங்கள் வட்டார அறிவிப்புகள், புஷ் அறிவிப்புகள் மற்றும் ஒதுக்கப்பட்ட பணிகளைக் காண, தயவுசெய்து உள்நுழையவும்.' 
                      : 'To view your regional announcements, push notifications, and task assignments, please log in.',
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

    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Mock timeline list items matching required sections
    final List<NotificationItem> notifications = [
      NotificationItem(
        title: context.tr('notifSosTitle', ref),
        description: context.tr('notifSosDesc', ref),
        category: 'Emergency',
        timestamp: isTamil ? '10 நிமிடங்களுக்கு முன்' : '10 mins ago',
        icon: Icons.emergency,
        color: AppTheme.emergency,
      ),
      NotificationItem(
        title: context.tr('notifApprovalTitle', ref),
        description: context.tr('notifApprovalDesc', ref),
        category: 'Approval',
        timestamp: isTamil ? '1 மணிநேரத்திற்கு முன்' : '1 hour ago',
        icon: Icons.check_circle,
        color: Colors.green,
      ),
      NotificationItem(
        title: context.tr('notifItCampTitle', ref),
        description: context.tr('notifItCampDesc', ref),
        category: 'Event',
        timestamp: isTamil ? '2 மணிநேரத்திற்கு முன்' : '2 hours ago',
        icon: Icons.campaign,
        color: Colors.teal,
      ),
      NotificationItem(
        title: context.tr('notifConfTitle', ref),
        description: context.tr('notifConfDesc', ref),
        category: 'Announcement',
        timestamp: isTamil ? '3 மணிநேரத்திற்கு முன்' : '3 hours ago',
        icon: Icons.campaign,
        color: Colors.blue,
      ),
      NotificationItem(
        title: context.tr('notifTaskTitle', ref),
        description: context.tr('notifTaskDesc', ref),
        category: 'Task',
        timestamp: isTamil ? 'நேற்று' : 'Yesterday',
        icon: Icons.assignment_turned_in,
        color: Colors.purple,
      ),
      NotificationItem(
        title: context.tr('notifBloodTitle', ref),
        description: context.tr('notifBloodDesc', ref),
        category: 'Event',
        timestamp: isTamil ? '2 நாட்களுக்கு முன்' : '2 days ago',
        icon: Icons.volunteer_activism,
        color: Colors.red,
      ),
    ];

    // Filter notifications based on active category selection
    final filteredNotifications = selectedFilter == 'All'
        ? notifications
        : notifications.where((n) {
            if (selectedFilter == 'Announcements') {
              return n.category == 'Announcement';
            }
            if (selectedFilter == 'Events') {
              return n.category == 'Event';
            }
            if (selectedFilter == 'Approvals') {
              return n.category == 'Approval';
            }
            if (selectedFilter == 'Tasks') {
              return n.category == 'Task';
            }
            return n.category == selectedFilter;
          }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('notifications', ref)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            ref.read(tabIndexProvider.notifier).state = 4; // Welcome/Home Dashboard tab
          },
        ),
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
                  _buildFilterChip('All', selectedFilter == 'All', context, ref),
                  const SizedBox(width: 8),
                  _buildFilterChip('Emergency', selectedFilter == 'Emergency', context, ref),
                  const SizedBox(width: 8),
                  _buildFilterChip('Announcements', selectedFilter == 'Announcements', context, ref),
                  const SizedBox(width: 8),
                  _buildFilterChip('Events', selectedFilter == 'Events', context, ref),
                  const SizedBox(width: 8),
                  _buildFilterChip('Approvals', selectedFilter == 'Approvals', context, ref),
                  const SizedBox(width: 8),
                  _buildFilterChip('Tasks', selectedFilter == 'Tasks', context, ref),
                ],
              ),
            ),
          ),

          // Vertical timeline list
          Expanded(
            child: filteredNotifications.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_off_outlined,
                          size: 60,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          isTamil 
                              ? '${context.tr(_getFilterKey(selectedFilter), ref)} அறிவிப்புகள் எதுவும் இல்லை' 
                              : 'No $selectedFilter notifications',
                          style: const TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: filteredNotifications.length,
                    itemBuilder: (context, index) {
                      final item = filteredNotifications[index];
                      final isLast = index == filteredNotifications.length - 1;

                      return IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                  Expanded(
                                    child: Container(
                                      width: 2,
                                      color: Colors.grey.withOpacity(0.3),
                                    ),
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
                                            context.tr('notifCat${item.category}', ref).toUpperCase(),
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
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final translationKeys = {
      'All': 'filterAll',
      'Emergency': 'filterEmergency',
      'Announcements': 'filterAnnouncements',
      'Events': 'filterEvents',
      'Approvals': 'filterApprovals',
      'Tasks': 'filterTasks',
    };
    final displayLabel = context.tr(translationKeys[label] ?? label, ref);

    return InkWell(
      onTap: () {
        ref.read(notificationFilterProvider.notifier).state = label;
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
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
          displayLabel,
          style: TextStyle(
            color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  String _getFilterKey(String label) {
    final translationKeys = {
      'All': 'filterAll',
      'Emergency': 'filterEmergency',
      'Announcements': 'filterAnnouncements',
      'Events': 'filterEvents',
      'Approvals': 'filterApprovals',
      'Tasks': 'filterTasks',
    };
    return translationKeys[label] ?? label;
  }
}
