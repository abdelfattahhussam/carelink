import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:carelink_app/l10n/app_localizations.dart';
import '../constants/app_colors.dart';
import '../../data/models/user_model.dart';
import '../../presentation/blocs/auth/auth_bloc.dart';
import '../../presentation/blocs/settings/settings_cubit.dart';
import '../../presentation/blocs/settings/settings_state.dart';
import '../../presentation/blocs/notification/notification_bloc.dart';

/// Primary action button with gradient background
class AppButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;
  final double? width;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.width,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _isPressed = false;

  void _setPressed(bool pressed) {
    if (widget.onPressed == null || widget.isLoading) return;
    if (_isPressed != pressed) {
      setState(() => _isPressed = pressed);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isOutlined) {
      return SizedBox(
        width: widget.width ?? double.infinity,
        height: 54,
        child: Listener(
          onPointerDown: (_) => _setPressed(true),
          onPointerUp: (_) => _setPressed(false),
          onPointerCancel: (_) => _setPressed(false),
          child: AnimatedScale(
            scale: _isPressed ? 0.97 : 1.0,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeInOut,
            child: OutlinedButton(
              onPressed: widget.isLoading ? null : widget.onPressed,
              child: _buildChild(context, outlined: true),
            ),
          ),
        ),
      );
    }

    final isDisabled = widget.onPressed == null || widget.isLoading;

    return SizedBox(
      width: widget.width ?? double.infinity,
      height: 54,
      child: Listener(
        onPointerDown: (_) => _setPressed(true),
        onPointerUp: (_) => _setPressed(false),
        onPointerCancel: (_) => _setPressed(false),
        child: AnimatedScale(
          scale: _isPressed ? 0.97 : 1.0,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeInOut,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: !isDisabled ? AppColors.primaryGradient : null,
              color: isDisabled ? AppColors.textLight.withValues(alpha: 0.3) : null,
              borderRadius: BorderRadius.circular(14),
              boxShadow: !isDisabled
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: _isPressed ? 0.15 : 0.3),
                        blurRadius: _isPressed ? 6 : 12,
                        offset: Offset(0, _isPressed ? 2 : 4),
                      ),
                    ]
                  : null,
            ),
            child: ElevatedButton(
              onPressed: widget.isLoading ? null : widget.onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                disabledBackgroundColor: Colors.transparent,
              ),
              child: _buildChild(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChild(BuildContext context, {bool outlined = false}) {
    if (widget.isLoading) {
      return SizedBox(
        height: 22,
        width: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: outlined ? AppColors.primary : AppColors.textOnPrimary,
        ),
      );
    }

    if (widget.icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(widget.icon, size: 20),
          const SizedBox(width: 8),
          Text(widget.text),
        ],
      );
    }

    return Text(widget.text);
  }
}

/// Styled text field with optional prefix icon
class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final IconData? prefixIcon;
  final Widget? suffix;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int maxLines;
  final bool readOnly;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final String? initialValue;
  final bool? enabled; // Added to support read-only/disabled states
  final String? helperText; // Added for hints/notes
  final int? maxLength; // Added to support limiting input length

  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffix,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.initialValue,
    this.enabled,
    this.helperText,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      readOnly: readOnly,
      enabled: enabled,
      onTap: onTap,
      onChanged: onChanged,
      maxLength: maxLength,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        helperText: helperText,
        counterText: "", // Hide the counter for a cleaner look
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, size: 22)
            : null,
        suffixIcon: suffix,
      ),
    );
  }
}

/// Status badge chip with color coding
class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    Color bgColor;
    Color textColor;
    IconData icon;
    String label;

    switch (status.toLowerCase()) {
      case 'approved':
        bgColor = AppColors.approved.withValues(alpha: 0.1);
        textColor = AppColors.approved;
        icon = Icons.check_circle_outline;
        label = l10n.approved;
        break;
      case 'rejected':
        bgColor = AppColors.rejected.withValues(alpha: 0.1);
        textColor = AppColors.rejected;
        icon = Icons.cancel_outlined;
        label = l10n.rejected;
        break;
      case 'expired':
        bgColor = AppColors.expired.withValues(alpha: 0.1);
        textColor = AppColors.expired;
        icon = Icons.timer_off_outlined;
        label = l10n.expired;
        break;
      case 'delivered':
        bgColor = AppColors.info.withValues(alpha: 0.1);
        textColor = AppColors.info;
        icon = Icons.local_shipping_outlined;
        label = l10n.delivered;
        break;
      case 'pending':
      default:
        bgColor = AppColors.pending.withValues(alpha: 0.1);
        textColor = AppColors.pending;
        icon = Icons.schedule;
        label = l10n.pending;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// Empty state placeholder widget
class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? action;
  final Color? color;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.action,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = color ?? AppColors.primary;
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: activeColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: activeColor.withValues(alpha: 0.05),
                    blurRadius: 24,
                    spreadRadius: 8,
                  ),
                ],
              ),
              child: Icon(icon, size: 64, color: activeColor.withValues(alpha: 0.8)),
            ),
            const SizedBox(height: 32),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).textTheme.titleLarge?.color?.withValues(alpha: 0.9),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                height: 1.5,
                color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            if (action != null) ...[
              const SizedBox(height: 32),
              action!,
            ],
          ],
        ),
      ),
      ),
    );
  }
}

/// Loading overlay widget
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black12,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}

/// A subtle badge to indicate user role
class RoleBadge extends StatelessWidget {
  final UserRole role;
  const RoleBadge({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final color = switch (role) {
      UserRole.pharmacist => AppColors.primary,
      UserRole.donor => AppColors.success,
      UserRole.patient => AppColors.secondary,
    };

    final label = switch (role) {
      UserRole.pharmacist => AppLocalizations.of(context)!.pharmacist,
      UserRole.donor => AppLocalizations.of(context)!.donor,
      UserRole.patient => AppLocalizations.of(context)!.patient,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

/// A unified AppBar for all home screens (Pharmacist, Donor, Patient)
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final UserModel user;

  const HomeAppBar({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: PopupMenuButton<String>(
          offset: const Offset(0, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          icon: CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.primary,
            backgroundImage: user.profilePicturePath != null ? FileImage(File(user.profilePicturePath!)) : null,
            child: user.profilePicturePath == null
                ? Text(
                    user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                  )
                : null,
          ),
          onSelected: (v) {
            if (v == 'profile') {
              context.push('/profile');
            } else if (v == 'logout') {
              context.read<AuthBloc>().add(AuthLogoutRequested());
              context.go('/login');
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              enabled: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(user.name, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                   Text(user.role.label.toUpperCase(), style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem(
              value: 'profile',
              child: Row(
                children: [
                  const Icon(Icons.settings_outlined, size: 18, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Text(AppLocalizations.of(context)!.settings),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'logout',
              child: Row(
                children: [
                  const Icon(Icons.logout, size: 18, color: AppColors.error),
                  const SizedBox(width: 12),
                  Text(
                    AppLocalizations.of(context)!.logout,
                    style: const TextStyle(color: AppColors.error),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      title: Text(
        AppLocalizations.of(context)!.appTitle,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      actions: [
        // Theme Toggle
        BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) => IconButton(
            icon: Icon(
              state.themeMode == ThemeMode.dark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              size: 20,
            ),
            onPressed: () => context.read<SettingsCubit>().toggleTheme(),
          ),
        ),
        // Language Toggle
        IconButton(
          icon: const Icon(Icons.translate_rounded, size: 20),
          onPressed: () => _showLanguagePicker(context),
        ),
        // Notifications
        BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            int unread = 0;
            if (state is NotificationsLoaded) unread = state.unreadCount;
            return Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () => context.push('/notifications'),
                ),
                if (unread > 0)
                  PositionedDirectional(
                    end: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                      child: Text(
                        '$unread',
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  void _showLanguagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => SafeArea(
        child: Wrap(children: [
          ListTile(
            title: const Text('العربية'), 
            leading: const Text('🇪🇬'), 
            onTap: () { 
              context.read<SettingsCubit>().setLocale(const Locale('ar')); 
              Navigator.pop(context); 
            }
          ),
          ListTile(
            title: const Text('English'), 
            leading: const Text('🇺🇸'), 
            onTap: () { 
              context.read<SettingsCubit>().setLocale(const Locale('en')); 
              Navigator.pop(context); 
            }
          ),
        ]),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
