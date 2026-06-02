import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme.dart';
import '../../../core/routes.dart';
import 'auth_state.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Controllers for Member Login
  final _phoneController = TextEditingController(text: "+91");
  final _otpController = TextEditingController();
  
  // Controllers for Leader Login
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKeyLeader = GlobalKey<FormState>();
  final _formKeyMember = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleStateNavigation(AuthState state) {
    if (state is AuthAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final role = state.user.role;
        if (role == 'member') {
          Navigator.pushReplacementNamed(context, AppRoutes.memberDashboard);
        } else if (role == 'state_president' || role == 'state_it_head') {
          Navigator.pushReplacementNamed(context, AppRoutes.stateDashboard);
        } else {
          Navigator.pushReplacementNamed(context, AppRoutes.districtDashboard);
        }
      });
    } else if (state is AuthNeedsRegistration) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(
          context, 
          AppRoutes.registration,
          arguments: {'uid': state.uid, 'phoneNumber': state.phoneNumber},
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authStateProvider);
    _handleStateNavigation(state);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark ? AppTheme.darkGradient : AppTheme.primaryGradient,
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Brand Header
                  Icon(
                    Icons.connect_without_contact,
                    size: 80,
                    color: isDark ? AppTheme.accentDark : AppTheme.secondaryLight,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'TN PARTY CONNECT',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tamil Nadu Political Network',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Core Input Card
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Custom styled TabBar
                          TabBar(
                            controller: _tabController,
                            indicatorColor: isDark ? AppTheme.secondaryDark : AppTheme.primaryLight,
                            labelColor: isDark ? Colors.white : AppTheme.primaryLight,
                            unselectedLabelColor: Colors.grey,
                            tabs: const [
                              Tab(text: 'Member Portal', icon: Icon(Icons.person_pin)),
                              Tab(text: 'Leadership', icon: Icon(Icons.admin_panel_settings)),
                            ],
                          ),
                          const SizedBox(height: 24),
                          
                          // Tab Content
                          SizedBox(
                            height: 260,
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                _buildMemberTab(state),
                                _buildLeaderTab(state),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Public Access Button
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.publicDirectory);
                    },
                    icon: const Icon(Icons.search, color: Colors.white),
                    label: const Text(
                      'Browse Public Directory',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMemberTab(AuthState state) {
    if (state is AuthOTPSent) {
      return Form(
        key: _formKeyMember,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter verification code sent to ${state.phoneNumber}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.lock_open),
                labelText: '6-digit OTP Code',
                border: OutlineInputBorder(),
              ),
              validator: (val) => val == null || val.length != 6 ? 'Enter 6 digits' : null,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_formKeyMember.currentState!.validate()) {
                  ref.read(authStateProvider.notifier).verifyMemberOTP(
                    state.verificationId,
                    _otpController.text.trim(),
                  );
                }
              },
              child: state is AuthLoading 
                  ? const CircularProgressIndicator(color: Colors.white) 
                  : const Text('Verify & Login'),
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () => ref.read(authStateProvider.notifier).reset(),
                child: const Text('Change Phone Number'),
              ),
            ),
          ],
        ),
      );
    }

    return Form(
      key: _formKeyMember,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Log in or register via Mobile Number Verification',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.phone_android),
              labelText: 'Mobile Number',
              border: OutlineInputBorder(),
              helperText: 'Include country code (e.g. +91)',
            ),
            validator: (val) => val == null || val.length < 10 ? 'Enter valid number' : null,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              if (_formKeyMember.currentState!.validate()) {
                ref.read(authStateProvider.notifier).sendMemberOTP(_phoneController.text.trim());
              }
            },
            child: state is AuthLoading 
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white))
                : const Text('Send Verification OTP'),
          ),
          if (state is AuthError) ...[
            const SizedBox(height: 12),
            Text(
              state.message,
              style: const TextStyle(color: Colors.red, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLeaderTab(AuthState state) {
    return Form(
      key: _formKeyLeader,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.badge),
              labelText: 'Leadership User ID',
              border: OutlineInputBorder(),
            ),
            validator: (val) => val == null || val.isEmpty ? 'Enter User ID' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.password),
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
            validator: (val) => val == null || val.isEmpty ? 'Enter Password' : null,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              if (_formKeyLeader.currentState!.validate()) {
                ref.read(authStateProvider.notifier).loginAsLeader(
                  _usernameController.text.trim(),
                  _passwordController.text.trim(),
                );
              }
            },
            child: state is AuthLoading 
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white))
                : const Text('Secure Sign In'),
          ),
          if (state is AuthError) ...[
            const SizedBox(height: 12),
            Text(
              state.message,
              style: const TextStyle(color: Colors.red, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
