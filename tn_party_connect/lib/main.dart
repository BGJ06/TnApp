import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/theme.dart';
import 'core/routes.dart';
import 'features/auth/presentation/login_screen.dart';

// Global flag to toggle mock/offline mode dynamically
bool isFirebaseMocked = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Attempt real Firebase initialization
    // If the user has configured firebase, this will initialize.
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint("Firebase init failed or options missing. Running in mock/offline demo mode: $e");
    isFirebaseMocked = true;
  }

  runApp(
    const ProviderScope(
      child: TNPartyConnectApp(),
    ),
  );
}

class TNPartyConnectApp extends StatelessWidget {
  const TNPartyConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TN Party Connect',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Supporting system-wide Dark Mode
      initialRoute: AppRoutes.login,
      onGenerateRoute: AppRoutes.generateRoute,
      home: const LoginScreen(),
    );
  }
}
