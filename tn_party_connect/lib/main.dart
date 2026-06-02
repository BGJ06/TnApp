import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/theme.dart';
import 'core/routes.dart';

bool isFirebaseMocked = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
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
      themeMode: ThemeMode.system,
      initialRoute: AppRoutes.splash, // Start on Splash Screen
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
