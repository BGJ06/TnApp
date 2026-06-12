import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants.dart';
import '../../../core/theme.dart';
import '../../../core/localization.dart';

class InfluencerProfile {
  final String name;
  final String district;
  final String taluk;
  final List<String> skills;
  final int followers;
  final int reach;
  final String email;
  final String phone;
  final Map<String, String> socialHandles;

  InfluencerProfile({
    required this.name,
    required this.district,
    required this.taluk,
    required this.skills,
    required this.followers,
    required this.reach,
    required this.email,
    required this.phone,
    required this.socialHandles,
  });
}

class InfluencerSearch extends ConsumerStatefulWidget {
  const InfluencerSearch({super.key});

  @override
  ConsumerState<InfluencerSearch> createState() => _InfluencerSearchState();
}

class _InfluencerSearchState extends ConsumerState<InfluencerSearch> {
  String _selectedDistrict = 'All';
  String _selectedSkill = 'All';

  // Mock list of registered influencers
  final List<InfluencerProfile> _profiles = [
    InfluencerProfile(
      name: 'Venkatesh Prasad',
      district: 'Chennai',
      taluk: 'Mylapore',
      skills: ['Graphic Design', 'Social Media Management', 'Campaign Management'],
      followers: 25000,
      reach: 45000,
      email: 'venkat@gmail.com',
      phone: '+919876500112',
      socialHandles: {'x': '@venkat_prasad', 'instagram': '@venkat_designs'},
    ),
    InfluencerProfile(
      name: 'Priyanka Bose',
      district: 'Coimbatore',
      taluk: 'Pollachi',
      skills: ['Public Speaking', 'Content Writing'],
      followers: 84000,
      reach: 120000,
      email: 'priyanka@outlook.com',
      phone: '+919944321098',
      socialHandles: {'youtube': 'PriyankaSpeaks', 'x': '@priya_speaks'},
    ),
    InfluencerProfile(
      name: 'Senthil Nathan',
      district: 'Chennai',
      taluk: 'Egmore',
      skills: ['Video Editing', 'Videography', 'Photography'],
      followers: 12000,
      reach: 32000,
      email: 'senthil_creatives@gmail.com',
      phone: '+919500044556',
      socialHandles: {'instagram': '@senthil_lens'},
    ),
    InfluencerProfile(
      name: 'Madan Gopal',
      district: 'Madurai',
      taluk: 'Melur',
      skills: ['Web Development', 'App Development', 'Social Media Management'],
      followers: 8500,
      reach: 18000,
      email: 'madan@webdev.in',
      phone: '+919003889900',
      socialHandles: {'x': '@madan_dev'},
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isTamil = ref.watch(languageProvider) == AppLanguage.tamil;

    // Filter profiles based on state variables
    final filteredProfiles = _profiles.where((p) {
      final matchDistrict = _selectedDistrict == 'All' || p.district == _selectedDistrict;
      final matchSkill = _selectedSkill == 'All' || p.skills.contains(_selectedSkill);
      return matchDistrict && matchSkill;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('itWingSearchMatrix', ref)),
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
      body: Column(
        children: [
          // Search & Filter Panel stacked vertically for mobile display
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.surfaceDark : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Filter by District
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: context.tr('districtLabel', ref),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: const OutlineInputBorder(),
                  ),
                  value: _selectedDistrict,
                  items: [
                    DropdownMenuItem(value: 'All', child: Text(isTamil ? 'அனைத்து மாவட்டங்கள்' : 'All Regions')),
                    DropdownMenuItem(value: 'Chennai', child: Text(isTamil ? 'சென்னை' : 'Chennai')),
                    DropdownMenuItem(value: 'Madurai', child: Text(isTamil ? 'மதுரை' : 'Madurai')),
                    DropdownMenuItem(value: 'Coimbatore', child: Text(isTamil ? 'கோயம்புத்தூர்' : 'Coimbatore')),
                  ],
                  onChanged: (val) {
                    setState(() {
                      _selectedDistrict = val ?? 'All';
                    });
                  },
                ),
                const SizedBox(height: 12),

                // Filter by Technical Skill
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: isTamil ? 'டிஜிட்டல் திறன்' : 'Capability Skill',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: const OutlineInputBorder(),
                  ),
                  value: _selectedSkill,
                  items: [
                    DropdownMenuItem(value: 'All', child: Text(isTamil ? 'அனைத்து திறன்கள்' : 'All Skills')),
                    ...AppConstants.influencerSkills.map((s) => DropdownMenuItem(
                          value: s,
                          child: Text(isTamil ? context.trSkill(s, ref) : s),
                        )),
                  ],
                  onChanged: (val) {
                    setState(() {
                      _selectedSkill = val ?? 'All';
                    });
                  },
                ),
              ],
            ),
          ),

          // Search Results Counter
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${isTamil ? "தேடல் முடிவுகள்" : "Search Results"} (${filteredProfiles.length})',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  '${isTamil ? "மொத்த சென்றடைவு" : "Reach Sum"}: ${filteredProfiles.fold(0, (sum, p) => sum + p.reach).toString()}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),

          // Profiles Scrollable List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredProfiles.length,
              itemBuilder: (context, index) {
                final profile = filteredProfiles[index];
                final displayProfileName = isTamil ? context.trName(profile.name, ref) : profile.name;
                final displayDistrict = isTamil ? context.trDistrict(profile.district, ref) : profile.district;
                final displayTaluk = isTamil ? context.trTaluk(profile.taluk, ref) : profile.taluk;

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              displayProfileName,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Text(
                              '$displayDistrict ($displayTaluk)',
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        
                        // Follower analytics chips
                        Row(
                          children: [
                            _buildInfoChip(Icons.people, '${profile.followers} ${isTamil ? "பின்தொடர்பவர்கள்" : "Followers"}'),
                            const SizedBox(width: 8),
                            _buildInfoChip(Icons.trending_up, '${profile.reach} ${isTamil ? "சென்றடைவு" : "Est. Reach"}'),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Skills tags
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: profile.skills.map((skill) {
                            final displaySkill = isTamil ? context.trSkill(skill, ref) : skill;
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.teal.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                displaySkill,
                                style: const TextStyle(color: Colors.teal, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),

                        // Social Media Links list
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${isTamil ? "தொடர்புக்கு" : "Contact"}: ${profile.phone}',
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    profile.email,
                                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: profile.socialHandles.entries.map((entry) {
                                return Tooltip(
                                  message: '${entry.key}: ${entry.value}',
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 8),
                                    child: CircleAvatar(
                                      radius: 16,
                                      backgroundColor: AppTheme.primary,
                                      child: Icon(
                                        entry.key == 'x' 
                                            ? Icons.alternate_email
                                            : entry.key == 'youtube'
                                                ? Icons.video_library
                                                : Icons.camera_alt,
                                        size: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        )
                      ],
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

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(color: Colors.grey, fontSize: 11)),
        ],
      ),
    );
  }
}
