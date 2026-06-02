import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../core/theme.dart';

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

class InfluencerSearch extends StatefulWidget {
  const InfluencerSearch({super.key});

  @override
  State<InfluencerSearch> createState() => _InfluencerSearchState();
}

class _InfluencerSearchState extends State<InfluencerSearch> {
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

    // Filter profiles based on state variables
    final filteredProfiles = _profiles.where((p) {
      final matchDistrict = _selectedDistrict == 'All' || p.district == _selectedDistrict;
      final matchSkill = _selectedSkill == 'All' || p.skills.contains(_selectedSkill);
      return matchDistrict && matchSkill;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Influencer Search Grid'),
      ),
      body: Column(
        children: [
          // Search & Filter Panel
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF152A22) : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Row(
              children: [
                // Filter by District
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Region (District)',
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedDistrict,
                    items: const [
                      DropdownMenuItem(value: 'All', child: Text('All Regions')),
                      DropdownMenuItem(value: 'Chennai', child: Text('Chennai')),
                      DropdownMenuItem(value: 'Madurai', child: Text('Madurai')),
                      DropdownMenuItem(value: 'Coimbatore', child: Text('Coimbatore')),
                    ],
                    onChanged: (val) {
                      setState(() {
                        _selectedDistrict = val ?? 'All';
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),

                // Filter by Technical Skill
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Capability Skill',
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedSkill,
                    items: [
                      const DropdownMenuItem(value: 'All', child: Text('All Skills')),
                      ...AppConstants.influencerSkills.map((s) => DropdownMenuItem(
                            value: s,
                            child: Text(s),
                          )),
                    ],
                    onChanged: (val) {
                      setState(() {
                        _selectedSkill = val ?? 'All';
                      });
                    },
                  ),
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
                  'Search Results (${filteredProfiles.length})',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  'Reach Sum: ${filteredProfiles.fold(0, (sum, p) => sum + p.reach).toString()}',
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
                              profile.name,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Text(
                              '${profile.district} (${profile.taluk})',
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        
                        // Follower analytics chips
                        Row(
                          children: [
                            _buildInfoChip(Icons.people, '${profile.followers} Followers'),
                            const SizedBox(width: 8),
                            _buildInfoChip(Icons.trending_up, '${profile.reach} Est. Reach'),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Skills tags
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: profile.skills.map((skill) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isDark ? Colors.teal.withOpacity(0.2) : Colors.teal.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                skill,
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
                                    'Contact: ${profile.phone}',
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
                                      backgroundColor: isDark ? AppTheme.primaryDark : AppTheme.accentLight,
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
