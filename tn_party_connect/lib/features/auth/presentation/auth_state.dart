import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_repository.dart';

abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthOTPSent extends AuthState {
  final String verificationId;
  final String phoneNumber;
  final bool isRegistering;
  const AuthOTPSent(this.verificationId, this.phoneNumber, this.isRegistering);
}

class AuthNeedsRegistration extends AuthState {
  final String uid;
  final String phoneNumber;
  const AuthNeedsRegistration(this.uid, this.phoneNumber);
}

class AuthAuthenticated extends AuthState {
  final AuthUser user;
  const AuthAuthenticated(this.user);
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AuthInitial());

  /// Log in as a leader with User ID and Password
  Future<void> loginAsLeader(String username, String password) async {
    state = const AuthLoading();
    try {
      final user = await _repository.loginLeader(username, password);
      if (user != null) {
        state = AuthAuthenticated(user);
      } else {
        state = const AuthError("Leadership login returned null profile.");
      }
    } catch (e) {
      state = AuthError(e.toString().replaceAll("Exception: ", ""));
    }
  }

  /// Request Phone OTP for Member registration/login
  Future<void> sendMemberOTP(String mobileNumber, {required bool isRegistering}) async {
    state = const AuthLoading();
    try {
      await _repository.requestOTP(
        mobileNumber,
        onCodeSent: (verId) {
          state = AuthOTPSent(verId, mobileNumber, isRegistering);
        },
        onVerificationFailed: (e) {
          state = AuthError(e.message ?? "Phone authentication failed.");
        },
        onVerificationCompleted: (cred) async {
          // If auto-verified, proceed
        },
      );
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  /// Verify mobile OTP code
  Future<void> verifyMemberOTP(String verificationId, String smsCode, {required bool isRegistering}) async {
    state = const AuthLoading();
    try {
      final user = await _repository.verifyOTP(verificationId, smsCode);
      if (user == null) {
        state = const AuthError("Verification failed.");
        return;
      }

      if (user.fullName == 'New Member') {
        if (!isRegistering) {
          // Attempted login but not registered
          state = const AuthError("This mobile number is not registered. Please select 'Register as New Person' to sign up.");
          await _repository.logout();
        } else {
          state = AuthNeedsRegistration(user.uid, user.mobileNumber ?? '');
        }
      } else {
        state = AuthAuthenticated(user);
      }
    } catch (e) {
      state = AuthError(e.toString().replaceAll("Exception: ", ""));
    }
  }

  /// Register new member profile
  Future<void> registerMember({
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
    state = const AuthLoading();
    try {
      await _repository.registerMemberProfile(
        uid: uid,
        fullName: fullName,
        dob: dob,
        mobileNumber: mobileNumber,
        alternateMobileNumber: alternateMobileNumber,
        address: address,
        district: district,
        taluk: taluk,
        village: village,
        area: area,
        ward: ward,
        profilePhotoUrl: profilePhotoUrl,
      );

      final user = AuthUser(
        uid: uid,
        fullName: fullName,
        role: 'member',
        assignedRegion: {
          'district': district,
          'taluk': taluk,
          'village': village,
          'area': area,
          'ward': ward,
        },
        mobileNumber: mobileNumber,
        status: 'pending',
      );
      state = AuthAuthenticated(user);
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  /// Reset state to login
  void reset() {
    state = const AuthInitial();
  }

  /// Log out
  Future<void> logout() async {
    await _repository.logout();
    state = const AuthInitial();
  }
}

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthNotifier(repo);
});
