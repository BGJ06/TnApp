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
      'filterAll': 'All',
      'filterEmergency': 'Emergency',
      'filterAnnouncements': 'Announcements',
      'filterEvents': 'Events',
      'filterApprovals': 'Approvals',
      'filterTasks': 'Tasks',
      'notifCatEmergency': 'Emergency',
      'notifCatApproval': 'Approval',
      'notifCatEvent': 'Event',
      'notifCatAnnouncement': 'Announcement',
      'notifCatTask': 'Task',
      'notifSosTitle': 'SOS Emergency Alert Raised',
      'notifSosDesc': 'Arun Mozhi raised a critical SOS in Egmore Ward 119.',
      'notifApprovalTitle': 'New Member Registration Approved',
      'notifApprovalDesc': 'Senthil Kumar (Egmore) was verified and approved into Chennai district.',
      'notifItCampTitle': 'IT Boot Camp Registration Open',
      'notifItCampDesc': 'Register now for the upcoming digital campaign boot camp on June 18.',
      'notifConfTitle': 'State Conference Announcement',
      'notifConfDesc': 'Vanakkam! The statewide leadership conference date has been set for June 15.',
      'notifTaskTitle': 'Task Assigned: IT Wing Verification',
      'notifTaskDesc': 'Verify 4 new influencer profiles within Egmore region.',
      'notifBloodTitle': 'Blood Donation Camp',
      'notifBloodDesc': 'Join the party blood donation camp at Egmore HQ tomorrow from 9 AM.',
      
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
      'districtHubTitle': 'District Hub',
      'districtCoordinator': 'District Coordinator',
      'activeLeaders': 'Active Leaders',
      'pendingApprovals': 'Pending Approvals',
      'pendingRegistrations': 'Pending Member Registrations',
      'pendingCount': 'Pending',
      'allApproved': 'All regional applications approved!',
      'memberApprovedMsg': 'Member Registration Approved!',
      'memberRejectedMsg': 'Member Registration Rejected',
      'stateHdTitle': 'State Headquarters Dashboard',
      'stateCommandSubtitle': 'State Command & Analytics Control Center',
      'itWings': 'IT Wings',
      'districtsReached': 'Districts Reached',
      'emergencyMonitoring': 'Emergency Monitoring Queue',
      'critical': 'CRITICAL',
      'noActiveSos': 'No active emergency SOS requests reported at this time.',
      'acknowledge': 'Acknowledge',
      'markResolved': 'Mark Resolved',
      'itWingSearchMatrix': 'IT Wing Search Matrix',
      'itWingSearchDesc': 'Search and filter digital content writers, videographers, and graphic designers across Tamil Nadu.',
      'districtMembers': 'District Members',
      'followersCount': 'Followers Count (e.g. 5000)',
      'reachLabel': 'Estimated Monthly Reach',
      'memberRegistration': 'Member Registration',
      'fullNameAsId': 'Full Name (As in ID proof)',
      'selectDob': 'Select Date of Birth',
      'mobileVerified': 'Mobile (Verified)',
      'alternateMobile': 'Alternate Mobile (Optional)',
      'fullAddress': 'Full Residential Address',
      'villageAreaName': 'Village / Area Name',
      'wardNumber': 'Ward Number',
      'completeRegistration': 'Complete Registration & Submit',
      'approved': 'Approved',
      'l1MemberAccess': 'L1: Standard Member',
      'l2ExecutiveAccess': 'L2: Executive Command',
      'memberManagementCrm': 'Member Management CRM',
      'searchMembersByName': 'Search Members by Name',
      'filterByTaluk': 'Filter by Taluk',
      'swipeLeftToReject': 'Swipe Left to Reject',
      'swipeRightToApprove': 'Swipe Right to Approve',
      'noPendingRecords': 'No matching pending member records.',
      'approvedLabel': 'APPROVED',
      'pendingLabel': 'PENDING',
      'instagramLabel': 'Instagram Username (e.g. @username)',
      'facebookLabel': 'Facebook Page URL',
      'xLabel': 'X (Twitter) Username',
      'youtubeLabel': 'YouTube Channel Name',
      'telegramLabel': 'Telegram Channel Username',
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
      'filterAll': 'அனைத்தும்',
      'filterEmergency': 'அவசரநிலை',
      'filterAnnouncements': 'அறிவிப்புகள்',
      'filterEvents': 'நிகழ்வுகள்',
      'filterApprovals': 'அங்கீகாரங்கள்',
      'filterTasks': 'பணிகள்',
      'notifCatEmergency': 'அவசரநிலை',
      'notifCatApproval': 'அங்கீகாரம்',
      'notifCatEvent': 'நிகழ்வு',
      'notifCatAnnouncement': 'அறிவிப்பு',
      'notifCatTask': 'பணி',
      'notifSosTitle': 'SOS அவசர எச்சரிக்கை எழுப்பப்பட்டது',
      'notifSosDesc': 'எழும்பூர் வார்டு 119-ல் அருண் மொழி அவசர SOS எச்சரிக்கை எழுப்பியுள்ளார்.',
      'notifApprovalTitle': 'புதிய உறுப்பினர் சேர்க்கை அங்கீகரிக்கப்பட்டது',
      'notifApprovalDesc': 'செந்தில் குமார் (எழும்பூர்) சென்னை மாவட்டத்தில் சரிபார்க்கப்பட்டு அங்கீகரிக்கப்பட்டார்.',
      'notifItCampTitle': 'IT பயிற்சி முகாம் பதிவு தொடங்கப்பட்டுள்ளது',
      'notifItCampDesc': 'ஜூன் 18 அன்று நடைபெறவுள்ள டிஜிட்டல் பிரச்சார முகாமிற்கு இப்போது பதிவு செய்யுங்கள்.',
      'notifConfTitle': 'மாநில மாநாட்டு அறிவிப்பு',
      'notifConfDesc': 'வணக்கம்! மாநில அளவிலான தலைமை மாநாட்டுத் தேதி ஜூன் 15 என நிர்ணயிக்கப்பட்டுள்ளது.',
      'notifTaskTitle': 'பணி ஒதுக்கப்பட்டது: IT பிரிவு சரிபார்ப்பு',
      'notifTaskDesc': 'எழும்பூர் பகுதிக்குட்பட்ட 4 புதிய செல்வாக்கு செலுத்துபவர் சுயவிவரங்களைச் சரிபார்க்கவும்.',
      'notifBloodTitle': 'இரத்த தான முகாம்',
      'notifBloodDesc': 'நாளை காலை 9 மணி முதல் எழும்பூர் தலைமையகத்தில் நடைபெறும் இரத்த தான முகாமில் இணையுங்கள்.',
      
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
      'districtHubTitle': 'மாவட்ட மையம்',
      'districtCoordinator': 'மாவட்ட ஒருங்கிணைப்பாளர்',
      'activeLeaders': 'செயலில் உள்ள தலைவர்கள்',
      'pendingApprovals': 'நிலுவையில் உள்ள அங்கீகாரங்கள்',
      'pendingRegistrations': 'நிலுவையில் உள்ள உறுப்பினர் பதிவுகள்',
      'pendingCount': 'நிலுவையில் உள்ளது',
      'allApproved': 'அனைத்து பிராந்திய விண்ணப்பங்களும் அங்கீகரிக்கப்பட்டன!',
      'memberApprovedMsg': 'உறுப்பினர் பதிவு அங்கீகரிக்கப்பட்டது!',
      'memberRejectedMsg': 'உறுப்பினர் பதிவு நிராகரிக்கப்பட்டது',
      'stateHdTitle': 'மாநில தலைமையக டாஷ்போர்டு',
      'stateCommandSubtitle': 'மாநில கட்டளை மற்றும் பகுப்பாய்வு கட்டுப்பாட்டு மையம்',
      'itWings': 'IT பிரிவுகள்',
      'districtsReached': 'அடைந்த மாவட்டங்கள்',
      'emergencyMonitoring': 'அவசரகால கண்காணிப்பு வரிசை',
      'critical': 'முக்கியமானது',
      'noActiveSos': 'இந்த நேரத்தில் செயலில் உள்ள அவசரகால SOS கோரிக்கைகள் எதுவும் புகாரளிக்கப்படவில்லை.',
      'acknowledge': 'ஏற்றுக்கொள்',
      'markResolved': 'தீர்க்கப்பட்டதாகக் குறிக்கவும்',
      'itWingSearchMatrix': 'IT பிரிவு தேடல் மேட்ரிக்ஸ்',
      'itWingSearchDesc': 'தமிழ்நாடு முழுவதும் உள்ள டிஜிட்டல் உள்ளடக்க எழுத்தாளர்கள், வீடியோகிராஃபர்கள் மற்றும் கிராஃபிக் வடிவமைப்பாளர்களைத் தேடி வடிகட்டவும்.',
      'districtMembers': 'மாவட்ட உறுப்பினர்கள்',
      'followersCount': 'பின்தொடர்பவர்களின் எண்ணிக்கை (எ.கா. 5000)',
      'reachLabel': 'மதிப்பிடப்பட்ட மாதந்திர சென்றடைவு',
      'memberRegistration': 'உறுப்பினர் பதிவு',
      'fullNameAsId': 'முழு பெயர் (அடையாள அட்டையில் உள்ளபடி)',
      'selectDob': 'பிறந்த தேதியைத் தேர்ந்தெடுக்கவும்',
      'mobileVerified': 'கைபேசி எண் (சரிபார்க்கப்பட்டது)',
      'alternateMobile': 'மாற்று கைபேசி எண் (விருப்பத்தேர்வு)',
      'fullAddress': 'முழு வீட்டு முகவரி',
      'villageAreaName': 'கிராமம் / பகுதியின் பெயர்',
      'wardNumber': 'வார்டு எண்',
      'completeRegistration': 'பதிவை முடித்து சமர்ப்பிக்கவும்',
      'approved': 'அங்கீகரிக்கப்பட்டது',
      'l1MemberAccess': 'நிலை 1: சாதாரண உறுப்பினர்',
      'l2ExecutiveAccess': 'நிலை 2: நிர்வாக அதிகாரம்',
      'memberManagementCrm': 'உறுப்பினர் மேலாண்மை சிஆர்எம் (CRM)',
      'searchMembersByName': 'உறுப்பினர்களைப் பெயரால் தேடுக',
      'filterByTaluk': 'வட்டார வாரியாக வடிகட்டவும்',
      'swipeLeftToReject': 'நிராகரிக்க இடதுபுறம் ஸ்வைப் செய்யவும்',
      'swipeRightToApprove': 'அங்கீகரிக்க வலதுபுறம் ஸ்வைப் செய்யவும்',
      'noPendingRecords': 'நிலுவையில் உள்ள உறுப்பினர் பதிவுகள் எதுவும் இல்லை.',
      'approvedLabel': 'அங்கீகரிக்கப்பட்டது',
      'pendingLabel': 'நிலுவையில் உள்ளது',
      'instagramLabel': 'இன்ஸ்டாகிராம் பயனர் பெயர் (எ.கா. @username)',
      'facebookLabel': 'பேஸ்புக் பக்கத்தின் URL',
      'xLabel': 'X (ட்விட்டர்) பயனர் பெயர்',
      'youtubeLabel': 'யூடியூப் சேனல் பெயர்',
      'telegramLabel': 'டெலிகிராம் சேனல் பயனர் பெயர்',
    }
  };

  static const Map<String, String> _tamilNames = {
    'Arun Mozhi': 'அருண் மொழி',
    'Dr. Thanga Pandian': 'டாக்டர் தங்க பாண்டியன்',
    'A. Durai Murugan': 'ஏ. துரை முருகன்',
    'Kavin Kumar': 'கவின் குமார்',
    'Selvam Muthu': 'செல்வம் முத்து',
    'Ramanathan': 'ராமநாதன்',
    'Velu': 'வேலு',
    'R. Ramakrishnan': 'ஆர். ராமகிருஷ்ணன்',
    'P. R. Pandian': 'பி. ஆர். பாண்டியன்',
    'Alagiri': 'அழகிரி',
    'M. Sundar': 'எம். சுந்தர்',
    'K. Ganesan': 'கே. கணேசன்',
    'S. Thirunavukkarasu': 'எஸ். திருநாவுக்கரசு',
    'V. Shunmugavel': 'வி. சண்முகவேல்',
    'P. Kathirvel': 'பி. கதிர்வேல்',
    'T. Jagadeesan': 'டி. ஜெகதீசன்',
    'M. Christopher': 'எம். கிறிஸ்டோபர்',
    'L. Muruganandam': 'எல். முருகானந்தம்',
    'R. Prabhakaran': 'ஆர். பிரபாகரன்',
    'P. Subramanian': 'பி. சுப்பிரமணியன்',
    'V. Rajamani': 'வி. ராஜாமணி',
    'S. Palanisamy': 'எஸ். பழனிசாமி',
    'K. Anbarasan': 'கே. அன்பரசன்',
    'G. Elangovan': 'ஜி. இளங்கோவன்',
    'V. Senthil Balaji': 'வி. செந்தில் பாலாஜி',
    'R. Jayakumar': 'ஆர். ஜெயக்குமார்',
    'A. Radhakrishnan': 'ஏ. ராதாகிருஷ்ணன்',
    'M. Selvaraj': 'எம். செல்வராஜ்',
    'P. Ramasamy': 'பி. ராமசாமி',
    'S. H. Raju': 'எஸ். எச். ராஜு',
    'R. Rajendran': 'ஆர். ராஜேந்திரன்',
    'C. Muthukumaran': 'சி. முத்துக்குமரன்',
    'K. Muthuramalingam': 'கே. முத்துராமலிங்கம்',
    'S. Ravi': 'எஸ். ரவி',
    'T. R. Karuppiah': 'டி. ஆர். கருப்பையா',
    'S. Pandiarajan': 'எஸ். பாண்டியராஜன்',
    'R. Thangathurai': 'ஆர். தங்கதுரை',
    'P. Geetha Jeevan': 'பி. கீதா ஜீவன்',
    'K. Devaraj': 'கே. தேவராஜ்',
    'M. Sakthivel': 'எம். சக்திவேல்',
    'G. Hari': 'ஜி. ஹரி',
    'E. V. Velu': 'எ.வ. வேலு',
    'R. Kamaraj': 'ஆர். காமராஜ்',
    'C. V. Shanmugam': 'சி. வி. சண்முகம்',
    'K. K. S. S. R. Ramachandran': 'கே.கே.எஸ்.எஸ்.ஆர். ராமச்சந்திரன்',
    'K. Pandiarajan': 'கே. பாண்டியராஜன்',
    'M. Shenbagaraj': 'எம். செண்பகராஜ்',
    'S. Ponnusamy': 'எஸ். பொன்னுசாமி',
    'T. Mariappan': 'டி. மாரியப்பன்',
    'P. Subburaj': 'பி. சுப்புராஜ்',
    'V. Karuppasamy': 'வி. கருப்பசாமி',
    'A. Ramakrishnan': 'ஏ. ராமகிருஷ்ணன்',
    'K. Gurusamy': 'கே. குருசாமி',
    'Senthil Kumar': 'செந்தில் குமார்',
    'Meenakshi Sundaram': 'மீனாக்ஷி சுந்தரம்',
    'Vijay Raghavan': 'விஜய் ராகவன்',
    'Venkatesh Prasad': 'வெங்கடேஷ் பிரசாத்',
    'Priyanka Bose': 'பிரியங்கா போஸ்',
    'Senthil Nathan': 'செந்தில் நாதன்',
    'Madan Gopal': 'மதன் கோபால்',
    'Guest User': 'விருந்தினர்',
    'Leader': 'தலைவர்',
    'Member': 'உறுப்பினர்',
    'New Member': 'புதிய உறுப்பினர்',
    
    // Ariyalur MLAs
    'S.S. Sivasankar / Latha Balu': 'எஸ்.எஸ். சிவசங்கர் / லதா பாலு',
    'Ka. So. Ka. Kannan': 'க. சொ. க. கண்ணன்',
    'S.S. Sivasankar': 'எஸ்.எஸ். சிவசங்கர்',

    // Chengalpattu MLAs
    'M.K.D. Karthik Dhandapani': 'எம்.கே.டி. கார்த்திக் தண்டபாணி',
    'M. Babu': 'எம். பாபு',
    'K. Maragatham (Regional Context) / S. Amulu Ponmalar': 'கே. மரகதம் (வட்டார சூழல்) / எஸ். அமுலு பொன்மலர்',
    'I. Karunanithi': 'ஐ. கருணாநிதி',
    'S. Aravind Ramesh': 'எஸ். அரவிந்த் ரமேஷ்',
    'S.R. Raja': 'எஸ்.ஆர். ராஜா',
    'S.S. Balaji (Alliance)': 'எஸ்.எஸ். பாலாஜி (கூட்டணி)',

    // Chennai MLAs
    'Udhayanidhi Stalin': 'உதயநிதி ஸ்டாலின்',
    'P.K. Sekarbabu': 'பி.கே. சேகர்பாபு',
    'M.K. Stalin': 'மு.க. ஸ்டாலின்',
    'C. Joseph Vijay': 'சி. ஜோசப் விஜய்',

    // Coimbatore MLAs
    'Thalapathi Murugesan (Regional Lead)': 'தளபதி முருகேசன் (வட்டாரத் தலைவர்)',
    'R. Krishnan': 'ஆர். கிருஷ்ணன்',
    'Kurichi Prabhakaran': 'குறிச்சி பிரபாகரன்',
    'T.R. Shanmugasundaram': 'டி.ஆர். சண்முகசுந்தரம்',
    'Dr. K. Varadharajan': 'டாக்டர் கே. வரதராஜன்',
    'Thalapathi Murugesan': 'தளபதி முருகேசன்',
    'N.R. Karthikeyan': 'என்.ஆர். கார்த்திகேயன்',
    'K. Radhakrishnan / Jayakumar': 'கே. ராதாகிருஷ்ணன் / ஜெயகுமார்',
    'M. Arumugam (Alliance)': 'எம். ஆறுமுகம் (கூட்டணி)',

    // Madurai MLAs
    'P. Moorthy': 'பி. மூர்த்தி',
    'C. Chinnammal': 'சி. சின்னம்மாள்',
    'N. Selvaraj': 'என். செல்வராஜ்',
    'A. Venkatesan': 'ஏ. வெங்கடேசன்',
    'M. Manimaran': 'எம். மணிமாறன்',
    'V.V. Rajan Chellappa (Contextual reference) / G. Thalapathi': 'வி.வி. ராஜன் செல்லப்பா (சூழல் குறிப்பு) / ஜி. தளபதி',
    'P.V. Kathiravan': 'பி.வி. கதிரவன்',

    // Virudhunagar MLAs
    'S. Thangapandian': 'எஸ். தங்கபாண்டியன்',
    'A.R.R. Raghuraman': 'ஏ.ஆர்.ஆர். ரகுராமன்',
    'G. Ashokan (Alliance)': 'ஜி. அசோகன் (கூட்டணி)',
    'V. Ponnupandian (Alliance)': 'வி. பொன்னுகோவிந்தன் (கூட்டணி)',
    'Thangam Thennarasu': 'தங்கம் தென்னரசு',
    'A.R.R. Raghuraman / Selvam P.': 'ஏ.ஆர்.ஆர். ரகுராமன் / செல்வம் பி.',

    // Roles and other labels
    'District Co-Head': 'மாவட்ட இணைத் தலைவர்',
    'Demo Member': 'மாதிரி உறுப்பினர்',
  };

  static const Map<String, String> districtTamilNames = {
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

  static const Map<String, String> regionTamilNames = {
    'Tamil Nadu (Statewide)': 'தமிழ்நாடு (மாநிலம் முழுவதும்)',
    'Chennai District': 'சென்னை மாவட்டம்',
    'Egmore Taluk': 'எழும்பூர் தாலுகா',
    'Ward 119 (Egmore)': 'வார்டு 119 (எழும்பூர்)',
    'Coimbatore District': 'கோயம்புத்தூர் மாவட்டம்',
    'Madurai District': 'மதுரை மாவட்டம்',
    'Melur Taluk': 'மேலூர் தாலுகா',
    'Salem District': 'சேலம் மாவட்டம்',
    'Trichy District': 'திருச்சி மாவட்டம்',
    'Thanjavur District': 'தஞ்சாவூர் மாவட்டம்',
    'Tirunelveli District': 'திருநெல்வேலி மாவட்டம்',
    'Vellore District': 'வேலூர் மாவட்டம்',
    'Erode District': 'ஈரோடு மாவட்டம்',
    'Kanyakumari District': 'கன்னியாகுமரி மாவட்டம்',
    'Ariyalur District': 'அரியலூர் மாவட்டம்',
    'Chengalpattu District': 'செங்கல்பட்டு மாவட்டம்',
    'Cuddalore District': 'கடலூர் மாவட்டம்',
    'Dharmapuri District': 'தர்மபுரி மாவட்டம்',
    'Dindigul District': 'திண்டுக்கல் மாவட்டம்',
    'Kallakurichi District': 'கள்ளக்குறிச்சி மாவட்டம்',
    'Kanchipuram District': 'காஞ்சிபுரம் மாவட்டம்',
    'Karur District': 'கரூர் மாவட்டம்',
    'Krishnagiri District': 'கிருஷ்ணகிரி மாவட்டம்',
    'Mayiladuthurai District': 'மயிலாடுதுறை மாவட்டம்',
    'Nagapattinam District': 'நாகப்பட்டினம் மாவட்டம்',
    'Namakkal District': 'நாமக்கல் மாவட்டம்',
    'Nilgiris District': 'நீலகிரி மாவட்டம்',
    'Perambalur District': 'பெரம்பலூர் மாவட்டம்',
    'Pudukkottai District': 'புதுக்கோட்டை மாவட்டம்',
    'Ramanathapuram District': 'இராமநாதபுரம் மாவட்டம்',
    'Ranipet District': 'ராணிப்பேட்டை மாவட்டம்',
    'Sivaganga District': 'சிவகங்கை மாவட்டம்',
    'Tenkasi District': 'தென்காசி மாவட்டம்',
    'Theni District': 'தேனி மாவட்டம்',
    'Thoothukudi District': 'தூத்துக்குடி மாவட்டம்',
    'Tirupathur District': 'திருப்பத்தூர் மாவட்டம்',
    'Tiruppur District': 'திருப்பூர் மாவட்டம்',
    'Tiruvallur District': 'திருவள்ளூர் மாவட்டம்',
    'Tiruvannamalai District': 'திருவண்ணாமலை மாவட்டம்',
    'Tiruvarur District': 'திருவாரூர் மாவட்டம்',
    'Viluppuram District': 'விழுப்புரம் மாவட்டம்',
    'Virudhunagar District': 'விருதுநகர் மாவட்டம்',
    'Virudhunagar Main': 'விருதுநகர் மெயின்',
    'Soolakkarai Area': 'சூலக்கரை பகுதி',
    'Allampatti Area': 'அல்லம்பட்டி பகுதி',
    'Pandian Nagar Area': 'பாண்டியன் நகர் பகுதி',
    'Ramalingapuram Village': 'ராமலிங்கபுரம் கிராமம்',
    'Sattur Town Area': 'சாத்தூர் நகர பகுதி',
    'Virudhunagar Taluk': 'விருதுநகர் தாலுகா',
    'Sattur Taluk': 'சாத்தூர் தாலுகா',
  };

  static const Map<String, String> _villageTamilNames = {
    'Virudhunagar Main': 'விருதுநகர் மெயின்',
    'Soolakkarai': 'சூலக்கரை',
    'Allampatti': 'அல்லம்பட்டி',
    'Pandian Nagar': 'பாண்டியன் நகர்',
    'Ramalingapuram': 'ராமலிங்கபுரம்',
    'Sattur Town': 'சாத்தூர் நகரம்',
    'Padanthal': 'பதந்தால்',
    'Venkatachalapuram': 'வெங்கடாசலபுரம்',
    'Ward 119 (Egmore)': 'வார்டு 119 (எழும்பூர்)',
    'Egmore Station Area': 'எழும்பூர் நிலைய பகுதி',
    'Spurtank Road': 'ஸ்பர்டேங்க் சாலை',
  };

  static const Map<String, String> _constituencyTamilNames = {
    'Kolathur': 'கொளத்தூர்',
    'Chepauk-Thiruvallikeni': 'சேப்பாக்கம்-திருவல்லிக்கேணி',
    'Harbour': 'துறைமுகம்',
    'Perambur': 'பெரம்பூர்',
    'Madurantakam': 'மதுராந்தகம்',
    'Ranipet': 'ராணிப்பேட்டை',
    'Katpadi': 'காட்பாடி',
    'Tiruvannamalai': 'திருவண்ணாமலை',
    'Kallakurichi': 'கள்ளக்குறிச்சி',
    'Salem (North)': 'சேலம் (வடக்கு)',
    'Erode (West)': 'ஈரோடு (மேற்கு)',
    'Coimbatore (North)': 'கோயம்புத்தூர் (வடக்கு)',
    'Coimbatore (South)': 'கோயம்புத்தூர் (தெற்கு)',
    'Athoor': 'ஆத்தூர்',
    'Tiruchirappalli West': 'திருச்சிராப்பள்ளி மேற்கு',
    'Tiruchirappalli (East)': 'திருச்சிராப்பள்ளி (கிழக்கு)',
    'Thanjavur': 'தஞ்சாவூர்',
    'Madurai Central': 'மதுரை மத்திய',
    'Madurai West': 'மதுரை மேற்கு',
    'Virudhunagar': 'விருதுநகர்',
    'Aruppukkottai': 'அருப்புக்கோட்டை',
    'Tiruchendur': 'திருச்செந்தூர்',
    'Radhapuram': 'ராதாபுரம்',
    
    // Ariyalur Constituencies
    'Ariyalur': 'அரியலூர்',
    'Jayankondam': 'ஜெயங்கொண்டம்',
    'Kunnam': 'குன்னம்',

    // Chengalpattu Constituencies
    'Chengalpattu': 'செங்கல்பட்டு',
    'Cheyyur': 'செய்யூர்',
    'Pallavaram': 'பல்லாவரம்',
    'Shozhinganallur': 'சோழிங்கநல்லூர்',
    'Tambaram': 'தாம்பரம்',
    'Thiruporur': 'திருப்போரூர்',

    // Coimbatore Constituencies
    'Avanashi': 'அவநாசி',
    'Kavundampalayam': 'கவுண்டம்பாளையம்',
    'Kinathukadavu': 'கிணத்துக்கடவு',
    'Mettuppalayam': 'மேட்டுப்பாளையம்',
    'Pollachi': 'பொள்ளாச்சி',
    'Sulur': 'சூலூர்',
    'Thondamuthur': 'தொண்டாமுத்தூர்',
    'Udumalaipettai': 'உடுமலைப்பேட்டை',
    'Valparai': 'வால்பாறை',

    // Madurai Constituencies
    'Madurai East': 'மதுரை கிழக்கு',
    'Melur': 'மேலூர்',
    'Sholavandan': 'சோழவந்தான்',
    'Thirumangalam': 'திருமங்கலம்',
    'Thiruparankundram': 'திருப்பரங்குன்றம்',
    'Usilampatti': 'உசிலம்பட்டி',

    // Virudhunagar Constituencies
    'Rajapalayam': 'ராஜபாளையம்',
    'Sattur': 'சாத்தூர்',
    'Sivakasi': 'சிவகாசி',
    'Srivilliputhur': 'ஸ்ரீவில்லிபுத்தூர்',
    'Tiruchuli': 'திருச்சுழி',
  };

  static const Map<String, String> _positionTamilNames = {
    'State President': 'மாநிலத் தலைவர்',
    'State General Secretary': 'மாநிலப் பொதுச் செயலாளர்',
    'State IT Wing Head': 'மாநில IT பிரிவுத் தலைவர்',
    'District Head': 'மாவட்டத் தலைவர்',
    'District Co-Head': 'மாவட்ட இணைத் தலைவர்',
    'Taluk Head': 'தாலுகா தலைவர்',
    'Ward Head': 'வார்டு தலைவர்',
    'Area Coordinator': 'பகுதி ஒருங்கிணைப்பாளர்',
    'Helping Person (Active)': 'உதவி செய்யும் நபர் (செயலில்)',
    'Demo Member': 'மாதிரி உறுப்பினர்',
  };

  static const Map<String, String> _skillTamilNames = {
    'Graphic Design': 'கிராஃபிக் வடிவமைப்பு',
    'Video Editing': 'வீடியோ எடிட்டிங்',
    'Photography': 'புகைப்படம் எடுத்தல்',
    'Videography': 'வீடியோகிராபி',
    'Public Speaking': 'பேச்சாற்றல்',
    'Content Writing': 'எழுத்தாற்றல்',
    'Social Media Management': 'சமூக ஊடக மேலாண்மை',
    'Web Development': 'இணையதள மேம்பாடு',
    'App Development': 'செயலி மேம்பாடு',
    'Campaign Management': 'பிரச்சார மேலாண்மை',
  };

  String translateName(String name) {
    if (language == AppLanguage.tamil) {
      final match = RegExp(r'^([^(]+)\s*\(([^)]+)\)$').firstMatch(name);
      if (match != null) {
        final baseName = match.group(1)!.trim();
        final role = match.group(2)!.trim();
        
        final translatedBaseName = _tamilNames[baseName] ?? baseName;
        final translatedRole = _positionTamilNames[role] ?? role;
        
        return '$translatedBaseName ($translatedRole)';
      }
      return _tamilNames[name] ?? name;
    }
    return name;
  }

  String translateDistrict(String name) {
    if (language == AppLanguage.tamil) {
      return districtTamilNames[name] ?? name;
    }
    return name;
  }

  String translateTaluk(String talukName) {
    if (language != AppLanguage.tamil) return talukName;
    final key = '$talukName Taluk';
    final regionKey = '$talukName Region';
    final areaKey = '$talukName Area';
    final villageKey = '$talukName Village';

    if (regionTamilNames.containsKey(key)) {
      return regionTamilNames[key]!.replaceAll(' தாலுகா', '').replaceAll(' Taluk', '');
    }
    if (regionTamilNames.containsKey(regionKey)) {
      return regionTamilNames[regionKey]!;
    }
    if (regionTamilNames.containsKey(areaKey)) {
      return regionTamilNames[areaKey]!.replaceAll(' பகுதி', '');
    }
    if (regionTamilNames.containsKey(villageKey)) {
      return regionTamilNames[villageKey]!.replaceAll(' கிராமம்', '');
    }
    if (regionTamilNames.containsKey(talukName)) {
      return regionTamilNames[talukName]!;
    }
    
    switch (talukName) {
      // Chennai
      case 'Alandur': return 'ஆலந்தூர்';
      case 'Ambattur': return 'அம்பத்தூர்';
      case 'Aminjikarai': return 'அமிஞ்சிகரை';
      case 'Ayanavaram': return 'அயனாவரம்';
      case 'Egmore': return 'எழும்பூர்';
      case 'Guindy': return 'கிண்டி';
      case 'Madhavaram': return 'மாதவரம்';
      case 'Maduravoyal': return 'மதுரவாயல்';
      case 'Mambalam': return 'மாம்பலம்';
      case 'Mylapore': return 'மயிலாப்பூர்';
      case 'Perambur': return 'பெரம்பூர்';
      case 'Pursawalkam': return 'புரசைவாக்கம்';
      case 'Sholinganallur': return 'சோழிங்கநல்லூர்';
      case 'Thiruvotriyur': return 'திருவொற்றியூர்';
      case 'Tondiarpet': return 'தண்டையார்பேட்டை';
      case 'Velachery': return 'வேளச்சேரி';
      
      // Coimbatore
      case 'Anaimalai': return 'ஆனைமலை';
      case 'Annur': return 'அன்னூர்';
      case 'Karamadai': return 'காரமடை';
      case 'Kinathukadavu': return 'கிணத்துக்கடவு';
      case 'Madukkarai': return 'மதுக்கரை';
      case 'P.N.Palayam': return 'பெ.நா.பாளையம்';
      case 'Pollachi(N)': return 'பொள்ளாச்சி (வடக்கு)';
      case 'Pollachi(S)': return 'பொள்ளாச்சி (தெற்கு)';
      case 'Pollachi': return 'பொள்ளாச்சி';
      case 'S.S.Kulam': return 'ச.ச.குளம்';
      case 'Sultanpet': return 'சுல்தான்பேட்டை';
      case 'Sulur': return 'சூலூர்';
      case 'Thondamuthur': return 'தொண்டாமுத்தூர்';
      
      // Madurai
      case 'Alanganallur': return 'அலங்காநல்லூர்';
      case 'Chellampatti': return 'செல்லம்பட்டி';
      case 'Kallikudi': return 'கல்லிக்குடி';
      case 'Kottampatti': return 'கொட்டாம்பட்டி';
      case 'Madurai East': return 'மதுரை கிழக்கு';
      case 'Madurai West': return 'மதுரை மேற்கு';
      case 'Melur': return 'மேலூர்';
      case 'Sedapatti': return 'சேடாபட்டி';
      case 'T.Kallupatty': return 'தி.கல்லுப்பட்டி';
      case 'Thirumangalam': return 'திருமங்கலம்';
      case 'Thirupparankundram': return 'திருப்பரங்குன்றம்';
      case 'Usilampatti': return 'உசிலம்பட்டி';
      case 'Vadipatti': return 'வாடிப்பட்டி';
      
      // Virudhunagar
      case 'Aruppukottai': return 'அருப்புக்கோட்டை';
      case 'Kariapatti': return 'கரியாபட்டி';
      case 'Narikudi': return 'நரிக்குடி';
      case 'Rajapalayam': return 'ராஜபாளையம்';
      case 'Sattur': return 'சாத்தூர்';
      case 'Sivakasi': return 'சிவகாசி';
      case 'Srivilliputhur': return 'ஸ்ரீவில்லிபுத்தூர்';
      case 'Tiruchuli': return 'திருச்சுழி';
      case 'Vembakottai': return 'வெம்பக்கோட்டை';
      case 'Virudhunagar': return 'விருதுநகர்';
      case 'Watrap': return 'வத்திராயிருப்பு';
    }
    
    return talukName;
  }

  String translateRegion(String region) {
    if (language == AppLanguage.tamil) {
      return regionTamilNames[region] ?? region;
    }
    return region;
  }

  String translateVillage(String village) {
    if (language == AppLanguage.tamil) {
      return _villageTamilNames[village] ?? village;
    }
    return village;
  }

  String translateConstituency(String constituency) {
    if (language == AppLanguage.tamil) {
      return _constituencyTamilNames[constituency] ?? constituency;
    }
    return constituency;
  }

  String translatePosition(String position) {
    if (language == AppLanguage.tamil) {
      return _positionTamilNames[position] ?? position;
    }
    return position;
  }

  String translateSkill(String skill) {
    if (language == AppLanguage.tamil) {
      return _skillTamilNames[skill] ?? skill;
    }
    return skill;
  }

  String get(String key) {
    return _localizedValues[language]?[key] ?? key;
  }

  String translateError(String message) {
    if (language != AppLanguage.tamil) return message;
    final msg = message.trim();
    if (msg.contains("Invalid username/credentials in offline mode")) {
      return "ஆஃப்லைன் பயன்முறையில் தவறான பயனர் பெயர்/சான்றுகள்";
    }
    if (msg.contains("Incorrect password. Try")) {
      final matches = RegExp(r'Try "([^"]+)" or "([^"]+)"').firstMatch(msg);
      if (matches != null) {
        final pass1 = matches.group(1);
        final pass2 = matches.group(2);
        return 'தவறான கடவுச்சொல். "$pass1" அல்லது "$pass2" ஐ முயற்சிக்கவும்.';
      }
      return "தவறான கடவுச்சொல். தயவுசெய்து மீண்டும் முயற்சிக்கவும்.";
    }
    if (msg.contains("Invalid verification OTP code.")) {
      return "தவறான சரிபார்ப்பு OTP குறியீடு.";
    }
    if (msg.contains("This mobile number is not registered. Please select 'Register as New Person' to sign up.")) {
      return "இந்த கைபேசி எண் பதிவு செய்யப்படவில்லை. பதிவு செய்ய 'புதிய நபராக பதிவு செய்' என்பதைத் தேர்ந்தெடுக்கவும்.";
    }
    if (msg.contains("Phone authentication failed.")) {
      return "தொலைபேசி சரிபார்ப்பு தோல்வியடைந்தது.";
    }
    if (msg.contains("Verification failed.")) {
      return "சரிபார்ப்பு தோல்வியடைந்தது.";
    }
    if (msg.contains("Leadership login returned null profile.")) {
      return "தலைமை உள்நுழைவு வெற்று சுயவிவரத்தை அளித்தது.";
    }
    if (msg.contains("User authenticated but leadership profile does not exist in Firestore.")) {
      return "பயனர் சரிபார்க்கப்பட்டார், ஆனால் பயர்பேஸ் ஸ்டோரில் தலைமை சுயவிவரம் இல்லை.";
    }
    return message;
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
  String trName(String name, WidgetRef ref) {
    return ref.watch(localizationProvider).translateName(name);
  }
  String trDistrict(String name, WidgetRef ref) {
    return ref.watch(localizationProvider).translateDistrict(name);
  }
  String trTaluk(String name, WidgetRef ref) {
    return ref.watch(localizationProvider).translateTaluk(name);
  }
  String trRegion(String name, WidgetRef ref) {
    return ref.watch(localizationProvider).translateRegion(name);
  }
  String trVillage(String name, WidgetRef ref) {
    return ref.watch(localizationProvider).translateVillage(name);
  }
  String trConstituency(String name, WidgetRef ref) {
    return ref.watch(localizationProvider).translateConstituency(name);
  }
  String trPosition(String name, WidgetRef ref) {
    return ref.watch(localizationProvider).translatePosition(name);
  }
  String trSkill(String name, WidgetRef ref) {
    return ref.watch(localizationProvider).translateSkill(name);
  }
  String trError(String message, WidgetRef ref) {
    return ref.watch(localizationProvider).translateError(message);
  }
}
