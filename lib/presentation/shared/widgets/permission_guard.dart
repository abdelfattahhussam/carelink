import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/config/rbac_config.dart';
import '../../blocs/auth/auth_bloc.dart';

/// Conditionally shows [child] based on whether the current user
/// has the required [permission]. Shows [fallback] otherwise.
///
/// Usage:
/// ```dart
/// PermissionGuard(
///   permission: AppPermission.scanQr,
///   child: QrScanButton(),
/// )
/// ```
class PermissionGuard extends StatelessWidget {
  final AppPermission permission;
  final Widget child;
  final Widget fallback;

  const PermissionGuard({
    super.key,
    required this.permission,
    required this.child,
    this.fallback = const SizedBox.shrink(),
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (prev, curr) =>
          curr is AuthAuthenticated || curr is AuthUnauthenticated,
      builder: (context, state) {
        if (state is! AuthAuthenticated) return fallback;
        return RBACConfig.can(state.user, permission) ? child : fallback;
      },
    );
  }
}
