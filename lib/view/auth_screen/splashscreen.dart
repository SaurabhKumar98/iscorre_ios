import 'package:firstedu/res/constants/colors/appcolors.dart';
import 'package:firstedu/view_models/authprovider/userSessionProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';

import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late AnimationController _bgController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _bgAnimation;

  @override
  void initState() {
    super.initState();

    // Scale Animation
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    // Fade Animation
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
    _bgAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bgController, curve: Curves.easeInOut),
    );

    _initApp();
  }

  Future<void> _initApp() async {
    _scaleController.forward();
    _fadeController.forward();

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final sessionProvider =
        Provider.of<UserSessionProvider>(context, listen: false);

    await sessionProvider.hydrate(context);

    if (!sessionProvider.hydrated) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      sessionProvider.initialRoute,
      (route) => false,
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    _pulseController.dispose();
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              drawerColor,
              drawerColor.withOpacity(0.9),
              const Color(0xFF1A237E),
              const Color(0xFF0D47A1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Decorative soft blobs, drifting subtly
              AnimatedBuilder(
                animation: _bgAnimation,
                builder: (context, child) {
                  return Positioned(
                    top: -80.h + (_bgAnimation.value * 20),
                    left: -60.w,
                    child: Container(
                      width: 220.w,
                      height: 220.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.05),
                      ),
                    ),
                  );
                },
              ),
              AnimatedBuilder(
                animation: _bgAnimation,
                builder: (context, child) {
                  return Positioned(
                    bottom: -100.h - (_bgAnimation.value * 25),
                    right: -70.w,
                    child: Container(
                      width: 260.w,
                      height: 260.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF0D47A1).withOpacity(0.25),
                      ),
                    ),
                  );
                },
              ),

              // Thin accent ring, top-right
              Positioned(
                top: 60.h,
                right: 30.w,
                child: Opacity(
                  opacity: 0.15,
                  child: Container(
                    width: 70.w,
                    height: 70.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.2),
                    ),
                  ),
                ),
              ),

              _buildBackgroundCircles(),

              // ---- Single merged center content: Icon on top, Image below ----
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated Icon (white circle with school icon)
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _pulseAnimation.value,
                            child: Container(
                              padding: EdgeInsets.all(40.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.3),
                                    blurRadius: 40.r,
                                    spreadRadius: 10.r,
                                  ),
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 30.r,
                                    offset: Offset(0, 15.h),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.school_rounded,
                                size: 80.sp,
                                color: drawerColor,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // Image below the icon, with its own pulsing glow
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: AnimatedBuilder(
                          animation: _pulseAnimation,
                          builder: (context, child) {
                            return Container(
                              width: 230.w * _pulseAnimation.value,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: child,
                            );
                          },
                          child: Image.asset(
                            'assets/images/splashscreen.png',
                            width: 230.w,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 40.h),

                    // Loading Indicator
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SizedBox(
                        width: 40.w,
                        height: 40.h,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white.withOpacity(0.8),
                          ),
                          strokeWidth: 3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundCircles() {
    return Stack(
      children: [
        // Top Right Circle
        Positioned(
          top: -100.h,
          right: -100.w,
          child: Container(
            width: 300.w,
            height: 300.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.05),
            ),
          ),
        ),
        // Bottom Left Circle
        Positioned(
          bottom: -150.h,
          left: -150.w,
          child: Container(
            width: 400.w,
            height: 400.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.05),
            ),
          ),
        ),
        // Middle Circle
        Positioned(
          top: 200.h,
          right: -50.w,
          child: Container(
            width: 200.w,
            height: 200.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.03),
            ),
          ),
        ),
      ],
    );
  }
}