import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'carelink_logo.dart';

/// Premium animated splash screen with custom logo, pulsing glow,
/// staggered entrance animation, and first-launch routing logic.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // ── Main entrance animation ──
  late final AnimationController _entranceController;
  late final Animation<double> _logoFade;
  late final Animation<double> _logoScale;
  late final Animation<Offset> _logoSlide;
  late final Animation<double> _nameFade;
  late final Animation<Offset> _nameSlide;
  late final Animation<double> _subtitleFade;
  late final Animation<double> _loaderFade;

  // ── Pulsing glow animation ──
  late final AnimationController _glowController;
  late final Animation<double> _glowAnimation;

  // ── Gradient shimmer ──
  late final AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();

    // ── Entrance: 1200ms staggered ──
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _logoFade = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0, 0.5, curve: Curves.easeOut),
    ));
    _logoScale = Tween<double>(begin: 0.6, end: 1).animate(CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0, 0.5, curve: Curves.easeOutBack),
    ));
    _logoSlide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0, 0.5, curve: Curves.easeOutCubic),
    ));

    _nameFade = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.3, 0.65, curve: Curves.easeOut),
    ));
    _nameSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.3, 0.65, curve: Curves.easeOutCubic),
    ));

    _subtitleFade = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.5, 0.8, curve: Curves.easeOut),
    ));

    _loaderFade = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.7, 1, curve: Curves.easeOut),
    ));

    // ── Pulsing glow: repeating ──
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _glowAnimation = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
    _glowController.repeat(reverse: true);

    // ── Gradient shimmer ──
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    _shimmerController.repeat();

    // ── Start entrance ──
    _entranceController.forward();

    // ── Navigate after animation + minimum delay ──
    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(milliseconds: 4500));
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool('is_first_launch') ?? true;
    final isLanguageSet = prefs.getBool('is_language_set') ?? false;

    if (!mounted) return;

    if (isFirstLaunch && !isLanguageSet) {
      context.go('/language-selection');
    } else if (isFirstLaunch) {
      context.go('/onboarding');
    } else {
      context.go('/home');
    }
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _glowController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  Color _lerpGradientColor(Color a, Color b, double t) {
    return Color.lerp(a, b, (math.sin(t * math.pi * 2) + 1) / 2)!;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final logoSize = (screenWidth * 0.28).clamp(90.0, 140.0);

    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _entranceController,
          _glowController,
          _shimmerController,
        ]),
        builder: (context, _) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _lerpGradientColor(
                    const Color(0xFF0A7A6F),
                    const Color(0xFF0D9488),
                    _shimmerController.value,
                  ),
                  const Color(0xFF065F53),
                  _lerpGradientColor(
                    const Color(0xFF043D36),
                    const Color(0xFF065040),
                    _shimmerController.value,
                  ),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0, 0.5, 1],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  const Spacer(flex: 3),

                  // ── Glowing halo + Logo ──
                  SlideTransition(
                    position: _logoSlide,
                    child: FadeTransition(
                      opacity: _logoFade,
                      child: ScaleTransition(
                        scale: _logoScale,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Pulsing glow
                            Container(
                              width: logoSize * 1.8,
                              height: logoSize * 1.8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF5EEAD4).withValues(
                                        alpha: _glowAnimation.value * 0.3),
                                    blurRadius: 60,
                                    spreadRadius: 10,
                                  ),
                                ],
                              ),
                            ),
                            // Logo container
                            Container(
                              width: logoSize * 1.3,
                              height: logoSize * 1.3,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.08),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.12),
                                  width: 1.5,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: CareLinkLogo(size: logoSize),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: screenWidth * 0.08),

                  // ── App Name ──
                  SlideTransition(
                    position: _nameSlide,
                    child: FadeTransition(
                      opacity: _nameFade,
                      child: Text(
                        'CareLink',
                        style: GoogleFonts.inter(
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -1,
                          height: 1.1,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ── Subtitle ──
                  FadeTransition(
                    opacity: _subtitleFade,
                    child: Text(
                      'Medicine for Everyone',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withValues(alpha: 0.6),
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),

                  const Spacer(flex: 3),

                  // ── Bottom loader ──
                  FadeTransition(
                    opacity: _loaderFade,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 80),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _PulsingProgressBar(
                            animation: _shimmerController,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Powered by Community',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withValues(alpha: 0.4),
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHIMMER PROGRESS BAR
// ─────────────────────────────────────────────────────────────────────────────

/// A living progress bar that shimmers with a light sweep.
class _PulsingProgressBar extends StatelessWidget {
  final Animation<double> animation;

  const _PulsingProgressBar({required this.animation});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: SizedBox(
        height: 3,
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, _) {
            return CustomPaint(
              size: const Size(double.infinity, 3),
              painter: _ShimmerBarPainter(progress: animation.value),
            );
          },
        ),
      ),
    );
  }
}

class _ShimmerBarPainter extends CustomPainter {
  final double progress;

  _ShimmerBarPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    // Background
    final bgPaint = Paint()..color = Colors.white.withValues(alpha: 0.1);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Offset.zero & size,
        const Radius.circular(4),
      ),
      bgPaint,
    );

    // Shimmer highlight
    final shimmerWidth = size.width * 0.35;
    final left = (size.width + shimmerWidth) * progress - shimmerWidth;

    final shimmerPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.white.withValues(alpha: 0),
          Colors.white.withValues(alpha: 0.5),
          Colors.white.withValues(alpha: 0),
        ],
      ).createShader(Rect.fromLTWH(left, 0, shimmerWidth, size.height));

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(left, 0, shimmerWidth, size.height),
        const Radius.circular(4),
      ),
      shimmerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ShimmerBarPainter oldDelegate) =>
      oldDelegate.progress != progress;
}