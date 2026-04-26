import '../../data/models/user_model.dart';

/// Enum representing all granular permissions in the application
enum AppPermission {
  viewDashboard,
  reviewDonations,
  manageRequests,
  scanQr,
  donate,
  viewMyDonations,
  requestMedicine,
  viewMyRequests,
  viewMedicines,
  viewNotifications,
}

/// Central configuration for Role-Based Access Control
class RBACConfig {
  /// Map of roles to their allowed permissions
  static const Map<UserRole, Set<AppPermission>> _rolePermissions = {
    UserRole.pharmacist: {
      AppPermission.viewDashboard,
      AppPermission.reviewDonations,
      AppPermission.manageRequests,
      AppPermission.scanQr,
      AppPermission.viewMedicines,
      AppPermission.viewNotifications,
    },
    UserRole.donor: {
      AppPermission.donate,
      AppPermission.viewMyDonations,
      AppPermission.viewMedicines,
      AppPermission.viewNotifications,
    },
    UserRole.patient: {
      AppPermission.requestMedicine,
      AppPermission.viewMyRequests,
      AppPermission.viewMedicines,
      AppPermission.viewNotifications,
    },
  };

  /// Check if a specific role has a permission
  static bool hasPermission(UserRole role, AppPermission permission) {
    return _rolePermissions[role]?.contains(permission) ?? false;
  }

  /// Helper for UI to check permissions
  static bool can(UserModel? user, AppPermission permission) {
    if (user == null) return false;
    return hasPermission(user.role, permission);
  }

  /// Get the default home route for a specific role
  static String homeRouteFor(UserRole role) {
    return switch (role) {
      UserRole.pharmacist => '/dashboard',
      UserRole.donor => '/donor-home',
      UserRole.patient => '/patient-home',
    };
  }
}
