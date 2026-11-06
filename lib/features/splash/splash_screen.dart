
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smart_to_do_app/core/constants/app_constants.dart';
import 'package:smart_to_do_app/core/constants/app_colors.dart';
import 'package:smart_to_do_app/features/navigation/screens/main_navigation_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _loadingController;

  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<double> _logoRotation;

  late Animation<double> _textFade;
  late Animation<Offset> _textSlide;

  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _logoScale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.easeOutBack,
      ),
    );

    _logoFade = CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeIn,
    );

    _logoRotation = Tween<double>(
      begin: -0.15,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.easeOut,
      ),
    );

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _textFade = CurvedAnimation(
      parent: _textController,
      curve: Curves.easeIn,
    );

    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeOutCubic,
      ),
    );

    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();

    _startAnimations();

    _navigationTimer = Timer(
      const Duration(seconds: 3),
      _navigateToHome,
    );
  }

  Future<void> _startAnimations() async {
    await _logoController.forward();

    if (!mounted) return;

    _textController.forward();
  }

  void _navigateToHome() {
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const MainNavigationScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();

    _logoController.dispose();
    _textController.dispose();
    _loadingController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = theme.scaffoldBackgroundColor;

    final logoColor = isDark
        ? AppColors.darkGreen
        : AppColors.primary;

    final shadowColor = AppColors.primary.withValues(
      alpha: isDark ? 0.12 : 0.20,
    );

    final accentColor = isDark
        ? AppColors.success
        : AppColors.primary;

    final titleColor = isDark
        ? AppColors.white
        : AppColors.textPrimary;

    final subtitleColor = isDark
        ? colorScheme.onSurfaceVariant
        : AppColors.textSecondary;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 3),

              // Animated App Logo
              AnimatedBuilder(
                animation: _logoController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _logoFade.value,
                    child: Transform.rotate(
                      angle: _logoRotation.value,
                      child: Transform.scale(
                        scale: _logoScale.value,
                        child: child,
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: shadowColor,
                        blurRadius: 30,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      AppConstants.logo,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: logoColor,
                          child: const Icon(
                            Icons.task_alt_rounded,
                            color: Colors.white,
                            size: 65,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Animated App Name
              FadeTransition(
                opacity: _textFade,
                child: SlideTransition(
                  position: _textSlide,
                  child: Text(
                    'Smart To Do',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: titleColor,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // App Subtitle
              FadeTransition(
                opacity: _textFade,
                child: Text(
                  'Organize your tasks, achieve your goals.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: subtitleColor,
                    letterSpacing: 0.3,
                  ),
                ),
              ),

              const Spacer(flex: 2),

              // Loading Indicator
              AnimatedBuilder(
                animation: _loadingController,
                builder: (context, child) {
                  return SizedBox(
                    height: 35,
                    width: 35,
                    child: CircularProgressIndicator(
                      value: null,
                      strokeWidth: 3,
                      color: accentColor,
                      strokeCap: StrokeCap.round,
                    ),
                  );
                },
              ),

              const SizedBox(height: 15),

              Text(
                'Getting things ready...',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: subtitleColor,
                  letterSpacing: 0.5,
                ),
              ),

              const Spacer(),

              // Footer
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  'Made with ♥',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: subtitleColor,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
