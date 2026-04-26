import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carelink_app/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_colors.dart';

/// Premium onboarding flow with 3 animated pages, custom dot indicator,
/// and smooth per-page transition animations.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late final AnimationController _contentController;
  late final Animation<double> _contentFade;
  late final Animation<Offset> _contentSlide;

  @override
  void initState() {
    super.initState();
    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _contentFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeOut),
    );
    _contentSlide =
        Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _contentController,
            curve: Curves.easeOutCubic,
          ),
        );
    _contentController.forward();
  }

  Future<void> _completeOnboarding(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_first_launch', false);
    if (context.mounted) {
      context.go('/login');
    }
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _completeOnboarding(context);
    }
  }

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
    _contentController.reset();
    _contentController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.sizeOf(context).width;

    final pages = [
      _OnboardingPageData(
        icon: Icons.volunteer_activism_rounded,
        gradientColors: const [AppColors.primaryDark, AppColors.primary],
        title: l10n.onboardingTitle1,
        description: l10n.onboardingDesc1,
      ),
      _OnboardingPageData(
        icon: Icons.local_pharmacy_rounded,
        gradientColors: const [AppColors.primary, AppColors.primary],
        title: l10n.onboardingTitle2,
        description: l10n.onboardingDesc2,
      ),
      _OnboardingPageData(
        icon: Icons.health_and_safety_rounded,
        gradientColors: const [AppColors.primary, AppColors.primaryLight],
        title: l10n.onboardingTitle3,
        description: l10n.onboardingDesc3,
      ),
    ];

    final activeColor = pages[_currentPage].gradientColors.first;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top row: Skip ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Align(
                alignment: AlignmentDirectional.topEnd,
                child: TextButton(
                  onPressed: () => _completeOnboarding(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    l10n.skip,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.primaryLight
                          : AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),

            // ── PageView ──
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: pages.length,
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) {
                  final page = pages[index];
                  return AnimatedBuilder(
                    animation: _contentController,
                    builder: (context, _) {
                      return SlideTransition(
                        position: _contentSlide,
                        child: FadeTransition(
                          opacity: _contentFade,
                          child: _OnboardingPageWidget(
                            data: page,
                            isDark: isDark,
                            screenWidth: screenWidth,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // ── Bottom: Dots + Button ──
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Column(
                children: [
                  // Dot indicator
                  _AnimatedPageIndicator(
                    currentPage: _currentPage,
                    pageCount: pages.length,
                    isDark: isDark,
                    activeColor: activeColor,
                  ),
                  const SizedBox(height: 32),

                  // CTA button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: activeColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        textStyle: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: Row(
                          key: ValueKey(_currentPage == 2),
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _currentPage == 2 ? l10n.getStarted : l10n.next,
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              _currentPage == 2
                                  ? Icons.rocket_launch_rounded
                                  : Icons.arrow_forward_rounded,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DATA MODEL
// ─────────────────────────────────────────────────────────────────────────────

class _OnboardingPageData {
  final IconData icon;
  final List<Color> gradientColors;
  final String title;
  final String description;

  const _OnboardingPageData({
    required this.icon,
    required this.gradientColors,
    required this.title,
    required this.description,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// PAGE WIDGET
// ─────────────────────────────────────────────────────────────────────────────

class _OnboardingPageWidget extends StatelessWidget {
  final _OnboardingPageData data;
  final bool isDark;
  final double screenWidth;

  const _OnboardingPageWidget({
    required this.data,
    required this.isDark,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = (screenWidth * 0.18).clamp(60.0, 100.0);
    final containerSize = (screenWidth * 0.42).clamp(140.0, 200.0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ── Double-ring illustration ──
          Container(
            width: containerSize,
            height: containerSize,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  data.gradientColors[0].withValues(alpha: isDark ? 0.18 : 0.1),
                  data.gradientColors[1].withValues(
                    alpha: isDark ? 0.06 : 0.03,
                  ),
                ],
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: data.gradientColors[0].withValues(
                  alpha: isDark ? 0.25 : 0.12,
                ),
                width: 2,
              ),
            ),
            alignment: Alignment.center,
            child: Container(
              width: containerSize * 0.62,
              height: containerSize * 0.62,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: data.gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: data.gradientColors[0].withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Icon(data.icon, size: iconSize, color: Colors.white),
            ),
          ),

          SizedBox(height: screenWidth * 0.08),

          // ── Title ──
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
              letterSpacing: -0.5,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),

          // ── Description ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              data.description,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondary,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ANIMATED DOT INDICATOR
// ─────────────────────────────────────────────────────────────────────────────

class _AnimatedPageIndicator extends StatelessWidget {
  final int currentPage;
  final int pageCount;
  final bool isDark;
  final Color activeColor;

  const _AnimatedPageIndicator({
    required this.currentPage,
    required this.pageCount,
    required this.isDark,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pageCount, (index) {
        final isActive = index == currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOutCubic,
          margin: const EdgeInsetsDirectional.only(end: 10),
          height: 10,
          width: isActive ? 32 : 10,
          decoration: BoxDecoration(
            color: isActive
                ? activeColor
                : (isDark ? AppColors.surfaceVariantDark : AppColors.divider),
            borderRadius: BorderRadius.circular(5),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: activeColor.withValues(alpha: 0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
        );
      }),
    );
  }
}
