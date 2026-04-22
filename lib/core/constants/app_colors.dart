import 'package:flutter/material.dart';

/// CareLink color palette — medical teal/emerald theme
class AppColors {
  AppColors._();

  // Primary palette
  static const Color primary = Color(0xFF0D9488);
  static const Color primaryLight = Color(0xFF5EEAD4);
  static const Color primaryDark = Color(0xFF065F53);
  static const Color primaryContainer = Color(0xFFE0F7F4);

  // Secondary palette
  static const Color secondary = Color(0xFF0EA5E9);
  static const Color secondaryLight = Color(0xFF7DD3FC);
  static const Color secondaryContainer = Color(0xFFE0F2FE);

  // Accent
  static const Color accent = Color(0xFFF97316);
  static const Color accentLight = Color(0xFFFED7AA);
  static const Color accentContainer = Color(0xFFFFF7ED);

  // Semantic colors
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Semantic container colors (background tints for badges, chips, banners)
  static const Color successContainer = Color(0xFFDCFCE7);
  static const Color warningContainer = Color(0xFFFEF3C7);
  static const Color errorContainer = Color(0xFFFEE2E2);
  static const Color infoContainer = Color(0xFFDBEAFE);

  // Neutral palette
  static const Color surface = Color(0xFFF8FAFC);
  static const Color surfaceVariant = Color(0xFFF1F5F9);
  static const Color background = Color(0xFFFFFFFF);
  static const Color card = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFE2E8F0);

  // Dark neutral palette
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color surfaceVariantDark = Color(0xFF334155);
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color cardDark = Color(0xFF1E293B);
  static const Color dividerDark = Color(0xFF475569);

  // Text colors
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF596878);
  static const Color textLight = Color(0xFF8494A7);
  static const Color textDisabled = Color(0xFFCBD5E1);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Dark text colors
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color textLightDark = Color(0xFF64748B);
  static const Color textDisabledDark = Color(0xFF475569);

  // Status-specific colors
  static const Color pending = Color(0xFFF59E0B);
  static const Color approved = Color(0xFF22C55E);
  static const Color rejected = Color(0xFFEF4444);
  static const Color expired = Color(0xFF6B7280);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF0D9488), Color(0xFF065F53)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF0D9488), Color(0xFF0EA5E9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient infoGradient = LinearGradient(
    colors: [Color(0xFF3B82F6), Color(0xFF0EA5E9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
