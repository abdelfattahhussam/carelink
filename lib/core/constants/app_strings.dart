/// Centralized string constants for CareLink
class AppStrings {
  AppStrings._();

  static const String appName = 'CareLink';
  static const String appTagline = 'Connecting Care, One Medicine at a Time';

  // Auth
  static const String login = 'Login';
  static const String register = 'Register';
  static const String logout = 'Logout';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String fullName = 'Full Name';
  static const String phone = 'Phone Number';
  static const String forgotPassword = 'Forgot Password?';
  static const String noAccount = "Don't have an account? ";
  static const String hasAccount = 'Already have an account? ';
  static const String signUp = 'Sign Up';
  static const String signIn = 'Sign In';

  // Roles
  static const String donor = 'Donor';
  static const String patient = 'Patient';
  static const String pharmacist = 'Pharmacist';
  static const String selectRole = 'Select Your Role';

  // Upload ID
  static const String uploadId = 'Upload ID';
  static const String uploadIdTitle = 'Identity Verification';
  static const String uploadIdDesc =
      'Please upload a valid government-issued ID for verification.';
  static const String pendingVerification = 'Pending Verification';
  static const String pendingVerificationDesc =
      'Your identity is being verified. This usually takes a few moments.';

  // Dashboard
  static const String dashboard = 'Dashboard';
  static const String welcome = 'Welcome';
  static const String totalDonations = 'Total Donations';
  static const String pendingReviews = 'Pending Reviews';
  static const String activeRequests = 'Active Requests';
  static const String availableMedicines = 'Available Medicines';

  // Donation
  static const String donateMedicine = 'Donate Medicine';
  static const String medicineName = 'Medicine Name';
  static const String medicineDescription = 'Description';
  static const String expiryDate = 'Expiry Date';
  static const String quantity = 'Quantity';
  static const String uploadImage = 'Upload Image';
  static const String submitDonation = 'Submit Donation';
  static const String donationSuccess = 'Donation submitted successfully!';
  static const String myDonations = 'My Donations';

  // Medicine
  static const String medicines = 'Medicines';
  static const String searchMedicines = 'Search medicines...';
  static const String noMedicinesFound = 'No medicines found';
  static const String inStock = 'In Stock';
  static const String outOfStock = 'Out of Stock';

  // Request
  static const String requestMedicine = 'Request Medicine';
  static const String markUrgent = 'Mark as Urgent';
  static const String requestReason = 'Reason for Request';
  static const String requestSuccess = 'Request submitted successfully!';
  static const String myRequests = 'My Requests';

  // Pharmacist
  static const String reviewDonations = 'Review Donations';
  static const String approve = 'Approve';
  static const String reject = 'Reject';
  static const String reviewNotes = 'Review Notes';

  // QR
  static const String scanQr = 'Scan QR Code';
  static const String showQr = 'Show QR Code';
  static const String qrVerified = 'QR Code verified successfully!';
  static const String qrMismatch = 'QR Code does not match!';

  // Notifications
  static const String notifications = 'Notifications';
  static const String noNotifications = 'No notifications yet';

  // Status
  static const String pending = 'Pending';
  static const String approved = 'Approved';
  static const String rejected = 'Rejected';
  static const String expired = 'Expired';
  static const String delivered = 'Delivered';

  // Errors
  static const String genericError = 'Something went wrong. Please try again.';
  static const String networkError = 'No internet connection.';
  static const String unauthorizedError =
      'Session expired. Please login again.';
  static const String validationError = 'Please fill in all required fields.';
}
