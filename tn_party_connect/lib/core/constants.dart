class AppConstants {
  static const String appName = 'TN Party Connect';

  // Firestore Collections
  static const String collectionMembers = 'members';
  static const String collectionLeaders = 'leaders';
  static const String collectionSOSAlerts = 'sos_alerts';
  static const String collectionITWing = 'it_wing_influencers';

  // Local Storage Keys
  static const String keyUserRole = 'user_role';
  static const String keyUserRegion = 'user_region';
  static const String keyUserId = 'user_id';
  static const String keyUserFullName = 'user_full_name';

  // Roles Definition
  static const String roleMember = 'member';
  static const String roleStatePresident = 'state_president';
  static const String roleStateGeneralSecretary = 'state_general_secretary';
  static const String roleStateITHead = 'state_it_head';
  static const String roleDistrictHead = 'district_head';
  static const String roleTalukHead = 'taluk_head';
  static const String roleVillageHead = 'village_head';
  static const String roleAreaHead = 'area_head';
  static const String roleWardHead = 'ward_head';

  // Special Wings Definition
  static const List<String> specialWings = [
    'IT Wing',
    'Youth Wing',
    'Women\'s Wing',
    'Student Wing',
    'Volunteer Wing',
    'Social Media Wing',
    'Legal Wing',
  ];

  // Digital Capability Skills
  static const List<String> influencerSkills = [
    'Graphic Design',
    'Video Editing',
    'Photography',
    'Videography',
    'Public Speaking',
    'Content Writing',
    'Social Media Management',
    'Web Development',
    'App Development',
    'Campaign Management'
  ];
}
