import 'package:flutter/material.dart';
import 'dart:async';
import '../../../core/routes.dart';
import '../../../core/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _fadeController.forward();

    // Route to Login Screen after 3.5 seconds
    Timer(const Duration(seconds: 3500), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.backgroundDark : AppTheme.primary,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          decoration: BoxDecoration(
            gradient: isDark ? AppTheme.darkGradient : AppTheme.primaryGradient,
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Custom Painted Party Crest Logo
                  CustomPaint(
                    size: const Size(120, 120),
                    painter: PartyLogoPainter(),
                  ),
                  const SizedBox(height: 32),
                  
                  // Title Header
                  Text(
                    'TN PARTY CONNECT',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: AppTheme.accent,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Tamil translation
                  const Text(
                    'தமிழ்நாடு கட்சி இணைப்பு',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: Colors.white70,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Outline Map Shape Indicator
                  CustomPaint(
                    size: const Size(100, 100),
                    painter: TamilNaduMapPainter(),
                  ),
                  const SizedBox(height: 40),

                  // Tagline Text
                  const Text(
                    '"Connecting Leadership & Members Across Tamil Nadu"',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
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
}

// Vector CustomPainter for a Premium Shield Logo (Red + Gold outline)
class PartyLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final fillPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final path = Path();
    
    // Draw an elegant Shield Crest
    path.moveTo(size.width * 0.5, 0); // Top-center
    path.lineTo(size.width, size.height * 0.2); // Top-right
    path.quadraticBezierTo(
      size.width, size.height * 0.7, 
      size.width * 0.5, size.height
    ); // Bottom curves right
    path.quadraticBezierTo(
      0, size.height * 0.7, 
      0, size.height * 0.2
    ); // Bottom curves left
    path.close();

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, paint);

    // Inner details (Star / Torch)
    final starPaint = Paint()
      ..color = AppTheme.accent
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.45), 14, starPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Vector CustomPainter rendering a simplified geographic representation of Tamil Nadu
class TamilNaduMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final path = Path();
    // Simplified geographical outline coordinates of Tamil Nadu
    path.moveTo(size.width * 0.2, size.height * 0.1);
    path.lineTo(size.width * 0.8, size.height * 0.1);
    path.lineTo(size.width * 0.9, size.height * 0.5);
    path.lineTo(size.width * 0.6, size.height * 0.95);
    path.lineTo(size.width * 0.4, size.height * 0.95);
    path.lineTo(size.width * 0.1, size.height * 0.5);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
