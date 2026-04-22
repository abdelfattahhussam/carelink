/// API endpoint paths (relative to base URL)
class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'https://api.carelink.com/v1';

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  // TODO(backend): uploadId endpoint is declared but no route or screen uses it yet.
  // Remove or implement when backend delivers the upload-id flow.
  static const String uploadId = '/auth/upload-id';
  static const String profile = '/auth/profile';

  // Donations
  static const String donations = '/donations';
  static String donationById(String id) => '/donations/$id';
  static const String pendingDonations = '/donations/pending';

  // Medicines
  static const String medicines = '/medicines';
  static const String searchMedicines = '/medicines/search';
  static String medicineById(String id) => '/medicines/$id';

  // Requests
  static const String requests = '/requests';
  static String requestById(String id) => '/requests/$id';

  // QR
  static const String generateQr = '/qr/generate';
  static const String verifyQr = '/qr/verify';

  // Notifications
  static const String notifications = '/notifications';
  static String markRead(String id) => '/notifications/read/$id';

  // Pharmacist
  static const String reviewDonation = '/pharmacist/review';
  static const String approveRequest = '/pharmacist/approve-request';

  // Pharmacies
  static const String pharmacies = '/pharmacies';
  static String pharmacyByPharmacist(String id) => '/pharmacies/pharmacist/$id';
}
