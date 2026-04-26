// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'CareLink';

  @override
  String get home => 'Home';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get skip => 'Skip';

  @override
  String get next => 'Next';

  @override
  String get getStarted => 'Get Started';

  @override
  String get onboardingTitle1 => 'Donate Medicine';

  @override
  String get onboardingDesc1 =>
      'Donate your surplus medicine and help save lives by providing it to those in need.';

  @override
  String get onboardingTitle2 => 'Safe Pharmacy Check';

  @override
  String get onboardingDesc2 =>
      'Expert pharmacists strictly check expiry dates and quality to ensure your complete safety.';

  @override
  String get onboardingTitle3 => 'Easy & Fast Pickup';

  @override
  String get onboardingDesc3 =>
      'Find the medicine you need and pick it up easily and safely using your unique QR code.';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get demoAccounts => 'Demo Accounts';

  @override
  String get passwordAnyValue => 'Password: any value';

  @override
  String get createAccount => 'Create Account';

  @override
  String get backToLogin => 'Back to Login';

  @override
  String get jpgPngOrPdf => 'JPG, PNG or PDF (max 5MB)';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get logout => 'Logout';

  @override
  String get pleaseSelectExpiryDate => 'Please select expiry date';

  @override
  String get donationSubmittedSuccessfully =>
      'Donation submitted successfully!';

  @override
  String get donateMedicine => 'Donate Medicine';

  @override
  String get yourDonationWillBe =>
      'Your donation will be reviewed by a pharmacist before becoming available.';

  @override
  String get category => 'Category';

  @override
  String get myDonations => 'My Donations';

  @override
  String get donate => 'Donate';

  @override
  String get qr => 'QR';

  @override
  String get medicines => 'Medicines';

  @override
  String get searchMedicines => 'Search medicines...';

  @override
  String get notifications => 'Notifications';

  @override
  String get manageRequests => 'Manage Requests';

  @override
  String get urgent => 'URGENT';

  @override
  String get addReviewNotesOptional => 'Add review notes (optional)';

  @override
  String get cancel => 'Cancel';

  @override
  String get reviewDonations => 'Review Donations';

  @override
  String get reject => 'Reject';

  @override
  String get approve => 'Approve';

  @override
  String get qrCode => 'QR Code';

  @override
  String get carelink => 'CareLink';

  @override
  String get showThisQrCode =>
      'Show this QR code at the pharmacy\\nfor pickup verification.';

  @override
  String get deliveryConfirmedOnlyIf => 'Delivery confirmed only if QR matches';

  @override
  String get scanQrCode => 'Scan QR Code';

  @override
  String get enterQrCode => 'Enter QR Code';

  @override
  String get typeOrPasteThe => 'Type or paste the QR code value';

  @override
  String get testQrCodes => 'Test QR Codes:';

  @override
  String get cameraNotAvailableOn => 'Camera not available on emulator';

  @override
  String get useManualModeInstead => 'Use manual mode instead';

  @override
  String get qrCodeNotRecognized => 'QR Code Not Recognized';

  @override
  String get qrVerified => 'QR Verified!';

  @override
  String get deliveryConfirmed => 'Delivery confirmed!';

  @override
  String get myRequests => 'My Requests';

  @override
  String get showQr => 'Show QR';

  @override
  String get requestSubmitted => 'Request submitted!';

  @override
  String get requestMedicine => 'Request Medicine';

  @override
  String get medicineNotFound => 'Medicine not found';

  @override
  String get thisMedicineIsCurrently =>
      'This medicine is currently out of stock.';

  @override
  String get markAsUrgent => 'Mark as Urgent';

  @override
  String get urgentRequestsGetHigher => 'Urgent requests get higher priority';

  @override
  String get allCaughtUp => 'All Caught Up!';

  @override
  String get noPendingDonations => 'No pending donations to review.';

  @override
  String get camera => 'Camera';

  @override
  String get manual => 'Manual';

  @override
  String get verify => 'Verify';

  @override
  String get confirmDelivery => 'Confirm Delivery';

  @override
  String typeLabel(String type) {
    return 'Type: $type';
  }

  @override
  String get name => 'Name';

  @override
  String get status => 'Status';

  @override
  String get quantity => 'Quantity';

  @override
  String get qrCodeNotMatch => 'This QR code does not match any record.';

  @override
  String byNameQty(String name, String qty) {
    return 'By $name • Qty: $qty';
  }

  @override
  String stockCount(String count) {
    return 'Stock: $count';
  }

  @override
  String expiresAt(String date, String days) {
    return 'Expires: $date ($days days)';
  }

  @override
  String get quantityLabel => 'Quantity';

  @override
  String get howManyDoYouNeed => 'How many do you need?';

  @override
  String get enterValidQuantity => 'Enter valid quantity';

  @override
  String maxAvailable(String max) {
    return 'Max available: $max';
  }

  @override
  String get reasonLabel => 'Reason';

  @override
  String get whyDoYouNeedThis => 'Why do you need this medicine?';

  @override
  String get reasonRequired => 'Reason is required';

  @override
  String get submitRequest => 'Submit Request';

  @override
  String get noRequestsYet => 'No Requests Yet';

  @override
  String get browseMedicinesAndSubmit =>
      'Browse medicines and submit a request.';

  @override
  String qtyTimeAgo(String qty, String time) {
    return 'Qty: $qty • $time';
  }

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get fullName => 'Full Name';

  @override
  String get phone => 'Phone Number';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get noAccount => 'Don\'t have an account? ';

  @override
  String get hasAccount => 'Already have an account? ';

  @override
  String get signUp => 'Sign Up';

  @override
  String get signIn => 'Sign In';

  @override
  String get donor => 'Donor';

  @override
  String get patient => 'Patient';

  @override
  String get pharmacist => 'Pharmacist';

  @override
  String get selectRole => 'Select Your Role';

  @override
  String get pharmacyName => 'Pharmacy Name';

  @override
  String get governorate => 'Governorate';

  @override
  String get city => 'City/District';

  @override
  String get village => 'Village (Optional)';

  @override
  String get street => 'Street';

  @override
  String get uploadLicense => 'Upload Pharmacist License';

  @override
  String get licenseRequired => 'Pharmacist license image is required';

  @override
  String get address => 'Address';

  @override
  String get addressInfo => 'Pharmacy Address';

  @override
  String get profile => 'Profile';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get updateProfile => 'Update Profile';

  @override
  String get profileUpdatedSuccessfully => 'Profile updated successfully!';

  @override
  String get changePhoto => 'Change Photo';

  @override
  String get personalInfo => 'Personal Information';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get welcome => 'Welcome';

  @override
  String get totalDonations => 'Total Donations';

  @override
  String get pendingReviews => 'Pending Reviews';

  @override
  String get activeRequests => 'Active Requests';

  @override
  String get availableMedicines => 'Available Medicines';

  @override
  String get medicineName => 'Medicine Name';

  @override
  String get medicineDescription => 'Description';

  @override
  String get expiryDate => 'Expiry Date';

  @override
  String get uploadImage => 'Upload Image';

  @override
  String get submitDonation => 'Submit Donation';

  @override
  String get donationSuccess => 'Donation submitted successfully!';

  @override
  String get noMedicinesFound => 'No medicines found';

  @override
  String get inStock => 'In Stock';

  @override
  String get outOfStock => 'Out of Stock';

  @override
  String get markUrgent => 'Mark as Urgent';

  @override
  String get requestReason => 'Reason for Request';

  @override
  String get requestSuccess => 'Request submitted successfully!';

  @override
  String get reviewNotes => 'Review Notes';

  @override
  String get noNotifications => 'No notifications yet';

  @override
  String get pending => 'Pending';

  @override
  String get delivered => 'Delivered';

  @override
  String get expired => 'Expired';

  @override
  String get genericError => 'Something went wrong. Please try again.';

  @override
  String get networkError => 'No internet connection.';

  @override
  String get unauthorizedError => 'Session expired. Please login again.';

  @override
  String get validationError => 'Please fill in all required fields.';

  @override
  String signInToContinue(String appName) {
    return 'Sign in to continue to $appName';
  }

  @override
  String get donorWelcome =>
      'Your generosity helps those in need. Donate medicines today!';

  @override
  String get patientWelcome =>
      'Find the medicines you need. We\'re here to help.';

  @override
  String get userWelcome =>
      'Donate medicines or request what you need. We\'re here to help!';

  @override
  String get pharmacistWelcome =>
      'Review donations and manage requests efficiently.';

  @override
  String verifiedRole(String role) {
    return 'Verified $role';
  }

  @override
  String get scan => 'Scan';

  @override
  String get browse => 'Browse';

  @override
  String get alerts => 'Alerts';

  @override
  String get search => 'Search';

  @override
  String welcomeWithName(String name) {
    return 'Welcome, $name! 👋';
  }

  @override
  String get tryDifferentSearch => 'Try a different search term.';

  @override
  String inStockWithCount(String count) {
    return 'In Stock ($count)';
  }

  @override
  String expDate(String date) {
    return 'Exp: $date';
  }

  @override
  String get medicineNameHint => 'e.g. Amoxicillin 500mg';

  @override
  String get descriptionHint => 'Describe the medicine...';

  @override
  String get quantityHint => 'Number of units';

  @override
  String get selectExpiryDate => 'Select expiry date';

  @override
  String get medicineNameRequired => 'Medicine name is required';

  @override
  String get descriptionRequired => 'Description is required';

  @override
  String get expiryDateRequired => 'Expiry date is required';

  @override
  String get catGeneral => 'General';

  @override
  String get catAntibiotics => 'Antibiotics';

  @override
  String get catPainRelief => 'Pain Relief';

  @override
  String get catDigestive => 'Digestive';

  @override
  String get catDiabetes => 'Diabetes';

  @override
  String get catCardiovascular => 'Cardiovascular';

  @override
  String get catVitamins => 'Vitamins';

  @override
  String get catOther => 'Other';

  @override
  String get noDonationsYet => 'No Donations Yet';

  @override
  String get startByDonating =>
      'Start by donating medicines to help those in need.';

  @override
  String get youAreAllCaughtUp => 'You\'re all caught up!';

  @override
  String get noNotificationsTitle => 'No Notifications';

  @override
  String get secureUpload => 'Secure Upload';

  @override
  String get secureUploadDesc => 'Your ID is encrypted and stored securely.';

  @override
  String get quickReview => 'Quick Review';

  @override
  String get quickReviewDesc => 'Verification typically takes a few moments.';

  @override
  String get oneTimeProcess => 'One-time Process';

  @override
  String get oneTimeProcessDesc => 'You only need to verify once.';

  @override
  String get requestApprovedQrGenerated => 'Request approved! QR generated.';

  @override
  String get requestRejected => 'Request rejected.';

  @override
  String get noRequests => 'No Requests';

  @override
  String get noPatientRequestsAtMoment => 'No patient requests at the moment.';

  @override
  String get approved => 'Approved';

  @override
  String get available => 'Available';

  @override
  String get rejected => 'Rejected';

  @override
  String get instructionsTitle => 'Verification Guide';

  @override
  String get instruction1 => 'Use your original Government-issued ID card.';

  @override
  String get instruction2 => 'Ensure the lighting is bright and without glare.';

  @override
  String get instruction3 => 'Position the card clearly within the frame.';

  @override
  String get startVerification => 'Start Verification';

  @override
  String get notifDonationApprovedTitle => 'Donation Approved';

  @override
  String get notifDonationApprovedBody =>
      'Your donation has been verified by our team.';

  @override
  String get notifNewRequestTitle => 'New Request';

  @override
  String get notifNewRequestBody =>
      'A new medicine request is awaiting your review.';

  @override
  String get notifNewDonationTitle => 'New Donation';

  @override
  String get notifNewDonationBody =>
      'A new medicine donation has been submitted for review.';

  @override
  String get notifRequestApprovedTitle => 'Request Approved';

  @override
  String get notifRequestApprovedBody =>
      'Your request was approved. You can now pick up your medicine.';

  @override
  String get notifDonationRejectedTitle => 'Donation Rejected';

  @override
  String get notifDonationRejectedBody =>
      'Your donation was reviewed and rejected by the pharmacist.';

  @override
  String get notifRequestRejectedTitle => 'Request Rejected';

  @override
  String get notifRequestRejectedBody =>
      'Your medicine request was rejected. Please check the reason.';

  @override
  String get notifExpiryWarningTitle => 'Expiry Warning';

  @override
  String get notifExpiryWarningBody =>
      'Some medicines in your inventory are nearing expiry.';

  @override
  String get captureIdFront => 'Capture ID Front';

  @override
  String get captureIdBack => 'Capture ID Back';

  @override
  String get takeSelfie => 'Take a Selfie';

  @override
  String get idFrontInstruction =>
      'Position the front of your ID card within the frame.';

  @override
  String get idBackInstruction =>
      'Position the back of your ID card within the frame.';

  @override
  String get selfieInstruction =>
      'Please look straight at the camera to match your ID photo.';

  @override
  String stepXof3(String current) {
    return 'Step $current of 3';
  }

  @override
  String get nextStep => 'Next Step';

  @override
  String get previousStep => 'Previous Step';

  @override
  String get submitForVerification => 'Submit for Verification';

  @override
  String get confirmIDPhoto => 'Confirm Photo';

  @override
  String get retakePhoto => 'Retake Photo';

  @override
  String get gallery => 'Gallery';

  @override
  String get fromCameraOrGallery => 'Choose from Camera or Gallery';

  @override
  String get unit => 'Unit';

  @override
  String get box => 'Box';

  @override
  String get strip => 'Strip';

  @override
  String get pleaseWait => 'Please wait while the app considers routing...';

  @override
  String get unauthorizedAction =>
      'You do not have permission to perform this action.';

  @override
  String get medicineDetails => 'Medicine Details';

  @override
  String get attachPrescription => 'Attach Prescription';

  @override
  String get notesForPharmacist => 'Notes to pharmacist';

  @override
  String get prescriptionAttached => 'Prescription Attached';

  @override
  String get accountSettings => 'Account Settings';

  @override
  String get appearance => 'Appearance';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get currentLanguage => 'Current Language';

  @override
  String get attachBoxImage => 'Attach Box Image';

  @override
  String get boxImageRequired => 'Box image is required';

  @override
  String get boxImageAttached => 'Box Image Attached';

  @override
  String get nationalId => 'National ID';

  @override
  String get nationalIdRequired => 'National ID is required';

  @override
  String get nationalIdInvalid => 'National ID must be exactly 14 digits';

  @override
  String get patientNationalId => 'Patient National ID';

  @override
  String get nationalIdImmutableNote =>
      'National ID cannot be changed after registration';

  @override
  String get overview => 'Overview';

  @override
  String get close => 'Close';

  @override
  String get noApprovedRequests =>
      'No approved requests found. Check the list for status updates.';

  @override
  String get noApprovedDonations =>
      'No approved donations found. Check the list for status updates.';

  @override
  String get selectMedicineForPickup => 'Select medicine for pickup';

  @override
  String get selectMedicineForDelivery => 'Select medicine for delivery';

  @override
  String get confirmPickup => 'Confirm Pickup';

  @override
  String get confirmDeliveryLabel => 'Confirm Delivery';

  @override
  String get confirmDeliverySuccess => 'Delivery confirmed successfully!';

  @override
  String get confirmReceiptSuccess => 'Medicine received successfully!';

  @override
  String get waitPharmacistScan =>
      'Please show the QR to the pharmacist and wait for the scan.';

  @override
  String didYouDeliverMedicine(String medicine) {
    return 'Did you deliver $medicine to the pharmacist now?';
  }

  @override
  String didYouReceiveMedicine(String medicine) {
    return 'Did you receive $medicine from the pharmacist now?';
  }

  @override
  String get emailRequired => 'Email is required';

  @override
  String get emailInvalid => 'Please enter a valid email';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get confirmPasswordRequired => 'Please confirm your password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get phoneRequired => 'Phone number is required';

  @override
  String get phoneInvalid => 'Phone number must be exactly 11 digits';

  @override
  String get requestDetails => 'Request Details';

  @override
  String get decisionPanel => 'Decision Panel';

  @override
  String get availableStock => 'Available Stock';

  @override
  String get boxes => 'Boxes';

  @override
  String get strips => 'Strips';

  @override
  String get prescription => 'Prescription';

  @override
  String get selectRejectionReason => 'Select Rejection Reason';

  @override
  String get confirmRejection => 'Confirm Rejection';

  @override
  String get otherReason => 'Other reason';

  @override
  String get enterCustomReason => 'Enter custom reason...';

  @override
  String get reasonForRejection => 'Reason for rejection:';

  @override
  String get boxSingular => 'Box';

  @override
  String get stripSingular => 'Strip';

  @override
  String get pendingReview => 'Pending Review';

  @override
  String get review => 'Review';

  @override
  String get retry => 'Retry';

  @override
  String get selectPharmacy => 'Select Pharmacy';

  @override
  String get pharmacyRequired => 'Please select a pharmacy';

  @override
  String get filterByGovernorate => 'Governorate';

  @override
  String get filterByCity => 'City';

  @override
  String get filterByDistrict => 'District';

  @override
  String get allGovernorates => 'All Governorates';

  @override
  String get allCities => 'All Cities';

  @override
  String get allDistricts => 'All Districts';

  @override
  String get resubmitToAnotherPharmacy => 'Resubmit to Another Pharmacy';

  @override
  String get noPharmaciesFound => 'No pharmacies found';

  @override
  String get noPharmaciesInArea => 'No pharmacies available in this area';

  @override
  String get pharmacyLocation => 'Pharmacy Location';

  @override
  String get availableAtPharmacy => 'Available at';

  @override
  String get donatedTo => 'Donated to';

  @override
  String get clearFilter => 'Clear';

  @override
  String get filterExpiringSoon => 'Expiring Soon';

  @override
  String get filterLowStock => 'Low Stock';

  @override
  String get filterExpired => 'Expired';

  @override
  String get filterOutOfStock => 'Out of Stock';

  @override
  String get filterCategory => 'Category';

  @override
  String get filterAvailableNow => 'Available Now';

  @override
  String get allCategories => 'All Categories';

  @override
  String get all => 'All';

  @override
  String get noRequestsFound => 'No Requests Found';

  @override
  String get noDonationsFound => 'No Donations Found';

  @override
  String get registrationSuccess => 'Account created successfully!';

  @override
  String get roleUser => 'User';

  @override
  String get recentActivity => 'Recent Activity';

  @override
  String get seeAll => 'See All';
}
