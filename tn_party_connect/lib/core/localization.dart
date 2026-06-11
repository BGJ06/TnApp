import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppLanguage { english, tamil }

class AppLocalization {
  final AppLanguage language;

  AppLocalization(this.language);

  static final Map<AppLanguage, Map<String, String>> _localizedValues = {
    AppLanguage.english: {
      'appName': 'TN Party Connect',
      'tagline': 'Connecting Leadership & Members Across Tamil Nadu',
      'welcome': 'Welcome',
      'memberPortal': 'Member Portal',
      'leadershipPortal': 'Leadership Portal',
      'browseDirectory': 'Browse Public Directory',
      'sendOtp': 'Send Verification OTP',
      'registerAndSendOtp': 'Register & Send OTP',
      'enterOtp': 'Enter OTP Verification Code',
      'verifyLogin': 'Verify & Login',
      'secureSignIn': 'Secure Sign In',
      'userId': 'Leadership User ID',
      'password': 'Password',
      'phoneHelper': 'Include country code (e.g. +91)',
      'sosTitle': 'EMERGENCY SOS ASSISTANCE',
      'sosHelper': 'Pressing this button shares your location and alerts the leadership instantly.',
      'directory': 'Directory',
      'hierarchy': 'Hierarchy',
      'emergency': 'Emergency',
      'notifications': 'Notifications',
      'profile': 'Profile',
      'dashboard': 'Dashboard',
      'totalMembers': 'Total Members',
      'districts': 'Districts',
      'taluks': 'Taluks',
      'activeSOS': 'Active SOS Alerts',
      'approve': 'Approve',
      'reject': 'Reject',
      'languageToggle': 'தமிழ்',
      'pressBackAgainToExit': 'Press back again to exit',
      
      // Additional Translations
      'more': 'More',
      'login': 'Login',
      'logout': 'Logout',
      'registerNewPerson': 'Register as New Person',
      'loginViaOtp': 'Login via OTP (Registered)',
      'mobileNumber': 'Mobile Number',
      'verificationCode': 'Verification Code',
      'enter6digits': 'Enter 6 digits',
      'changeNumber': 'Change Number',
      'enterValidNumber': 'Enter valid number',
      'required': 'Required',
      
      'leadershipDirectory': 'Leadership Directory',
      'allDistricts': 'All Districts',
      'allTaluks': 'All Taluks',
      'districtLabel': 'District',
      'talukLabel': 'Taluk',
      'resetMapFilter': 'Reset Map Filter',
      'mapTitle': 'Pinpoint Geographical District Map',
      'mapSubtitle': 'Touch a district on the map to filter leadership listings',
      'leadershipContacts': 'Leadership Contacts',
      'noLeadersFound': 'No leadership profiles found for this region.',
      
      'organizationalHierarchy': 'Organizational Hierarchy',
      'hierarchyTreeExplorer': 'Party Hierarchy Tree Explorer',
      'hierarchyTreeDesc': 'Expand nodes to explore administrative divisions of Tamil Nadu.',
      'stateCommand': 'Tamil Nadu (State Command)',
      'stateExecutive': 'State Executive Committee',
      
      'memberLoginRequired': 'Member Login Required',
      'memberPortalGuestDesc': 'To access emergency SOS actions and register for the IT Wing/Influencer Portal, please log in or register as a member.',
      'loginOrRegister': 'Log In / Register',
      'sosAlertSuccess': 'EMERGENCY ALERT BROADCASTED SUCCESSFULLY!',
      'myActiveSosLogs': 'My Active SOS Logs',
      'itWingShortcutTitle': 'IT Wing / Influencer Registry',
      'itWingShortcutDesc': 'Register your social media reach and technical design skills.',
      'validationPending': 'Validation Pending',
      'validationPendingDesc': 'Validation Pending - You will be able to raise SOS once your membership is approved by district leadership.',
      
      'partyStrengthOverview': 'Party Strength Overview',
      'totalDistricts': 'Total Districts',
      'totalTaluks': 'Total Taluks',
      'totalVillages': 'Total Villages',
      'activeMembers': 'Active Members',
      'quickActions': 'Quick Actions',
      'sosEmergency': 'SOS Emergency',
      'searchLeaders': 'Search Leaders',
      'hierarchyChart': 'Hierarchy Chart',
      'itWingCrm': 'IT Wing CRM',
      'partyEvents': 'Party Events',
      'upcomingConference': 'Upcoming State Conference',
      'conferenceDetails': 'June 15, 2026 - Chennai Trade Centre',
      'partyEventsFeed': 'Party Events Feed',
      'itBootcampTitle': 'Statewide IT Wing BootCamp',
      'itBootcampDetails': 'Coimbatore - June 10, 2026',
      'bloodDonationTitle': 'Blood Donation Drive',
      'bloodDonationDetails': 'Madurai North - June 12, 2026',

      'profileDetails': 'Profile Details',
      'profileGuestDesc': 'To view your active membership card, registered contact details, and security level, please log in or register.',
      'fullName': 'Full Name',
      'dob': 'Date of Birth',
      'primaryMobile': 'Primary Mobile',
      'emailAddress': 'Email Address',
      'stateScope': 'State Scope',
      'joinedDate': 'Joined Date',
      'validationStatus': 'Validation Status',
      'securityLevel': 'Security Level',
      'membershipId': 'MEMBERSHIP ID',
      'region': 'REGION',
      'integrityTitle': 'Membership Integrity',
      'sosSettingsTitle': 'SOS Settings & Emergency Contacts',
      'primaryResponder': 'Primary Responder',
      'secondaryResponder': 'Secondary Responder',
      'fcmTokens': 'FCM Push Tokens',
      'enabledActive': 'Enabled / Active',
      'localCoordinator': 'Local Ward Coordinator',
      'talukHelpCenter': 'Taluk Help Center',
      
      'itWingFormTitle': 'IT Wing Registry Form',
      'personalContactInfo': 'Personal & Contact Information',
      'operatingRegion': 'Operating Region',
      'socialMediaAnalytics': 'Social Media Information & Analytics',
      'digitalSkills': 'Digital Skill Capabilities',
      'submitApplication': 'Submit Application',
      'itWingSuccess': 'IT Wing Profile Submitted Successfully!',
    },
    AppLanguage.tamil: {
      'appName': 'த.நா கட்சி இணைப்பு',
      'tagline': 'தமிழ்நாடு முழுவதும் உள்ள தலைவர்களையும் உறுப்பினர்களையும் இணைக்கிறது',
      'welcome': 'வரவேற்கிறோம்',
      'memberPortal': 'உறுப்பினர் போர்டல்',
      'leadershipPortal': 'தலைமை போர்டல்',
      'browseDirectory': 'பொது வழிகாட்டியை உலாவுக',
      'sendOtp': 'OTP-ஐ அனுப்பவும்',
      'registerAndSendOtp': 'பதிவு செய்து OTP அனுப்பவும்',
      'enterOtp': 'OTP சரிபார்ப்புக் குறியீட்டை உள்ளிடவும்',
      'verifyLogin': 'சரிபார்த்து உள்நுழைக',
      'secureSignIn': 'பாதுகாப்பான உள்நுழைவு',
      'userId': 'தலைமை பயனர் ஐடி',
      'password': 'கடவுச்சொல்',
      'phoneHelper': 'நாட்டின் குறியீட்டைச் சேர்க்கவும் (எ.கா. +91)',
      'sosTitle': 'அவசரகால SOS உதவி',
      'sosHelper': 'இந்தப் பொத்தானை அழுத்தினால் உங்கள் இருப்பிடம் பகிரப்பட்டு, உடனடியாகத் தலைவர்கள் எச்சரிக்கப்படுவார்கள்.',
      'directory': 'வழிகாட்டி',
      'hierarchy': 'அமைப்பு',
      'emergency': 'அவசரகாலம்',
      'notifications': 'அறிவிப்புகள்',
      'profile': 'சுயவிவரம்',
      'dashboard': 'டாஷ்போர்டு',
      'totalMembers': 'மொத்த உறுப்பினர்கள்',
      'districts': 'மாவட்டங்கள்',
      'taluks': 'தாலுகாக்கள்',
      'activeSOS': 'செயலில் உள்ள SOS எச்சரிக்கைகள்',
      'approve': 'அங்கீகரி',
      'reject': 'நிராகரி',
      'languageToggle': 'English',
      'pressBackAgainToExit': 'வெளியேற மீண்டும் பின் பொத்தானை அழுத்தவும்',
      
      // Additional Translations
      'more': 'மேலும்',
      'login': 'உள்நுழை',
      'logout': 'வெளியேறு',
      'registerNewPerson': 'புதிய உறுப்பினராக பதிவு செய்',
      'loginViaOtp': 'OTP மூலம் உள்நுழை (பதிவு செய்தவர்கள்)',
      'mobileNumber': 'கைபேசி எண்',
      'verificationCode': 'சரிபார்ப்புக் குறியீடு',
      'enter6digits': '6 இலக்கங்களை உள்ளிடவும்',
      'changeNumber': 'எண்ணை மாற்றவும்',
      'enterValidNumber': 'சரியான எண்ணை உள்ளிடவும்',
      'required': 'தேவைப்படும்',
      
      'leadershipDirectory': 'தலைமை வழிகாட்டி',
      'allDistricts': 'அனைத்து மாவட்டங்கள்',
      'allTaluks': 'அனைத்து தாலுகாக்கள்',
      'districtLabel': 'மாவட்டம்',
      'talukLabel': 'தாலுகா',
      'resetMapFilter': 'வரைபட வடிகட்டியை மீட்டமை',
      'mapTitle': 'துல்லியமான புவியியல் மாவட்ட வரைபடம்',
      'mapSubtitle': 'தலைமைப் பட்டியலை வடிகட்ட வரைபடத்தில் ஒரு மாவட்டத்தைத் தொடவும்',
      'leadershipContacts': 'தலைமைத் தொடர்புகள்',
      'noLeadersFound': 'இப்பகுதியில் தலைமை சுயவிவரங்கள் எதுவும் காணப்படவில்லை.',
      
      'organizationalHierarchy': 'அமைப்பு ரீதியான படிநிலை',
      'hierarchyTreeExplorer': 'கட்சி படிநிலை மர ஆய்வாளர்',
      'hierarchyTreeDesc': 'தமிழ்நாட்டின் நிர்வாகப் பிரிவுகளை ஆராய முனைகளை விரிவுபடுத்தவும்.',
      'stateCommand': 'தமிழ்நாடு (மாநில தலைமை)',
      'stateExecutive': 'மாநில செயற்குழு',
      
      'memberLoginRequired': 'உறுப்பினர் உள்நுழைவு தேவை',
      'memberPortalGuestDesc': 'அவசரகால SOS செயல்களை அணுகவும் மற்றும் IT பிரிவு/செல்வாக்கு செலுத்துபவர் போர்ட்டலில் பதிவு செய்யவும், தயவுசெய்து உள்நுழையவும் அல்லது உறுப்பினராக பதிவு செய்யவும்.',
      'loginOrRegister': 'உள்நுழையவும் / பதிவு செய்யவும்',
      'sosAlertSuccess': 'அவசரகால எச்சரிக்கை வெற்றிகரமாக ஒளிபரப்பப்பட்டது!',
      'myActiveSosLogs': 'எனது செயலில் உள்ள SOS பதிவுகள்',
      'itWingShortcutTitle': 'IT பிரிவு / செல்வாக்கு செலுத்துபவர் பதிவகம்',
      'itWingShortcutDesc': 'உங்கள் சமூக ஊடக அணுகல் மற்றும் தொழில்நுட்ப வடிவமைப்பு திறன்களைப் பதிவு செய்யவும்.',
      'validationPending': 'சரிபார்ப்பு நிலுவையில் உள்ளது',
      'validationPendingDesc': 'சரிபார்ப்பு நிலுவையில் உள்ளது - மாவட்ட தலைமையால் உங்கள் உறுப்பினர் அங்கீகரிக்கப்பட்டதும் உங்களால் SOS எழுப்ப முடியும்.',
      
      'partyStrengthOverview': 'கட்சி பலம் பற்றிய கண்ணோட்டம்',
      'totalDistricts': 'மொத்த மாவட்டங்கள்',
      'totalTaluks': 'மொத்த தாலுகாக்கள்',
      'totalVillages': 'மொத்த கிராமங்கள்',
      'activeMembers': 'செயலில் உள்ள உறுப்பினர்கள்',
      'quickActions': 'விரைவான செயல்கள்',
      'sosEmergency': 'SOS அவசரநிலை',
      'searchLeaders': 'தலைவர்களைத் தேடுங்கள்',
      'hierarchyChart': 'படிநிலை வரைபடம்',
      'itWingCrm': 'IT பிரிவு CRM',
      'partyEvents': 'கட்சி நிகழ்வுகள்',
      'upcomingConference': 'வரவிருக்கும் மாநில மாநாடு',
      'conferenceDetails': 'ஜூன் 15, 2026 - சென்னை வர்த்தக மையம்',
      'partyEventsFeed': 'கட்சி நிகழ்வுகள் ஊட்டம்',
      'itBootcampTitle': 'மாநில அளவிலான IT பிரிவு பயிற்சி முகாம்',
      'itBootcampDetails': 'கோயம்புத்தூர் - ஜூன் 10, 2026',
      'bloodDonationTitle': 'இரத்த தான முகாம்',
      'bloodDonationDetails': 'மதுரை வடக்கு - ஜூன் 12, 2026',

      'profileDetails': 'சுயவிவர விவரங்கள்',
      'profileGuestDesc': 'உங்கள் செயலில் உள்ள உறுப்பினர் அட்டை, பதிவுசெய்யப்பட்ட தொடர்பு விவரங்கள் மற்றும் பாதுகாப்பு நிலை ஆகியவற்றைக் காண, தயவுசெய்து உள்நுழையவும் அல்லது பதிவு செய்யவும்.',
      'fullName': 'முழு பெயர்',
      'dob': 'பிறந்த தேதி',
      'primaryMobile': 'முதன்மை கைபேசி',
      'emailAddress': 'மின்னஞ்சல் முகவரி',
      'stateScope': 'மாநில வரம்பு',
      'joinedDate': 'இணைந்த தேதி',
      'validationStatus': 'சரிபார்ப்பு நிலை',
      'securityLevel': 'பாதுகாப்பு நிலை',
      'membershipId': 'உறுப்பினர் ஐடி',
      'region': 'பகுதி',
      'integrityTitle': 'உறுப்பினர் ஒருமைப்பாடு',
      'sosSettingsTitle': 'SOS அமைப்புகள் மற்றும் அவசர தொடர்புகள்',
      'primaryResponder': 'முதன்மை பதிலளிப்பவர்',
      'secondaryResponder': 'இரண்டாம் நிலை பதிலளிப்பவர்',
      'fcmTokens': 'FCM புஷ் டோக்கன்கள்',
      'enabledActive': 'செயல்படுத்தப்பட்டது / செயலில் உள்ளது',
      'localCoordinator': 'உள்ளூர் வார்டு ஒருங்கிணைப்பாளர்',
      'talukHelpCenter': 'தாலுகா உதவி மையம்',
      
      'itWingFormTitle': 'IT பிரிவு பதிவகப் படிவம்',
      'personalContactInfo': 'தனிப்பட்ட மற்றும் தொடர்பு தகவல்',
      'operatingRegion': 'செயல்படும் பகுதி',
      'socialMediaAnalytics': 'சமூக ஊடக தகவல் மற்றும் பகுப்பாய்வு',
      'digitalSkills': 'டிஜிட்டல் திறன் திறன்கள்',
      'submitApplication': 'விண்ணப்பத்தைச் சமர்ப்பிக்கவும்',
      'itWingSuccess': 'IT பிரிவு சுயவிவரம் வெற்றிகரமாக சமர்ப்பிக்கப்பட்டது!',
    }
  };

  String get(String key) {
    return _localizedValues[language]?[key] ?? key;
  }
}

class LanguageNotifier extends StateNotifier<AppLanguage> {
  LanguageNotifier() : super(AppLanguage.english);

  void toggleLanguage() {
    state = state == AppLanguage.english ? AppLanguage.tamil : AppLanguage.english;
  }
}

final languageProvider = StateNotifierProvider<LanguageNotifier, AppLanguage>((ref) {
  return LanguageNotifier();
});

final localizationProvider = Provider<AppLocalization>((ref) {
  final lang = ref.watch(languageProvider);
  return AppLocalization(lang);
});

// Shortcut extension to easily use translations in widgets
extension LocalizationExtension on BuildContext {
  String tr(String key, WidgetRef ref) {
    return ref.watch(localizationProvider).get(key);
  }
}
