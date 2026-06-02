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
      'enterOtp': 'Enter OTP Verification Code',
      'verifyLogin': 'Verify & Login',
      'secureSignIn': 'Secure Sign In',
      'userId': 'Leadership User ID',
      'password': 'Password',
      'phoneHelper': 'Include country code (e.g. +91)',
      'sosTitle': 'EMERGENCY SOS',
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
    },
    AppLanguage.tamil: {
      'appName': 'த.நா கட்சி இணைப்பு',
      'tagline': 'தமிழ்நாடு முழுவதும் உள்ள தலைவர்களையும் உறுப்பினர்களையும் இணைக்கிறது',
      'welcome': 'வரவேற்கிறோம்',
      'memberPortal': 'உறுப்பினர் போர்டல்',
      'leadershipPortal': 'தலைமை போர்டல்',
      'browseDirectory': 'பொது வழிகாட்டியை உலாவுக',
      'sendOtp': 'சரிபார்ப்பு OTP-ஐ அனுப்பவும்',
      'enterOtp': 'OTP சரிபார்ப்புக் குறியீட்டை உள்ளிடவும்',
      'verifyLogin': 'சரிபார்த்து உள்நுழைக',
      'secureSignIn': 'பாதுகாப்பான உள்நுழைவு',
      'userId': 'தலைமை பயனர் ஐடி',
      'password': 'கடவுச்சொல்',
      'phoneHelper': 'நாட்டின் குறியீட்டைச் சேர்க்கவும் (எ.கா. +91)',
      'sosTitle': 'அவசர SOS',
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
