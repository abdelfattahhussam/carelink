import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'CareLink'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Donate Medicine'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDesc1.
  ///
  /// In en, this message translates to:
  /// **'Donate your surplus medicine and help save lives by providing it to those in need.'**
  String get onboardingDesc1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Safe Pharmacy Check'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDesc2.
  ///
  /// In en, this message translates to:
  /// **'Expert pharmacists strictly check expiry dates and quality to ensure your complete safety.'**
  String get onboardingDesc2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Easy & Fast Pickup'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDesc3.
  ///
  /// In en, this message translates to:
  /// **'Find the medicine you need and pick it up easily and safely using your unique QR code.'**
  String get onboardingDesc3;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @demoAccounts.
  ///
  /// In en, this message translates to:
  /// **'Demo Accounts'**
  String get demoAccounts;

  /// No description provided for @passwordAnyValue.
  ///
  /// In en, this message translates to:
  /// **'Password: any value'**
  String get passwordAnyValue;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get backToLogin;

  /// No description provided for @jpgPngOrPdf.
  ///
  /// In en, this message translates to:
  /// **'JPG, PNG or PDF (max 5MB)'**
  String get jpgPngOrPdf;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @pleaseSelectExpiryDate.
  ///
  /// In en, this message translates to:
  /// **'Please select expiry date'**
  String get pleaseSelectExpiryDate;

  /// No description provided for @donationSubmittedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Donation submitted successfully!'**
  String get donationSubmittedSuccessfully;

  /// No description provided for @donateMedicine.
  ///
  /// In en, this message translates to:
  /// **'Donate Medicine'**
  String get donateMedicine;

  /// No description provided for @yourDonationWillBe.
  ///
  /// In en, this message translates to:
  /// **'Your donation will be reviewed by a pharmacist before becoming available.'**
  String get yourDonationWillBe;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @myDonations.
  ///
  /// In en, this message translates to:
  /// **'My Donations'**
  String get myDonations;

  /// No description provided for @donate.
  ///
  /// In en, this message translates to:
  /// **'Donate'**
  String get donate;

  /// No description provided for @qr.
  ///
  /// In en, this message translates to:
  /// **'QR'**
  String get qr;

  /// No description provided for @medicines.
  ///
  /// In en, this message translates to:
  /// **'Medicines'**
  String get medicines;

  /// No description provided for @searchMedicines.
  ///
  /// In en, this message translates to:
  /// **'Search medicines...'**
  String get searchMedicines;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @manageRequests.
  ///
  /// In en, this message translates to:
  /// **'Manage Requests'**
  String get manageRequests;

  /// No description provided for @urgent.
  ///
  /// In en, this message translates to:
  /// **'URGENT'**
  String get urgent;

  /// No description provided for @addReviewNotesOptional.
  ///
  /// In en, this message translates to:
  /// **'Add review notes (optional)'**
  String get addReviewNotesOptional;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @reviewDonations.
  ///
  /// In en, this message translates to:
  /// **'Review Donations'**
  String get reviewDonations;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// No description provided for @qrCode.
  ///
  /// In en, this message translates to:
  /// **'QR Code'**
  String get qrCode;

  /// No description provided for @carelink.
  ///
  /// In en, this message translates to:
  /// **'CareLink'**
  String get carelink;

  /// No description provided for @showThisQrCode.
  ///
  /// In en, this message translates to:
  /// **'Show this QR code at the pharmacy\\nfor pickup verification.'**
  String get showThisQrCode;

  /// No description provided for @deliveryConfirmedOnlyIf.
  ///
  /// In en, this message translates to:
  /// **'Delivery confirmed only if QR matches'**
  String get deliveryConfirmedOnlyIf;

  /// No description provided for @scanQrCode.
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get scanQrCode;

  /// No description provided for @enterQrCode.
  ///
  /// In en, this message translates to:
  /// **'Enter QR Code'**
  String get enterQrCode;

  /// No description provided for @typeOrPasteThe.
  ///
  /// In en, this message translates to:
  /// **'Type or paste the QR code value'**
  String get typeOrPasteThe;

  /// No description provided for @testQrCodes.
  ///
  /// In en, this message translates to:
  /// **'Test QR Codes:'**
  String get testQrCodes;

  /// No description provided for @cameraNotAvailableOn.
  ///
  /// In en, this message translates to:
  /// **'Camera not available on emulator'**
  String get cameraNotAvailableOn;

  /// No description provided for @useManualModeInstead.
  ///
  /// In en, this message translates to:
  /// **'Use manual mode instead'**
  String get useManualModeInstead;

  /// No description provided for @qrCodeNotRecognized.
  ///
  /// In en, this message translates to:
  /// **'QR Code Not Recognized'**
  String get qrCodeNotRecognized;

  /// No description provided for @qrVerified.
  ///
  /// In en, this message translates to:
  /// **'QR Verified!'**
  String get qrVerified;

  /// No description provided for @deliveryConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Delivery confirmed!'**
  String get deliveryConfirmed;

  /// No description provided for @myRequests.
  ///
  /// In en, this message translates to:
  /// **'My Requests'**
  String get myRequests;

  /// No description provided for @showQr.
  ///
  /// In en, this message translates to:
  /// **'Show QR'**
  String get showQr;

  /// No description provided for @requestSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Request submitted!'**
  String get requestSubmitted;

  /// No description provided for @requestMedicine.
  ///
  /// In en, this message translates to:
  /// **'Request Medicine'**
  String get requestMedicine;

  /// No description provided for @medicineNotFound.
  ///
  /// In en, this message translates to:
  /// **'Medicine not found'**
  String get medicineNotFound;

  /// No description provided for @thisMedicineIsCurrently.
  ///
  /// In en, this message translates to:
  /// **'This medicine is currently out of stock.'**
  String get thisMedicineIsCurrently;

  /// No description provided for @markAsUrgent.
  ///
  /// In en, this message translates to:
  /// **'Mark as Urgent'**
  String get markAsUrgent;

  /// No description provided for @urgentRequestsGetHigher.
  ///
  /// In en, this message translates to:
  /// **'Urgent requests get higher priority'**
  String get urgentRequestsGetHigher;

  /// No description provided for @allCaughtUp.
  ///
  /// In en, this message translates to:
  /// **'All Caught Up!'**
  String get allCaughtUp;

  /// No description provided for @noPendingDonations.
  ///
  /// In en, this message translates to:
  /// **'No pending donations to review.'**
  String get noPendingDonations;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @manual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get manual;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @confirmDelivery.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delivery'**
  String get confirmDelivery;

  /// No description provided for @typeLabel.
  ///
  /// In en, this message translates to:
  /// **'Type: {type}'**
  String typeLabel(String type);

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @qrCodeNotMatch.
  ///
  /// In en, this message translates to:
  /// **'This QR code does not match any record.'**
  String get qrCodeNotMatch;

  /// No description provided for @byNameQty.
  ///
  /// In en, this message translates to:
  /// **'By {name} • Qty: {qty}'**
  String byNameQty(String name, String qty);

  /// No description provided for @stockCount.
  ///
  /// In en, this message translates to:
  /// **'Stock: {count}'**
  String stockCount(String count);

  /// No description provided for @expiresAt.
  ///
  /// In en, this message translates to:
  /// **'Expires: {date} ({days} days)'**
  String expiresAt(String date, String days);

  /// No description provided for @quantityLabel.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantityLabel;

  /// No description provided for @howManyDoYouNeed.
  ///
  /// In en, this message translates to:
  /// **'How many do you need?'**
  String get howManyDoYouNeed;

  /// No description provided for @enterValidQuantity.
  ///
  /// In en, this message translates to:
  /// **'Enter valid quantity'**
  String get enterValidQuantity;

  /// No description provided for @maxAvailable.
  ///
  /// In en, this message translates to:
  /// **'Max available: {max}'**
  String maxAvailable(String max);

  /// No description provided for @reasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get reasonLabel;

  /// No description provided for @whyDoYouNeedThis.
  ///
  /// In en, this message translates to:
  /// **'Why do you need this medicine?'**
  String get whyDoYouNeedThis;

  /// No description provided for @reasonRequired.
  ///
  /// In en, this message translates to:
  /// **'Reason is required'**
  String get reasonRequired;

  /// No description provided for @submitRequest.
  ///
  /// In en, this message translates to:
  /// **'Submit Request'**
  String get submitRequest;

  /// No description provided for @noRequestsYet.
  ///
  /// In en, this message translates to:
  /// **'No Requests Yet'**
  String get noRequestsYet;

  /// No description provided for @browseMedicinesAndSubmit.
  ///
  /// In en, this message translates to:
  /// **'Browse medicines and submit a request.'**
  String get browseMedicinesAndSubmit;

  /// No description provided for @qtyTimeAgo.
  ///
  /// In en, this message translates to:
  /// **'Qty: {qty} • {time}'**
  String qtyTimeAgo(String qty, String time);

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get noAccount;

  /// No description provided for @hasAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get hasAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @donor.
  ///
  /// In en, this message translates to:
  /// **'Donor'**
  String get donor;

  /// No description provided for @patient.
  ///
  /// In en, this message translates to:
  /// **'Patient'**
  String get patient;

  /// No description provided for @pharmacist.
  ///
  /// In en, this message translates to:
  /// **'Pharmacist'**
  String get pharmacist;

  /// No description provided for @selectRole.
  ///
  /// In en, this message translates to:
  /// **'Select Your Role'**
  String get selectRole;

  /// No description provided for @pharmacyName.
  ///
  /// In en, this message translates to:
  /// **'Pharmacy Name'**
  String get pharmacyName;

  /// No description provided for @governorate.
  ///
  /// In en, this message translates to:
  /// **'Governorate'**
  String get governorate;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City/District'**
  String get city;

  /// No description provided for @village.
  ///
  /// In en, this message translates to:
  /// **'Village (Optional)'**
  String get village;

  /// No description provided for @street.
  ///
  /// In en, this message translates to:
  /// **'Street'**
  String get street;

  /// No description provided for @uploadLicense.
  ///
  /// In en, this message translates to:
  /// **'Upload Pharmacist License'**
  String get uploadLicense;

  /// No description provided for @licenseRequired.
  ///
  /// In en, this message translates to:
  /// **'Pharmacist license image is required'**
  String get licenseRequired;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @addressInfo.
  ///
  /// In en, this message translates to:
  /// **'Pharmacy Address'**
  String get addressInfo;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @updateProfile.
  ///
  /// In en, this message translates to:
  /// **'Update Profile'**
  String get updateProfile;

  /// No description provided for @profileUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully!'**
  String get profileUpdatedSuccessfully;

  /// No description provided for @changePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change Photo'**
  String get changePhoto;

  /// No description provided for @personalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInfo;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @totalDonations.
  ///
  /// In en, this message translates to:
  /// **'Total Donations'**
  String get totalDonations;

  /// No description provided for @pendingReviews.
  ///
  /// In en, this message translates to:
  /// **'Pending Reviews'**
  String get pendingReviews;

  /// No description provided for @activeRequests.
  ///
  /// In en, this message translates to:
  /// **'Active Requests'**
  String get activeRequests;

  /// No description provided for @availableMedicines.
  ///
  /// In en, this message translates to:
  /// **'Available Medicines'**
  String get availableMedicines;

  /// No description provided for @medicineName.
  ///
  /// In en, this message translates to:
  /// **'Medicine Name'**
  String get medicineName;

  /// No description provided for @medicineDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get medicineDescription;

  /// No description provided for @expiryDate.
  ///
  /// In en, this message translates to:
  /// **'Expiry Date'**
  String get expiryDate;

  /// No description provided for @uploadImage.
  ///
  /// In en, this message translates to:
  /// **'Upload Image'**
  String get uploadImage;

  /// No description provided for @submitDonation.
  ///
  /// In en, this message translates to:
  /// **'Submit Donation'**
  String get submitDonation;

  /// No description provided for @donationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Donation submitted successfully!'**
  String get donationSuccess;

  /// No description provided for @noMedicinesFound.
  ///
  /// In en, this message translates to:
  /// **'No medicines found'**
  String get noMedicinesFound;

  /// No description provided for @inStock.
  ///
  /// In en, this message translates to:
  /// **'In Stock'**
  String get inStock;

  /// No description provided for @outOfStock.
  ///
  /// In en, this message translates to:
  /// **'Out of Stock'**
  String get outOfStock;

  /// No description provided for @markUrgent.
  ///
  /// In en, this message translates to:
  /// **'Mark as Urgent'**
  String get markUrgent;

  /// No description provided for @requestReason.
  ///
  /// In en, this message translates to:
  /// **'Reason for Request'**
  String get requestReason;

  /// No description provided for @requestSuccess.
  ///
  /// In en, this message translates to:
  /// **'Request submitted successfully!'**
  String get requestSuccess;

  /// No description provided for @reviewNotes.
  ///
  /// In en, this message translates to:
  /// **'Review Notes'**
  String get reviewNotes;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get noNotifications;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @delivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get delivered;

  /// No description provided for @expired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expired;

  /// No description provided for @genericError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get genericError;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'No internet connection.'**
  String get networkError;

  /// No description provided for @unauthorizedError.
  ///
  /// In en, this message translates to:
  /// **'Session expired. Please login again.'**
  String get unauthorizedError;

  /// No description provided for @validationError.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all required fields.'**
  String get validationError;

  /// No description provided for @signInToContinue.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue to {appName}'**
  String signInToContinue(String appName);

  /// No description provided for @donorWelcome.
  ///
  /// In en, this message translates to:
  /// **'Your generosity helps those in need. Donate medicines today!'**
  String get donorWelcome;

  /// No description provided for @patientWelcome.
  ///
  /// In en, this message translates to:
  /// **'Find the medicines you need. We\'re here to help.'**
  String get patientWelcome;

  /// No description provided for @userWelcome.
  ///
  /// In en, this message translates to:
  /// **'Donate medicines or request what you need. We\'re here to help!'**
  String get userWelcome;

  /// No description provided for @pharmacistWelcome.
  ///
  /// In en, this message translates to:
  /// **'Review donations and manage requests efficiently.'**
  String get pharmacistWelcome;

  /// No description provided for @verifiedRole.
  ///
  /// In en, this message translates to:
  /// **'Verified {role}'**
  String verifiedRole(String role);

  /// No description provided for @scan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get scan;

  /// No description provided for @browse.
  ///
  /// In en, this message translates to:
  /// **'Browse'**
  String get browse;

  /// No description provided for @alerts.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get alerts;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @welcomeWithName.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}! 👋'**
  String welcomeWithName(String name);

  /// No description provided for @tryDifferentSearch.
  ///
  /// In en, this message translates to:
  /// **'Try a different search term.'**
  String get tryDifferentSearch;

  /// No description provided for @inStockWithCount.
  ///
  /// In en, this message translates to:
  /// **'In Stock ({count})'**
  String inStockWithCount(String count);

  /// No description provided for @expDate.
  ///
  /// In en, this message translates to:
  /// **'Exp: {date}'**
  String expDate(String date);

  /// No description provided for @medicineNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Amoxicillin 500mg'**
  String get medicineNameHint;

  /// No description provided for @descriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Describe the medicine...'**
  String get descriptionHint;

  /// No description provided for @quantityHint.
  ///
  /// In en, this message translates to:
  /// **'Number of units'**
  String get quantityHint;

  /// No description provided for @selectExpiryDate.
  ///
  /// In en, this message translates to:
  /// **'Select expiry date'**
  String get selectExpiryDate;

  /// No description provided for @medicineNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Medicine name is required'**
  String get medicineNameRequired;

  /// No description provided for @descriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'Description is required'**
  String get descriptionRequired;

  /// No description provided for @expiryDateRequired.
  ///
  /// In en, this message translates to:
  /// **'Expiry date is required'**
  String get expiryDateRequired;

  /// No description provided for @catGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get catGeneral;

  /// No description provided for @catAntibiotics.
  ///
  /// In en, this message translates to:
  /// **'Antibiotics'**
  String get catAntibiotics;

  /// No description provided for @catPainRelief.
  ///
  /// In en, this message translates to:
  /// **'Pain Relief'**
  String get catPainRelief;

  /// No description provided for @catDigestive.
  ///
  /// In en, this message translates to:
  /// **'Digestive'**
  String get catDigestive;

  /// No description provided for @catDiabetes.
  ///
  /// In en, this message translates to:
  /// **'Diabetes'**
  String get catDiabetes;

  /// No description provided for @catCardiovascular.
  ///
  /// In en, this message translates to:
  /// **'Cardiovascular'**
  String get catCardiovascular;

  /// No description provided for @catVitamins.
  ///
  /// In en, this message translates to:
  /// **'Vitamins'**
  String get catVitamins;

  /// No description provided for @catOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get catOther;

  /// No description provided for @noDonationsYet.
  ///
  /// In en, this message translates to:
  /// **'No Donations Yet'**
  String get noDonationsYet;

  /// No description provided for @startByDonating.
  ///
  /// In en, this message translates to:
  /// **'Start by donating medicines to help those in need.'**
  String get startByDonating;

  /// No description provided for @youAreAllCaughtUp.
  ///
  /// In en, this message translates to:
  /// **'You\'re all caught up!'**
  String get youAreAllCaughtUp;

  /// No description provided for @noNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'No Notifications'**
  String get noNotificationsTitle;

  /// No description provided for @secureUpload.
  ///
  /// In en, this message translates to:
  /// **'Secure Upload'**
  String get secureUpload;

  /// No description provided for @secureUploadDesc.
  ///
  /// In en, this message translates to:
  /// **'Your ID is encrypted and stored securely.'**
  String get secureUploadDesc;

  /// No description provided for @quickReview.
  ///
  /// In en, this message translates to:
  /// **'Quick Review'**
  String get quickReview;

  /// No description provided for @quickReviewDesc.
  ///
  /// In en, this message translates to:
  /// **'Verification typically takes a few moments.'**
  String get quickReviewDesc;

  /// No description provided for @oneTimeProcess.
  ///
  /// In en, this message translates to:
  /// **'One-time Process'**
  String get oneTimeProcess;

  /// No description provided for @oneTimeProcessDesc.
  ///
  /// In en, this message translates to:
  /// **'You only need to verify once.'**
  String get oneTimeProcessDesc;

  /// No description provided for @requestApprovedQrGenerated.
  ///
  /// In en, this message translates to:
  /// **'Request approved! QR generated.'**
  String get requestApprovedQrGenerated;

  /// No description provided for @requestRejected.
  ///
  /// In en, this message translates to:
  /// **'Request rejected.'**
  String get requestRejected;

  /// No description provided for @noRequests.
  ///
  /// In en, this message translates to:
  /// **'No Requests'**
  String get noRequests;

  /// No description provided for @noPatientRequestsAtMoment.
  ///
  /// In en, this message translates to:
  /// **'No patient requests at the moment.'**
  String get noPatientRequestsAtMoment;

  /// No description provided for @approved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approved;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @instructionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Verification Guide'**
  String get instructionsTitle;

  /// No description provided for @instruction1.
  ///
  /// In en, this message translates to:
  /// **'Use your original Government-issued ID card.'**
  String get instruction1;

  /// No description provided for @instruction2.
  ///
  /// In en, this message translates to:
  /// **'Ensure the lighting is bright and without glare.'**
  String get instruction2;

  /// No description provided for @instruction3.
  ///
  /// In en, this message translates to:
  /// **'Position the card clearly within the frame.'**
  String get instruction3;

  /// No description provided for @startVerification.
  ///
  /// In en, this message translates to:
  /// **'Start Verification'**
  String get startVerification;

  /// No description provided for @notifDonationApprovedTitle.
  ///
  /// In en, this message translates to:
  /// **'Donation Approved'**
  String get notifDonationApprovedTitle;

  /// No description provided for @notifDonationApprovedBody.
  ///
  /// In en, this message translates to:
  /// **'Your donation has been verified by our team.'**
  String get notifDonationApprovedBody;

  /// No description provided for @notifNewRequestTitle.
  ///
  /// In en, this message translates to:
  /// **'New Request'**
  String get notifNewRequestTitle;

  /// No description provided for @notifNewRequestBody.
  ///
  /// In en, this message translates to:
  /// **'A new medicine request is awaiting your review.'**
  String get notifNewRequestBody;

  /// No description provided for @notifNewDonationTitle.
  ///
  /// In en, this message translates to:
  /// **'New Donation'**
  String get notifNewDonationTitle;

  /// No description provided for @notifNewDonationBody.
  ///
  /// In en, this message translates to:
  /// **'A new medicine donation has been submitted for review.'**
  String get notifNewDonationBody;

  /// No description provided for @notifRequestApprovedTitle.
  ///
  /// In en, this message translates to:
  /// **'Request Approved'**
  String get notifRequestApprovedTitle;

  /// No description provided for @notifRequestApprovedBody.
  ///
  /// In en, this message translates to:
  /// **'Your request was approved. You can now pick up your medicine.'**
  String get notifRequestApprovedBody;

  /// No description provided for @notifDonationRejectedTitle.
  ///
  /// In en, this message translates to:
  /// **'Donation Rejected'**
  String get notifDonationRejectedTitle;

  /// No description provided for @notifDonationRejectedBody.
  ///
  /// In en, this message translates to:
  /// **'Your donation was reviewed and rejected by the pharmacist.'**
  String get notifDonationRejectedBody;

  /// No description provided for @notifRequestRejectedTitle.
  ///
  /// In en, this message translates to:
  /// **'Request Rejected'**
  String get notifRequestRejectedTitle;

  /// No description provided for @notifRequestRejectedBody.
  ///
  /// In en, this message translates to:
  /// **'Your medicine request was rejected. Please check the reason.'**
  String get notifRequestRejectedBody;

  /// No description provided for @notifExpiryWarningTitle.
  ///
  /// In en, this message translates to:
  /// **'Expiry Warning'**
  String get notifExpiryWarningTitle;

  /// No description provided for @notifExpiryWarningBody.
  ///
  /// In en, this message translates to:
  /// **'Some medicines in your inventory are nearing expiry.'**
  String get notifExpiryWarningBody;

  /// No description provided for @captureIdFront.
  ///
  /// In en, this message translates to:
  /// **'Capture ID Front'**
  String get captureIdFront;

  /// No description provided for @captureIdBack.
  ///
  /// In en, this message translates to:
  /// **'Capture ID Back'**
  String get captureIdBack;

  /// No description provided for @takeSelfie.
  ///
  /// In en, this message translates to:
  /// **'Take a Selfie'**
  String get takeSelfie;

  /// No description provided for @idFrontInstruction.
  ///
  /// In en, this message translates to:
  /// **'Position the front of your ID card within the frame.'**
  String get idFrontInstruction;

  /// No description provided for @idBackInstruction.
  ///
  /// In en, this message translates to:
  /// **'Position the back of your ID card within the frame.'**
  String get idBackInstruction;

  /// No description provided for @selfieInstruction.
  ///
  /// In en, this message translates to:
  /// **'Please look straight at the camera to match your ID photo.'**
  String get selfieInstruction;

  /// No description provided for @stepXof3.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of 3'**
  String stepXof3(String current);

  /// No description provided for @nextStep.
  ///
  /// In en, this message translates to:
  /// **'Next Step'**
  String get nextStep;

  /// No description provided for @previousStep.
  ///
  /// In en, this message translates to:
  /// **'Previous Step'**
  String get previousStep;

  /// No description provided for @submitForVerification.
  ///
  /// In en, this message translates to:
  /// **'Submit for Verification'**
  String get submitForVerification;

  /// No description provided for @confirmIDPhoto.
  ///
  /// In en, this message translates to:
  /// **'Confirm Photo'**
  String get confirmIDPhoto;

  /// No description provided for @retakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Retake Photo'**
  String get retakePhoto;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @fromCameraOrGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Camera or Gallery'**
  String get fromCameraOrGallery;

  /// No description provided for @unit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unit;

  /// No description provided for @box.
  ///
  /// In en, this message translates to:
  /// **'Box'**
  String get box;

  /// No description provided for @strip.
  ///
  /// In en, this message translates to:
  /// **'Strip'**
  String get strip;

  /// No description provided for @pleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait while the app considers routing...'**
  String get pleaseWait;

  /// No description provided for @unauthorizedAction.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to perform this action.'**
  String get unauthorizedAction;

  /// No description provided for @medicineDetails.
  ///
  /// In en, this message translates to:
  /// **'Medicine Details'**
  String get medicineDetails;

  /// No description provided for @attachPrescription.
  ///
  /// In en, this message translates to:
  /// **'Attach Prescription'**
  String get attachPrescription;

  /// No description provided for @notesForPharmacist.
  ///
  /// In en, this message translates to:
  /// **'Notes to pharmacist'**
  String get notesForPharmacist;

  /// No description provided for @prescriptionAttached.
  ///
  /// In en, this message translates to:
  /// **'Prescription Attached'**
  String get prescriptionAttached;

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get accountSettings;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @currentLanguage.
  ///
  /// In en, this message translates to:
  /// **'Current Language'**
  String get currentLanguage;

  /// No description provided for @attachBoxImage.
  ///
  /// In en, this message translates to:
  /// **'Attach Box Image'**
  String get attachBoxImage;

  /// No description provided for @boxImageRequired.
  ///
  /// In en, this message translates to:
  /// **'Box image is required'**
  String get boxImageRequired;

  /// No description provided for @boxImageAttached.
  ///
  /// In en, this message translates to:
  /// **'Box Image Attached'**
  String get boxImageAttached;

  /// No description provided for @nationalId.
  ///
  /// In en, this message translates to:
  /// **'National ID'**
  String get nationalId;

  /// No description provided for @nationalIdRequired.
  ///
  /// In en, this message translates to:
  /// **'National ID is required'**
  String get nationalIdRequired;

  /// No description provided for @nationalIdInvalid.
  ///
  /// In en, this message translates to:
  /// **'National ID must be exactly 14 digits'**
  String get nationalIdInvalid;

  /// No description provided for @patientNationalId.
  ///
  /// In en, this message translates to:
  /// **'Patient National ID'**
  String get patientNationalId;

  /// No description provided for @nationalIdImmutableNote.
  ///
  /// In en, this message translates to:
  /// **'National ID cannot be changed after registration'**
  String get nationalIdImmutableNote;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @noApprovedRequests.
  ///
  /// In en, this message translates to:
  /// **'No approved requests found. Check the list for status updates.'**
  String get noApprovedRequests;

  /// No description provided for @noApprovedDonations.
  ///
  /// In en, this message translates to:
  /// **'No approved donations found. Check the list for status updates.'**
  String get noApprovedDonations;

  /// No description provided for @selectMedicineForPickup.
  ///
  /// In en, this message translates to:
  /// **'Select medicine for pickup'**
  String get selectMedicineForPickup;

  /// No description provided for @selectMedicineForDelivery.
  ///
  /// In en, this message translates to:
  /// **'Select medicine for delivery'**
  String get selectMedicineForDelivery;

  /// No description provided for @confirmPickup.
  ///
  /// In en, this message translates to:
  /// **'Confirm Pickup'**
  String get confirmPickup;

  /// No description provided for @confirmDeliveryLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delivery'**
  String get confirmDeliveryLabel;

  /// No description provided for @confirmDeliverySuccess.
  ///
  /// In en, this message translates to:
  /// **'Delivery confirmed successfully!'**
  String get confirmDeliverySuccess;

  /// No description provided for @confirmReceiptSuccess.
  ///
  /// In en, this message translates to:
  /// **'Medicine received successfully!'**
  String get confirmReceiptSuccess;

  /// No description provided for @waitPharmacistScan.
  ///
  /// In en, this message translates to:
  /// **'Please show the QR to the pharmacist and wait for the scan.'**
  String get waitPharmacistScan;

  /// No description provided for @didYouDeliverMedicine.
  ///
  /// In en, this message translates to:
  /// **'Did you deliver {medicine} to the pharmacist now?'**
  String didYouDeliverMedicine(String medicine);

  /// No description provided for @didYouReceiveMedicine.
  ///
  /// In en, this message translates to:
  /// **'Did you receive {medicine} from the pharmacist now?'**
  String didYouReceiveMedicine(String medicine);

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get emailInvalid;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @confirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get confirmPasswordRequired;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneRequired;

  /// No description provided for @phoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Phone number must be exactly 11 digits'**
  String get phoneInvalid;

  /// No description provided for @requestDetails.
  ///
  /// In en, this message translates to:
  /// **'Request Details'**
  String get requestDetails;

  /// No description provided for @decisionPanel.
  ///
  /// In en, this message translates to:
  /// **'Decision Panel'**
  String get decisionPanel;

  /// No description provided for @availableStock.
  ///
  /// In en, this message translates to:
  /// **'Available Stock'**
  String get availableStock;

  /// No description provided for @boxes.
  ///
  /// In en, this message translates to:
  /// **'Boxes'**
  String get boxes;

  /// No description provided for @strips.
  ///
  /// In en, this message translates to:
  /// **'Strips'**
  String get strips;

  /// No description provided for @prescription.
  ///
  /// In en, this message translates to:
  /// **'Prescription'**
  String get prescription;

  /// No description provided for @selectRejectionReason.
  ///
  /// In en, this message translates to:
  /// **'Select Rejection Reason'**
  String get selectRejectionReason;

  /// No description provided for @confirmRejection.
  ///
  /// In en, this message translates to:
  /// **'Confirm Rejection'**
  String get confirmRejection;

  /// No description provided for @otherReason.
  ///
  /// In en, this message translates to:
  /// **'Other reason'**
  String get otherReason;

  /// No description provided for @enterCustomReason.
  ///
  /// In en, this message translates to:
  /// **'Enter custom reason...'**
  String get enterCustomReason;

  /// No description provided for @reasonForRejection.
  ///
  /// In en, this message translates to:
  /// **'Reason for rejection:'**
  String get reasonForRejection;

  /// No description provided for @boxSingular.
  ///
  /// In en, this message translates to:
  /// **'Box'**
  String get boxSingular;

  /// No description provided for @stripSingular.
  ///
  /// In en, this message translates to:
  /// **'Strip'**
  String get stripSingular;

  /// No description provided for @pendingReview.
  ///
  /// In en, this message translates to:
  /// **'Pending Review'**
  String get pendingReview;

  /// No description provided for @review.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get review;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @selectPharmacy.
  ///
  /// In en, this message translates to:
  /// **'Select Pharmacy'**
  String get selectPharmacy;

  /// No description provided for @pharmacyRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a pharmacy'**
  String get pharmacyRequired;

  /// No description provided for @filterByGovernorate.
  ///
  /// In en, this message translates to:
  /// **'Governorate'**
  String get filterByGovernorate;

  /// No description provided for @filterByCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get filterByCity;

  /// No description provided for @filterByDistrict.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get filterByDistrict;

  /// No description provided for @allGovernorates.
  ///
  /// In en, this message translates to:
  /// **'All Governorates'**
  String get allGovernorates;

  /// No description provided for @allCities.
  ///
  /// In en, this message translates to:
  /// **'All Cities'**
  String get allCities;

  /// No description provided for @allDistricts.
  ///
  /// In en, this message translates to:
  /// **'All Districts'**
  String get allDistricts;

  /// No description provided for @resubmitToAnotherPharmacy.
  ///
  /// In en, this message translates to:
  /// **'Resubmit to Another Pharmacy'**
  String get resubmitToAnotherPharmacy;

  /// No description provided for @noPharmaciesFound.
  ///
  /// In en, this message translates to:
  /// **'No pharmacies found'**
  String get noPharmaciesFound;

  /// No description provided for @noPharmaciesInArea.
  ///
  /// In en, this message translates to:
  /// **'No pharmacies available in this area'**
  String get noPharmaciesInArea;

  /// No description provided for @pharmacyLocation.
  ///
  /// In en, this message translates to:
  /// **'Pharmacy Location'**
  String get pharmacyLocation;

  /// No description provided for @availableAtPharmacy.
  ///
  /// In en, this message translates to:
  /// **'Available at'**
  String get availableAtPharmacy;

  /// No description provided for @donatedTo.
  ///
  /// In en, this message translates to:
  /// **'Donated to'**
  String get donatedTo;

  /// No description provided for @clearFilter.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clearFilter;

  /// No description provided for @filterExpiringSoon.
  ///
  /// In en, this message translates to:
  /// **'Expiring Soon'**
  String get filterExpiringSoon;

  /// No description provided for @filterLowStock.
  ///
  /// In en, this message translates to:
  /// **'Low Stock'**
  String get filterLowStock;

  /// No description provided for @filterExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get filterExpired;

  /// No description provided for @filterOutOfStock.
  ///
  /// In en, this message translates to:
  /// **'Out of Stock'**
  String get filterOutOfStock;

  /// No description provided for @filterCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get filterCategory;

  /// No description provided for @filterAvailableNow.
  ///
  /// In en, this message translates to:
  /// **'Available Now'**
  String get filterAvailableNow;

  /// No description provided for @allCategories.
  ///
  /// In en, this message translates to:
  /// **'All Categories'**
  String get allCategories;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @noRequestsFound.
  ///
  /// In en, this message translates to:
  /// **'No Requests Found'**
  String get noRequestsFound;

  /// No description provided for @noDonationsFound.
  ///
  /// In en, this message translates to:
  /// **'No Donations Found'**
  String get noDonationsFound;

  /// No description provided for @registrationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully!'**
  String get registrationSuccess;

  /// No description provided for @roleUser.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get roleUser;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @browseMedicines.
  ///
  /// In en, this message translates to:
  /// **'Browse Medicines'**
  String get browseMedicines;

  /// No description provided for @reviewDonationTitle.
  ///
  /// In en, this message translates to:
  /// **'{action} Donation'**
  String reviewDonationTitle(String action);

  /// No description provided for @confirmActionDonation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to {action} this donation?'**
  String confirmActionDonation(String action);

  /// No description provided for @selectRejectionReasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Select Rejection Reason:'**
  String get selectRejectionReasonLabel;

  /// No description provided for @rejectionReasonRequired.
  ///
  /// In en, this message translates to:
  /// **'Rejection reason is required'**
  String get rejectionReasonRequired;

  /// No description provided for @customReasonRequired.
  ///
  /// In en, this message translates to:
  /// **'Custom reason is required'**
  String get customReasonRequired;

  /// No description provided for @donationApprovedQr.
  ///
  /// In en, this message translates to:
  /// **'Donation approved! QR code generated.'**
  String get donationApprovedQr;

  /// No description provided for @donationRejectedMsg.
  ///
  /// In en, this message translates to:
  /// **'Donation rejected.'**
  String get donationRejectedMsg;

  /// No description provided for @boxImageLabel.
  ///
  /// In en, this message translates to:
  /// **'Box Image'**
  String get boxImageLabel;

  /// No description provided for @rejectReasonDamaged.
  ///
  /// In en, this message translates to:
  /// **'Medicine box is visibly damaged'**
  String get rejectReasonDamaged;

  /// No description provided for @rejectReasonExpired.
  ///
  /// In en, this message translates to:
  /// **'Medicine is expired or nearing expiry'**
  String get rejectReasonExpired;

  /// No description provided for @rejectReasonUnreadable.
  ///
  /// In en, this message translates to:
  /// **'Information on box is unreadable'**
  String get rejectReasonUnreadable;

  /// No description provided for @rejectReasonRecalled.
  ///
  /// In en, this message translates to:
  /// **'Medicine batch is recalled'**
  String get rejectReasonRecalled;

  /// No description provided for @rejectReasonOther.
  ///
  /// In en, this message translates to:
  /// **'Other reason'**
  String get rejectReasonOther;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}m ago'**
  String minutesAgo(int count);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String hoursAgo(int count);

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String daysAgo(int count);

  /// No description provided for @recentDonations.
  ///
  /// In en, this message translates to:
  /// **'Recent Donations'**
  String get recentDonations;

  /// No description provided for @recentRequests.
  ///
  /// In en, this message translates to:
  /// **'Recent Requests'**
  String get recentRequests;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon!'**
  String get comingSoon;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
