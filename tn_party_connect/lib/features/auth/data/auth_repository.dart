import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../../../main.dart';
import '../../../core/constants.dart';

class AuthUser {
  final String uid;
  final String fullName;
  final String role;
  final Map<String, dynamic> assignedRegion;
  final String? mobileNumber;

  AuthUser({
    required this.uid,
    required this.fullName,
    required this.role,
    required this.assignedRegion,
    this.mobileNumber,
  });
}

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Mock users for offline demonstration
  static final List<AuthUser> _mockUsers = [
    AuthUser(
      uid: 'state_president_uid',
      fullName: 'Dr. Thanga Pandian (State President)',
      role: AppConstants.roleStatePresident,
      assignedRegion: {},
      mobileNumber: '+919000000001',
    ),
    AuthUser(
      uid: 'state_it_head_uid',
      fullName: 'Kavin Kumar (State IT Wing Head)',
      role: AppConstants.roleStateITHead,
      assignedRegion: {},
      mobileNumber: '+919000000002',
    ),
    AuthUser(
      uid: 'district_chennai_uid',
      fullName: 'Selvam Muthu (District Head)',
      role: AppConstants.roleDistrictHead,
      assignedRegion: {'district': 'Chennai'},
      mobileNumber: '+919000000003',
    ),
    AuthUser(
      uid: 'taluk_egmore_uid',
      fullName: 'Ramanathan (Taluk Head)',
      role: AppConstants.roleTalukHead,
      assignedRegion: {'district': 'Chennai', 'taluk': 'Egmore'},
      mobileNumber: '+919000000004',
    ),
    AuthUser(
      uid: 'ward_119_uid',
      fullName: 'Velu (Ward Head)',
      role: AppConstants.roleWardHead,
      assignedRegion: {'district': 'Chennai', 'taluk': 'Egmore', 'ward': '119'},
      mobileNumber: '+919000000005',
    ),
    AuthUser(
      uid: 'member_demo_uid',
      fullName: 'Arun Mozhi (Demo Member)',
      role: AppConstants.roleMember,
      assignedRegion: {'district': 'Chennai', 'taluk': 'Egmore', 'ward': '119'},
      mobileNumber: '+919876543210',
    ),
  ];

  /// Login a Leadership user using User ID + Password
  Future<AuthUser?> loginLeader(String username, String password) async {
    if (isFirebaseMocked) {
      // Offline Simulated Login check
      final user = _mockUsers.firstWhere(
        (u) => u.uid == '${username}_uid' || u.role.replaceAll('_', '') == username.replaceAll('_', ''),
        orElse: () => throw Exception('Invalid username/credentials in offline mode'),
      );
      if (password == 'password123') {
        return user;
      } else {
        throw Exception('Incorrect password');
      }
    }

    try {
      // Map User ID (e.g. state_president) -> Email (state_president@tnpartyconnect.org)
      final email = '$username@tnpartyconnect.org';
      UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (cred.user == null) return null;

      // Retrieve role configuration from Firestore "leaders" collection
      DocumentSnapshot doc = await _firestore
          .collection(AppConstants.collectionLeaders)
          .doc(cred.user!.uid)
          .get();

      if (!doc.exists) {
        throw Exception('User authenticated but leadership profile does not exist in Firestore.');
      }

      final data = doc.data() as Map<String, dynamic>;
      return AuthUser(
        uid: cred.user!.uid,
        fullName: data['fullName'] ?? 'Leader',
        role: data['role'] ?? AppConstants.roleWardHead,
        assignedRegion: Map<String, dynamic>.from(data['assignedRegion'] ?? {}),
        mobileNumber: data['mobileNumber'],
      );
    } catch (e) {
      debugPrint('Leader Login failed: $e');
      rethrow;
    }
  }

  /// Sends a SMS verification code to the target mobile number.
  /// (Wraps FirebaseAuth.verifyPhoneNumber)
  Future<void> requestOTP(
    String mobileNumber, {
    required Function(String verificationId) onCodeSent,
    required Function(FirebaseAuthException e) onVerificationFailed,
    required Function(PhoneAuthCredential credential) onVerificationCompleted,
  }) async {
    if (isFirebaseMocked) {
      onCodeSent("mock_verification_id_123");
      return;
    }

    await _auth.verifyPhoneNumber(
      phoneNumber: mobileNumber,
      verificationCompleted: onVerificationCompleted,
      verificationFailed: onVerificationFailed,
      codeSent: (verificationId, resendToken) => onCodeSent(verificationId),
      codeAutoRetrievalTimeout: (verificationId) {},
    );
  }

  /// Verifies OTP code and fetches member registration details.
  Future<AuthUser?> verifyOTP(String verificationId, String smsCode) async {
    if (isFirebaseMocked) {
      if (smsCode == '123456') {
        return _mockUsers.last; // Returns Demo Member
      } else {
        throw Exception('Invalid verification OTP code.');
      }
    }

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      UserCredential userCred = await _auth.signInWithCredential(credential);
      if (userCred.user == null) return null;

      // Check if this member has filled out registration details
      DocumentSnapshot doc = await _firestore
          .collection(AppConstants.collectionMembers)
          .doc(userCred.user!.uid)
          .get();

      if (!doc.exists) {
        // Return user with Member role but no local record (needs to register)
        return AuthUser(
          uid: userCred.user!.uid,
          fullName: 'New Member',
          role: AppConstants.roleMember,
          assignedRegion: {},
          mobileNumber: userCred.user!.phoneNumber,
        );
      }

      final data = doc.data() as Map<String, dynamic>;
      return AuthUser(
        uid: userCred.user!.uid,
        fullName: data['fullName'] ?? 'Member',
        role: AppConstants.roleMember,
        assignedRegion: {
          'district': data['district'],
          'taluk': data['taluk'],
          'village': data['village'],
          'area': data['area'],
          'ward': data['ward'],
        },
        mobileNumber: data['mobileNumber'] ?? userCred.user!.phoneNumber,
      );
    } catch (e) {
      debugPrint("OTP verification error: $e");
      rethrow;
    }
  }

  /// Registers a new member in Cloud Firestore
  Future<void> registerMemberProfile({
    required String uid,
    required String fullName,
    required String dob,
    required String mobileNumber,
    required String alternateMobileNumber,
    required String address,
    required String district,
    required String taluk,
    required String village,
    required String area,
    required String ward,
    required String profilePhotoUrl,
  }) async {
    if (isFirebaseMocked) {
      debugPrint("Mock Member registered successfully: $fullName");
      return;
    }

    final docData = {
      'uid': uid,
      'fullName': fullName,
      'dob': dob,
      'mobileNumber': mobileNumber,
      'alternateMobileNumber': alternateMobileNumber,
      'address': address,
      'district': district,
      'taluk': taluk,
      'village': village,
      'area': area,
      'ward': ward,
      'profilePhotoUrl': profilePhotoUrl,
      'registeredAt': FieldValue.serverTimestamp(),
      'status': 'pending',
      'role': AppConstants.roleMember,
    };

    await _firestore
        .collection(AppConstants.collectionMembers)
        .doc(uid)
        .set(docData);
  }

  /// Sign out
  Future<void> logout() async {
    if (!isFirebaseMocked) {
      await _auth.signOut();
    }
  }
}

// Provider for AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) => AuthRepository());
