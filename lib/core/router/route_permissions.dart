import '../config/rbac_config.dart';

/// Top-level constant mapping routes to required permissions.
/// Moved here to avoid rebuilding the map on every router redirect.
const Map<String, AppPermission> routePermissions = {
  '/user-home': AppPermission.viewUserHome,
  '/dashboard': AppPermission.viewDashboard,
  '/review': AppPermission.reviewDonations,
  '/manage-requests': AppPermission.manageRequests,
  '/qr-scan': AppPermission.scanQr,
  '/donate': AppPermission.donate,
  '/my-donations': AppPermission.viewMyDonations,
  '/request': AppPermission.requestMedicine,
  '/my-requests': AppPermission.viewMyRequests,
  '/notifications': AppPermission.viewNotifications,
  '/medicines': AppPermission.viewMedicines,
};
