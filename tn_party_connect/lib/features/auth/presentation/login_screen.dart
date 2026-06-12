import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../main.dart';
import '../../../core/theme.dart';
import '../../../core/routes.dart';
import '../../../core/localization.dart';
import '../../dashboard/presentation/navigation_holder.dart';
import 'auth_state.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isRegistering = false; // True if registering a new member, false for OTP login

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
        // Switch to the Welcome tab (Index 4) after login
        ref.read(tabIndexProvider.notifier).state = 4;
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
                          height: 480, // Increased to fit the credentials list
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
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock_outline),
                labelText: context.tr('verificationCode', ref),
                border: const OutlineInputBorder(),
              ),
              validator: (val) => val == null || val.length != 6 ? context.tr('enter6digits', ref) : null,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKeyMember.currentState!.validate()) {
                  ref.read(authStateProvider.notifier).verifyMemberOTP(
                    state.verificationId,
                    _otpController.text.trim(),
                    isRegistering: state.isRegistering,
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
                child: Text(context.tr('changeNumber', ref), style: const TextStyle(color: Colors.grey)),
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
          // Register vs Login Selector ChoiceChips
          Row(
            children: [
              Expanded(
                child: ChoiceChip(
                  label: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      context.tr('registerNewPerson', ref),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ),
                  selected: _isRegistering,
                  onSelected: (val) {
                    setState(() {
                      _isRegistering = true;
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ChoiceChip(
                  label: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      context.tr('loginViaOtp', ref),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ),
                  selected: !_isRegistering,
                  onSelected: (val) {
                    setState(() {
                      _isRegistering = false;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.phone_android),
              labelText: context.tr('mobileNumber', ref),
              helperText: context.tr('phoneHelper', ref),
              border: const OutlineInputBorder(),
            ),
            validator: (val) => val == null || val.length < 10 ? context.tr('enterValidNumber', ref) : null,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKeyMember.currentState!.validate()) {
                ref.read(authStateProvider.notifier).sendMemberOTP(
                  _phoneController.text.trim(),
                  isRegistering: _isRegistering,
                );
              }
            },
            child: state is AuthLoading 
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : Text(
                    _isRegistering 
                        ? context.tr('registerAndSendOtp', ref)
                        : context.tr('sendOtp', ref)
                  ),
          ),
          if (state is AuthError) ...[
            const SizedBox(height: 12),
            Text(
              context.trError(state.message, ref),
              style: const TextStyle(color: AppTheme.emergency, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLeaderTab(AuthState state) {
    final isTamil = ref.watch(languageProvider) == AppLanguage.tamil;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Form(
      key: _formKeyLeader,
      child: SingleChildScrollView(
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
              validator: (val) => val == null || val.isEmpty ? context.tr('required', ref) : null,
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
              validator: (val) => val == null || val.isEmpty ? context.tr('required', ref) : null,
            ),
            const SizedBox(height: 20),
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
                context.trError(state.message, ref),
                style: const TextStyle(color: AppTheme.emergency, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
            // Demo credentials helper card for offline mode testing
            if (isFirebaseMocked) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.surfaceDark : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? AppTheme.accent.withAlpha(80) : AppTheme.primary.withAlpha(50),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(isDark ? 40 : 10),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.vpn_key_outlined,
                          size: 16,
                          color: isDark ? AppTheme.accent : AppTheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isTamil ? 'அதிகாரப்பூர்வ சோதனை நற்சான்றிதழ்கள்' : 'Demo Leadership Logins',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.5,
                            color: isDark ? AppTheme.accent : AppTheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 16, thickness: 0.5),
                    _buildCredentialRow(
                      role: isTamil ? 'மாநிலத் தலைவர்' : 'State President',
                      uid: 'state_president',
                      pass: 'president123',
                      isDark: isDark,
                    ),
                    const SizedBox(height: 6),
                    _buildCredentialRow(
                      role: isTamil ? 'IT பிரிவுத் தலைவர்' : 'State IT Head',
                      uid: 'state_it_head',
                      pass: 'ithead123',
                      isDark: isDark,
                    ),
                    const SizedBox(height: 6),
                    _buildCredentialRow(
                      role: isTamil ? 'மாவட்டத் தலைவர்' : 'District Head',
                      uid: 'district_head',
                      pass: 'district123',
                      isDark: isDark,
                    ),
                    const SizedBox(height: 6),
                    _buildCredentialRow(
                      role: isTamil ? 'தாலுகா தலைவர்' : 'Taluk Head',
                      uid: 'taluk_head',
                      pass: 'taluk123',
                      isDark: isDark,
                    ),
                    const SizedBox(height: 6),
                    _buildCredentialRow(
                      role: isTamil ? 'வார்டு தலைவர்' : 'Ward Head',
                      uid: 'ward_head',
                      pass: 'ward123',
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCredentialRow({
    required String role,
    required String uid,
    required String pass,
    required bool isDark,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 4,
          child: Text(
            '$role:',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11.5),
          ),
        ),
        Expanded(
          flex: 6,
          child: InkWell(
            onTap: () {
              setState(() {
                _usernameController.text = uid;
                _passwordController.text = pass;
              });
            },
            borderRadius: BorderRadius.circular(4),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isDark ? Colors.white10 : Colors.black.withAlpha(12),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'ID: $uid  |  Key: $pass',
                style: TextStyle(
                  fontFamily: 'Courier',
                  fontSize: 10.5,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
