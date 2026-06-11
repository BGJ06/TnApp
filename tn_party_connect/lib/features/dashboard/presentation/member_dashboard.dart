import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/presentation/auth_state.dart';
import '../../auth/data/auth_repository.dart';
import '../../sos/presentation/sos_state.dart';
import '../../../core/theme.dart';
import '../../../core/routes.dart';
import '../../../core/localization.dart';

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
    final isTamil = ref.watch(languageProvider) == AppLanguage.tamil;

    final isGuest = authState is! AuthAuthenticated;
    if (isGuest) {
      return Scaffold(
        appBar: AppBar(
          title: Text(context.tr('memberPortal', ref)),
          actions: [
            // Language Switcher Toggle button
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
                  Icons.lock_outline,
                  size: 80,
                  color: AppTheme.accent,
                ),
                const SizedBox(height: 24),
                Text(
                  context.tr('memberLoginRequired', ref),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  context.tr('memberPortalGuestDesc', ref),
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
    final isPending = user.status != 'approved';

    // Translation maps
    final districtTamilNames = {
      'Ariyalur': 'அரியலூர்',
      'Chengalpattu': 'செங்கல்பட்டு',
      'Chennai': 'சென்னை',
      'Coimbatore': 'கோயம்புத்தூர்',
      'Cuddalore': 'கடலூர்',
      'Dharmapuri': 'தர்மபுரி',
      'Dindigul': 'திண்டுக்கல்',
      'Erode': 'ஈரோடு',
      'Kallakurichi': 'கள்ளக்குறிச்சி',
      'Kanchipuram': 'காஞ்சிபுரம்',
      'Kanyakumari': 'கன்னியாகுமரி',
      'Karur': 'கரூர்',
      'Krishnagiri': 'கிருஷ்ணகிரி',
      'Madurai': 'மதுரை',
      'Mayiladuthurai': 'மயிலாடுதுறை',
      'Nagapattinam': 'நாகப்பட்டினம்',
      'Namakkal': 'நாமக்கல்',
      'Nilgiris': 'நீலகிரி',
      'Perambalur': 'பெரம்பலூர்',
      'Pudukkottai': 'புதுக்கோட்டை',
      'Ramanathapuram': 'இராமநாதபுரம்',
      'Ranipet': 'ராணிப்பேட்டை',
      'Salem': 'சேலம்',
      'Sivaganga': 'சிவகங்கை',
      'Tenkasi': 'தென்காசி',
      'Thanjavur': 'தஞ்சாவூர்',
      'Theni': 'தேனி',
      'Thoothukudi': 'தூத்துக்குடி',
      'Tiruchirappalli': 'திருச்சிராப்பள்ளி',
      'Tirunelveli': 'திருநெல்வேலி',
      'Tirupathur': 'திருப்பத்தூர்',
      'Tiruppur': 'திருப்பூர்',
      'Tiruvallur': 'திருவள்ளூர்',
      'Tiruvannamalai': 'திருவண்ணாமலை',
      'Tiruvarur': 'திருவாரூர்',
      'Vellore': 'வேலூர்',
      'Viluppuram': 'விழுப்புரம்',
      'Virudhunagar': 'விருதுநகர்',
    };

    final district = user.assignedRegion['district'] ?? 'Tamil Nadu';
    final localizedDistrict = isTamil ? (districtTamilNames[district] ?? district) : district;
    final taluk = user.assignedRegion['taluk'] ?? '';
    final localizedTaluk = taluk.isNotEmpty ? taluk : '';

    // Filter alerts triggered by this specific member
    final myAlerts = sosAlerts.where((a) => a.memberUid == user.uid).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('memberPortal', ref)),
        actions: [
          // Language Switcher Toggle button
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
                      backgroundColor: AppTheme.primary,
                      child: Text(
                        user.fullName.isNotEmpty ? user.fullName[0] : 'U',
                        style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${isTamil ? "வணக்கம்" : "Vanakkam"}, ${user.fullName}',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${isTamil ? "வட்டம்/மாவட்டம்" : "Region"}: $localizedDistrict, $localizedTaluk',
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
                  Text(
                    context.tr('sosTitle', ref),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.tr('sosHelper', ref),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 32),
                  
                  // Pulsing SOS button (or Lock if pending validation status)
                  isPending
                      ? Container(
                          height: 160,
                          width: 160,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.orange.withOpacity(0.1),
                            border: Border.all(color: Colors.orange, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.2),
                                blurRadius: 15,
                                spreadRadius: 5,
                              )
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.lock_clock_outlined, size: 50, color: Colors.orange),
                              const SizedBox(height: 6),
                              Text(
                                context.tr('validationPending', ref).toUpperCase(),
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.orange),
                              ),
                            ],
                          ),
                        )
                      : ScaleTransition(
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
                              gradient: const LinearGradient(
                                colors: [Color(0xFFC62828), Color(0xFFB71C1C)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
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
                                  SnackBar(
                                    content: Text(context.tr('sosAlertSuccess', ref)),
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
                  
                  if (isPending) ...[
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange.withOpacity(0.25)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              context.tr('validationPendingDesc', ref),
                              style: const TextStyle(color: Colors.orange, fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 50),

            // Member-Specific Active Alerts Listing
            if (myAlerts.isNotEmpty) ...[
              Text(
                context.tr('myActiveSosLogs', ref),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                      title: Text(isTamil ? 'SOS எச்சரிக்கை எழுப்பப்பட்டது' : 'SOS Alert Raised'),
                      subtitle: Text(
                        '${isTamil ? "நேரம்" : "Time"}: ${alert.timestamp.hour}:${alert.timestamp.minute.toString().padLeft(2, '0')}\nCoords: ${alert.latitude.toStringAsFixed(4)}, ${alert.longitude.toStringAsFixed(4)}',
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isResolved ? Colors.green : Colors.orange,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          isTamil 
                              ? (isResolved ? 'தீர்வு காணப்பட்டது' : 'செயலில் உள்ளது')
                              : alert.status.toUpperCase(),
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],

            // IT Wing Navigation Shortcut (still available for pending)
            Card(
              color: isDark ? AppTheme.surfaceDark : AppTheme.primary.withOpacity(0.08),
              child: ListTile(
                leading: const Icon(Icons.campaign, color: Colors.teal),
                title: Text(context.tr('itWingShortcutTitle', ref), style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(context.tr('itWingShortcutDesc', ref)),
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
