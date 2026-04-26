import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:carelink_app/l10n/app_localizations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/settings/settings_cubit.dart';
import '../../blocs/settings/settings_state.dart';
import '../../../data/models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _pharmacyNameController;
  late TextEditingController _governorateController;
  late TextEditingController _cityController;
  late TextEditingController _villageController;
  late TextEditingController _streetController;

  String? _profilePicturePath;
  final ImagePicker _picker = ImagePicker();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final user = _getUser(context);
    _nameController = TextEditingController(text: user?.name);
    _emailController = TextEditingController(text: user?.email);
    _phoneController = TextEditingController(text: user?.phone);
    _pharmacyNameController = TextEditingController(text: user?.pharmacyName);
    _governorateController = TextEditingController(text: user?.governorate);
    _cityController = TextEditingController(text: user?.city);
    _villageController = TextEditingController(text: user?.village);
    _streetController = TextEditingController(text: user?.street);
    _profilePicturePath = user?.profilePicturePath;
  }

  UserModel? _getUser(BuildContext context) {
    final state = context.read<AuthBloc>().state;
    if (state is AuthAuthenticated) return state.user;
    return null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _pharmacyNameController.dispose();
    _governorateController.dispose();
    _cityController.dispose();
    _villageController.dispose();
    _streetController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (image != null) {
      setState(() => _profilePicturePath = image.path);
    }
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        AuthUpdateProfileRequested(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          pharmacyName: _pharmacyNameController.text.trim(),
          governorate: _governorateController.text.trim(),
          city: _cityController.text.trim(),
          village: _villageController.text.trim(),
          street: _streetController.text.trim(),
          profilePicturePath: _profilePicturePath,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Use context.watch to make profile reactive to auth state changes
    final authState = context.watch<AuthBloc>().state;
    final user = authState is AuthAuthenticated ? authState.user : null;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthProfileUpdateSuccess) {
          setState(() => _isEditing = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.profileUpdatedSuccessfully),
              backgroundColor: AppColors.success,
            ),
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _isEditing ? l10n.editProfile : l10n.settings,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: _isEditing
            ? _buildEditForm(l10n, user)
            : _buildDashboard(context, l10n, user),
      ),
    );
  }

  Widget _buildDashboard(
    BuildContext context,
    AppLocalizations l10n,
    UserModel? user,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          _buildProfileHeader(user, l10n),
          const SizedBox(height: 32),
          _buildMenuSection(context, l10n),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(UserModel? user, AppLocalizations l10n) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 2),
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest,
                backgroundImage: user?.profilePicturePath != null
                    ? FileImage(File(user!.profilePicturePath!))
                    : null,
                child: user?.profilePicturePath == null
                    ? Text(
                        user?.name.isNotEmpty == true
                            ? user!.name[0].toUpperCase()
                            : 'U',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      )
                    : null,
              ),
            ),
            if (user?.role == UserRole.pharmacist)
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.verified,
                  color: Colors.white,
                  size: 16,
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          user?.name ?? '',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(user?.email ?? '', style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 12),
        RoleBadge(role: user?.role ?? UserRole.patient),
        const SizedBox(height: 8),
        Text(
          '${l10n.nationalId}: ${user?.nationalId ?? '—'}',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        if (user?.isPharmacist == true &&
            user?.pharmacyName?.isNotEmpty == true) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.storefront_outlined,
                size: 16,
                color: AppColors.primary,
              ),
              const SizedBox(width: 6),
              Text(
                user!.pharmacyName!,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
        if (user != null &&
            (user.governorate?.isNotEmpty == true ||
                user.city?.isNotEmpty == true)) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  [
                    user.governorate,
                    user.city,
                    user.village,
                    user.street,
                  ].where((s) => s != null && s.isNotEmpty).join('، '),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildMenuSection(BuildContext context, AppLocalizations l10n) {
    return Column(
      children: [
        _menuTile(
          Icons.person_outline,
          l10n.accountSettings,
          l10n.editProfile,
          () => setState(() => _isEditing = true),
        ),
        _menuTile(Icons.help_outline, l10n.helpSupport, '', () {}),
      ],
    );
  }

  Widget _menuTile(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback? onTap, {
    bool isSwitch = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        subtitle: subtitle.isNotEmpty
            ? Text(subtitle, style: Theme.of(context).textTheme.bodySmall)
            : null,
        trailing: isSwitch
            ? BlocBuilder<SettingsCubit, SettingsState>(
                builder: (context, state) => Switch(
                  value: state.themeMode == ThemeMode.dark,
                  thumbColor: WidgetStateProperty.resolveWith(
                    (states) => states.contains(WidgetState.selected)
                        ? AppColors.primary
                        : null,
                  ),
                  onChanged: (_) => context.read<SettingsCubit>().toggleTheme(),
                ),
              )
            : Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: Theme.of(context).dividerColor,
                ),
              ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  Widget _buildEditForm(AppLocalizations l10n, UserModel? user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                  onPressed: () => setState(() => _isEditing = false),
                ),
                Text(
                  l10n.personalInfo,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Profile Picture Section
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 3),
                    ),
                    child: CircleAvatar(
                      radius: 56,
                      backgroundColor: Colors.white,
                      backgroundImage: _profilePicturePath != null
                          ? FileImage(File(_profilePicturePath!))
                          : null,
                      child: _profilePicturePath == null
                          ? Text(
                              user?.name.isNotEmpty == true
                                  ? user!.name[0].toUpperCase()
                                  : 'U',
                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            )
                          : null,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            TextButton(onPressed: _pickImage, child: Text(l10n.changePhoto)),
            const SizedBox(height: 32),

            // Form Fields
            AppTextField(
              controller: _nameController,
              label: l10n.fullName,
              prefixIcon: Icons.person_outline,
              validator: (v) => Validators.required(v, l10n.name),
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _emailController,
              label: l10n.email,
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (v) => Validators.email(
                v,
                requiredMsg: l10n.emailRequired,
                invalidMsg: l10n.emailInvalid,
              ),
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _phoneController,
              label: l10n.phone,
              prefixIcon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              maxLength: 11,
              validator: (v) => Validators.phone(
                v,
                requiredMsg: l10n.phoneRequired,
                invalidMsg: l10n.phoneInvalid,
              ),
            ),
            const SizedBox(height: 16),
            AppTextField(
              initialValue: user?.nationalId,
              label: l10n.nationalId,
              prefixIcon: Icons.badge_outlined,
              enabled: false, // MANDATORY: Immutable after registration
              helperText: l10n.nationalIdImmutableNote,
            ),

            if (user?.isPharmacist == true) ...[
              const SizedBox(height: 24),
              _buildSectionHeader(
                context,
                l10n.pharmacyName,
                Icons.local_pharmacy_outlined,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _pharmacyNameController,
                label: l10n.pharmacyName,
                prefixIcon: Icons.storefront_outlined,
                validator: (v) => Validators.required(v, l10n.pharmacyName),
              ),
            ],

            const SizedBox(height: 24),
            _buildSectionHeader(
              context,
              user?.isPharmacist == true ? l10n.addressInfo : l10n.address,
              Icons.location_on_outlined,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _governorateController,
              label: l10n.governorate,
              validator: (v) => Validators.required(v, l10n.governorate),
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _cityController,
              label: l10n.city,
              validator: (v) => Validators.required(v, l10n.city),
            ),
            const SizedBox(height: 16),
            AppTextField(controller: _villageController, label: l10n.village),
            const SizedBox(height: 16),
            AppTextField(
              controller: _streetController,
              label: l10n.street,
              validator: (v) => Validators.required(v, l10n.street),
            ),
            const SizedBox(height: 48),

            // Submit Button
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return AppButton(
                  text: l10n.updateProfile,
                  isLoading: state is AuthLoading,
                  onPressed: () {
                    _submit();
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => setState(() => _isEditing = false),
              child: Text(
                l10n.cancel,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 12),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(child: Divider()),
      ],
    );
  }
}
