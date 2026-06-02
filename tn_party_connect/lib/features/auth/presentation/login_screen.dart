import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme.dart';
import '../../../core/routes.dart';
import '../../../core/localization.dart';
import 'auth_state.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Controllers
  final _phoneController = TextEditingController(text: "+91");
  final _otpController = TextEditingController();
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
        // Clear history and open the Bottom Navigation Shell
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.navigationHolder,
          (route) => false,
        );
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
    
    // Dynamic translations
    final titleMember = context.tr('memberPortal', ref);
    final titleLeader = context.tr('leadershipPortal', ref);
    final btnDirectory = context.tr('browseDirectory', ref);
    final langToggle = context.tr('languageToggle', ref);

    return Scaffold(
      backgroundColor: isDark ? AppTheme.backgroundDark : AppTheme.lightGray,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // Language Switcher Toggle button
          TextButton.icon(
            onPressed: () {
              ref.read(languageProvider.notifier).toggleLanguage();
            },
            icon: const Icon(Icons.language, color: AppTheme.accent),
            label: Text(
              langToggle,
              style: const TextStyle(color: AppTheme.accent, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Banner Header
                Icon(
                  Icons.account_balance,
                  size: 64,
                  color: isDark ? AppTheme.accent : AppTheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  context.tr('appName', ref).toUpperCase(),
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: isDark ? Colors.white : AppTheme.primary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  context.tr('tagline', ref),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: isDark ? Colors.white70 : AppTheme.darkGray.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 36),

                // Card wrapping input elements
                Card(
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TabBar(
                          controller: _tabController,
                          indicatorColor: AppTheme.accent,
                          labelColor: AppTheme.primary,
                          unselectedLabelColor: Colors.grey,
                          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                          tabs: [
                            Tab(text: titleMember),
                            Tab(text: titleLeader),
                          ],
                        ),
                        const SizedBox(height: 24),
                        
                        SizedBox(
                          height: 250,
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

                // Quick Navigation to Public Directory
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.publicDirectory);
                  },
                  icon: Icon(Icons.search, color: isDark ? AppTheme.accent : AppTheme.primary),
                  label: Text(
                    btnDirectory,
                    style: TextStyle(
                      color: isDark ? AppTheme.accent : AppTheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: isDark ? AppTheme.accent : AppTheme.primary, width: 1.5),
                    minimumSize: const Size.fromHeight(54),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '${context.tr('enterOtp', ref)} (${state.phoneNumber})',
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.lock_outline),
                labelText: 'Verification Code',
                border: OutlineInputBorder(),
              ),
              validator: (val) => val == null || val.length != 6 ? 'Enter 6 digits' : null,
            ),
            const SizedBox(height: 20),
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
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Text(context.tr('verifyLogin', ref)),
            ),
            Center(
              child: TextButton(
                onPressed: () => ref.read(authStateProvider.notifier).reset(),
                child: const Text('Change Number', style: TextStyle(color: Colors.grey)),
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
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.phone_android),
              labelText: 'Mobile Number',
              helperText: context.tr('phoneHelper', ref),
              border: const OutlineInputBorder(),
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
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : Text(context.tr('sendOtp', ref)),
          ),
          if (state is AuthError) ...[
            const SizedBox(height: 12),
            Text(
              state.message,
              style: const TextStyle(color: AppTheme.emergency, fontSize: 12),
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
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.shield_outlined),
              labelText: context.tr('userId', ref),
              border: const OutlineInputBorder(),
            ),
            validator: (val) => val == null || val.isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock_open_outlined),
              labelText: context.tr('password', ref),
              border: const OutlineInputBorder(),
            ),
            validator: (val) => val == null || val.isEmpty ? 'Required' : null,
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
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : Text(context.tr('secureSignIn', ref)),
          ),
          if (state is AuthError) ...[
            const SizedBox(height: 12),
            Text(
              state.message,
              style: const TextStyle(color: AppTheme.emergency, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
