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
import 'notification_badge.dart';

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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          icon: CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.primary,
            backgroundImage: user.profilePicturePath != null
                ? FileImage(File(user.profilePicturePath!))
                : null,
            child: user.profilePicturePath == null
                ? Text(
                    user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
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
                  Text(
                    user.name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    user.role.label.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem(
              value: 'profile',
              child: Row(
                children: [
                  const Icon(
                    Icons.settings_outlined,
                    size: 18,
                    color: AppColors.primary,
                  ),
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
              state.themeMode == ThemeMode.dark
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
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
        // Notifications — optimized badge (only rebuilds on count change)
        const NotificationBadge(),
        const SizedBox(width: 8),
      ],
    );
  }

  void _showLanguagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              title: const Text('العربية'),
              leading: const Text('🇪🇬'),
              onTap: () {
                context.read<SettingsCubit>().setLocale(const Locale('ar'));
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('English'),
              leading: const Text('🇺🇸'),
              onTap: () {
                context.read<SettingsCubit>().setLocale(const Locale('en'));
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
