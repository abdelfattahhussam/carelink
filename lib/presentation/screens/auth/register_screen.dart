import 'package:flutter/material.dart';
import 'package:carelink_app/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../../data/models/user_model.dart';
import 'package:image_picker/image_picker.dart';

/// Premium Registration screen with animated role selection cards
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nationalIdController = TextEditingController();

  // Pharmacist specific controllers
  final _pharmacyNameController = TextEditingController();
  final _governorateController = TextEditingController();
  final _cityController = TextEditingController();
  final _villageController = TextEditingController();
  final _streetController = TextEditingController();

  String? _licensePath;
  bool _obscurePassword = true;
  UserRole _selectedRole = UserRole.user;

  final ImagePicker _picker = ImagePicker();

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
          CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic),
        );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _pharmacyNameController.dispose();
    _governorateController.dispose();
    _cityController.dispose();
    _villageController.dispose();
    _streetController.dispose();
    _nationalIdController.dispose();
    super.dispose();
  }

  Future<void> _pickLicenseImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (image != null) {
      setState(() => _licensePath = image.path);
    }
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedRole == UserRole.pharmacist && _licensePath == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.licenseRequired),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      context.read<AuthBloc>().add(
        AuthRegisterRequested(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          nationalId: _nationalIdController.text.trim(),
          password: _passwordController.text,
          role: _selectedRole,
          pharmacyName: _selectedRole == UserRole.pharmacist
              ? _pharmacyNameController.text.trim()
              : null,
          governorate: _governorateController.text.trim(),
          city: _cityController.text.trim(),
          village: _villageController.text.trim(),
          street: _streetController.text.trim(),
          licensePath: _selectedRole == UserRole.pharmacist
              ? _licensePath
              : null,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final roles = [
      {
        'value': UserRole.user,
        'label': AppLocalizations.of(context)!.roleUser,
        'icon': Icons.person,
      },
      {
        'value': UserRole.pharmacist,
        'label': AppLocalizations.of(context)!.pharmacist,
        'icon': Icons.medical_services,
      },
    ];

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        } else if (state is AuthAuthenticated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.registrationSuccess),
              backgroundColor: AppColors.success,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            // Premium Gradient Background
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: MediaQuery.of(context).size.height * 0.35,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
              ),
            ),

            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),

            SafeArea(
              bottom: false,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          AppLocalizations.of(context)!.createAccount,
                          style: Theme.of(context).textTheme.headlineLarge
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Join ${AppLocalizations.of(context)!.appTitle} and make a difference',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                        ),
                        const SizedBox(height: 32),

                        // Form Container
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(
                                  alpha: 0.08,
                                ),
                                blurRadius: 24,
                                offset: const Offset(0, 12),
                              ),
                            ],
                            border: Border.all(
                              color: AppColors.divider.withValues(alpha: 0.6),
                            ),
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Role selection
                                Text(
                                  AppLocalizations.of(context)!.selectRole,
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textSecondary,
                                      ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: roles.map((role) {
                                    final isSelected =
                                        _selectedRole == role['value'];
                                    return Expanded(
                                      child: GestureDetector(
                                        onTap: () => setState(
                                          () => _selectedRole =
                                              role['value'] as UserRole,
                                        ),
                                        child: AnimatedContainer(
                                          duration: const Duration(
                                            milliseconds: 250,
                                          ),
                                          curve: Curves.easeOutCubic,
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 4,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 16,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? AppColors.primary.withValues(
                                                    alpha: 0.08,
                                                  )
                                                : AppColors.surfaceVariant,
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            border: Border.all(
                                              color: isSelected
                                                  ? AppColors.primary
                                                  : AppColors.divider
                                                        .withValues(alpha: 0.5),
                                              width: isSelected ? 2 : 1,
                                            ),
                                            boxShadow: isSelected
                                                ? [
                                                    BoxShadow(
                                                      color: AppColors.primary
                                                          .withValues(
                                                            alpha: 0.1,
                                                          ),
                                                      blurRadius: 10,
                                                      offset: const Offset(
                                                        0,
                                                        4,
                                                      ),
                                                    ),
                                                  ]
                                                : null,
                                          ),
                                          child: Column(
                                            children: [
                                              Icon(
                                                role['icon'] as IconData,
                                                color: isSelected
                                                    ? AppColors.primary
                                                    : AppColors.textLight,
                                                size: 26,
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                role['label'] as String,
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: isSelected
                                                      ? FontWeight.w700
                                                      : FontWeight.w500,
                                                  color: isSelected
                                                      ? AppColors.primary
                                                      : AppColors.textSecondary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                                const SizedBox(height: 32),

                                // General Info Section
                                _sectionTitle(
                                  Icons.person_outline,
                                  AppLocalizations.of(context)!.fullName,
                                ),
                                const SizedBox(height: 12),
                                AppTextField(
                                  controller: _nameController,
                                  label: AppLocalizations.of(context)!.fullName,
                                  hint: AppLocalizations.of(context)!.fullName,
                                  prefixIcon: Icons.person_outline,
                                  validator: (v) => Validators.required(
                                    v,
                                    AppLocalizations.of(context)!.name,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                AppTextField(
                                  controller: _emailController,
                                  label: AppLocalizations.of(context)!.email,
                                  hint: AppLocalizations.of(context)!.email,
                                  prefixIcon: Icons.email_outlined,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (v) => Validators.email(
                                    v,
                                    requiredMsg: AppLocalizations.of(
                                      context,
                                    )!.emailRequired,
                                    invalidMsg: AppLocalizations.of(
                                      context,
                                    )!.emailInvalid,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                AppTextField(
                                  controller: _phoneController,
                                  label: AppLocalizations.of(context)!.phone,
                                  hint: '01234567890',
                                  prefixIcon: Icons.phone_outlined,
                                  keyboardType: TextInputType.phone,
                                  maxLength: 11,
                                  validator: (v) => Validators.phone(
                                    v,
                                    requiredMsg: AppLocalizations.of(
                                      context,
                                    )!.phoneRequired,
                                    invalidMsg: AppLocalizations.of(
                                      context,
                                    )!.phoneInvalid,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                AppTextField(
                                  controller: _nationalIdController,
                                  label: AppLocalizations.of(
                                    context,
                                  )!.nationalId,
                                  hint: '29901011234567',
                                  prefixIcon: Icons.badge_outlined,
                                  keyboardType: TextInputType.number,
                                  maxLength: 14,
                                  validator: (v) => Validators.nationalId(
                                    v,
                                    AppLocalizations.of(
                                      context,
                                    )!.nationalIdRequired,
                                    AppLocalizations.of(
                                      context,
                                    )!.nationalIdInvalid,
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // Pharmacist Extra Section
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  child: _selectedRole == UserRole.pharmacist
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            _sectionTitle(
                                              Icons.local_pharmacy_outlined,
                                              AppLocalizations.of(
                                                context,
                                              )!.pharmacyName,
                                            ),
                                            const SizedBox(height: 12),
                                            AppTextField(
                                              controller:
                                                  _pharmacyNameController,
                                              label: AppLocalizations.of(
                                                context,
                                              )!.pharmacyName,
                                              hint: AppLocalizations.of(
                                                context,
                                              )!.pharmacyName,
                                              prefixIcon:
                                                  Icons.storefront_outlined,
                                              validator: (v) =>
                                                  Validators.required(
                                                    v,
                                                    AppLocalizations.of(
                                                      context,
                                                    )!.pharmacyName,
                                                  ),
                                            ),
                                            const SizedBox(height: 20),

                                            // Premium License Upload
                                            InkWell(
                                              onTap: _pickLicenseImage,
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              child: AnimatedContainer(
                                                duration: const Duration(
                                                  milliseconds: 200,
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 24,
                                                      horizontal: 20,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: AppColors.primary
                                                      .withValues(alpha: 0.05),
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  border: Border.all(
                                                    color: _licensePath != null
                                                        ? AppColors.success
                                                        : AppColors.primary
                                                              .withValues(
                                                                alpha: 0.3,
                                                              ),
                                                    width: _licensePath != null
                                                        ? 2
                                                        : 1,
                                                  ),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Icon(
                                                      _licensePath != null
                                                          ? Icons
                                                                .verified_rounded
                                                          : Icons
                                                                .cloud_upload_outlined,
                                                      color:
                                                          _licensePath != null
                                                          ? AppColors.success
                                                          : AppColors.primary,
                                                      size: 32,
                                                    ),
                                                    const SizedBox(height: 12),
                                                    Text(
                                                      _licensePath != null
                                                          ? _licensePath!
                                                                .split('/')
                                                                .last
                                                          : AppLocalizations.of(
                                                              context,
                                                            )!.uploadLicense,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            _licensePath != null
                                                            ? AppColors.success
                                                            : AppColors
                                                                  .primaryDark,
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 32),
                                          ],
                                        )
                                      : const SizedBox.shrink(),
                                ),

                                // Address Section
                                _sectionTitle(
                                  Icons.location_on_outlined,
                                  _selectedRole == UserRole.pharmacist
                                      ? AppLocalizations.of(
                                          context,
                                        )!.addressInfo
                                      : AppLocalizations.of(context)!.address,
                                ),
                                const SizedBox(height: 12),
                                AppTextField(
                                  controller: _governorateController,
                                  label: AppLocalizations.of(
                                    context,
                                  )!.governorate,
                                  hint: AppLocalizations.of(
                                    context,
                                  )!.governorate,
                                  validator: (v) => Validators.required(
                                    v,
                                    AppLocalizations.of(context)!.governorate,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                AppTextField(
                                  controller: _cityController,
                                  label: AppLocalizations.of(context)!.city,
                                  hint: AppLocalizations.of(context)!.city,
                                  validator: (v) => Validators.required(
                                    v,
                                    AppLocalizations.of(context)!.city,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                AppTextField(
                                  controller: _villageController,
                                  label: AppLocalizations.of(context)!.village,
                                  hint: AppLocalizations.of(context)!.village,
                                ),
                                const SizedBox(height: 16),
                                AppTextField(
                                  controller: _streetController,
                                  label: AppLocalizations.of(context)!.street,
                                  hint: AppLocalizations.of(context)!.street,
                                  validator: (v) => Validators.required(
                                    v,
                                    AppLocalizations.of(context)!.street,
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // Security Section
                                _sectionTitle(
                                  Icons.security_outlined,
                                  AppLocalizations.of(context)!.password,
                                ),
                                const SizedBox(height: 12),
                                AppTextField(
                                  controller: _passwordController,
                                  label: AppLocalizations.of(context)!.password,
                                  hint: "••••••••",
                                  prefixIcon: Icons.lock_outline,
                                  obscureText: _obscurePassword,
                                  validator: (v) => Validators.password(
                                    v,
                                    requiredMsg: AppLocalizations.of(
                                      context,
                                    )!.passwordRequired,
                                    weakMsg: AppLocalizations.of(
                                      context,
                                    )!.passwordTooShort,
                                  ),
                                  suffix: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: AppColors.textLight,
                                      size: 22,
                                    ),
                                    onPressed: () => setState(
                                      () =>
                                          _obscurePassword = !_obscurePassword,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                AppTextField(
                                  controller: _confirmPasswordController,
                                  label: AppLocalizations.of(
                                    context,
                                  )!.confirmPassword,
                                  hint: "••••••••",
                                  prefixIcon: Icons.lock_outline,
                                  obscureText: true,
                                  validator: (v) => Validators.confirmPassword(
                                    v,
                                    _passwordController.text,
                                    requiredMsg: AppLocalizations.of(
                                      context,
                                    )!.confirmPasswordRequired,
                                    mismatchMsg: AppLocalizations.of(
                                      context,
                                    )!.passwordsDoNotMatch,
                                  ),
                                ),
                                const SizedBox(height: 40),

                                // Register button
                                BlocBuilder<AuthBloc, AuthState>(
                                  builder: (context, state) {
                                    return SizedBox(
                                      height: 56,
                                      child: ElevatedButton(
                                        onPressed: state is AuthLoading
                                            ? null
                                            : _submit,
                                        style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                        ),
                                        child: state is AuthLoading
                                            ? const SizedBox(
                                                height: 24,
                                                width: 24,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                        Color
                                                      >(Colors.white),
                                                ),
                                              )
                                            : Text(
                                                AppLocalizations.of(
                                                  context,
                                                )!.signUp,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Login link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.hasAccount,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () => context.pop(),
                              child: Text(
                                AppLocalizations.of(context)!.signIn,
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryDark,
          ),
        ),
      ],
    );
  }
}
