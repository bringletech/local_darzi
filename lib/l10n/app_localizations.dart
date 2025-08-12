import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_ml.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_pa.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';

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
    Locale('en'),
    Locale('gu'),
    Locale('hi'),
    Locale('kn'),
    Locale('ml'),
    Locale('mr'),
    Locale('pa'),
    Locale('ta'),
    Locale('te')
  ];

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login or Signup'**
  String get login;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @invalidNumber.
  ///
  /// In en, this message translates to:
  /// **'Invalid Mobile Number'**
  String get invalidNumber;

  /// No description provided for @agreeContinue.
  ///
  /// In en, this message translates to:
  /// **'I Agree & Continue '**
  String get agreeContinue;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get and;

  /// No description provided for @warningContinueMessage.
  ///
  /// In en, this message translates to:
  /// **'Please select I Agree & Continue'**
  String get warningContinueMessage;

  /// No description provided for @otpVerify.
  ///
  /// In en, this message translates to:
  /// **'OTP Verification'**
  String get otpVerify;

  /// No description provided for @otpSentMessage.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a 6-digit code to'**
  String get otpSentMessage;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @receiveCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive any code?'**
  String get receiveCode;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @editPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Edit Phone Number'**
  String get editPhoneNumber;

  /// No description provided for @enterNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter Your phone Number'**
  String get enterNumber;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @buttonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get buttonContinue;

  /// No description provided for @warningMessage.
  ///
  /// In en, this message translates to:
  /// **'Please enter a 6-digit OTP.'**
  String get warningMessage;

  /// No description provided for @appHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get appHome;

  /// No description provided for @addCustomer.
  ///
  /// In en, this message translates to:
  /// **'Add New Customer'**
  String get addCustomer;

  /// No description provided for @activeDresses.
  ///
  /// In en, this message translates to:
  /// **'Active Dresses'**
  String get activeDresses;

  /// No description provided for @dressDetails.
  ///
  /// In en, this message translates to:
  /// **'Dress Details'**
  String get dressDetails;

  /// No description provided for @totalCustomers.
  ///
  /// In en, this message translates to:
  /// **'Total Customers: {count}'**
  String totalCustomers(Object count);

  /// No description provided for @totalOrders.
  ///
  /// In en, this message translates to:
  /// **'Total Orders: {count}'**
  String totalOrders(Object count);

  /// No description provided for @yourAccount.
  ///
  /// In en, this message translates to:
  /// **'Your Account'**
  String get yourAccount;

  /// No description provided for @userName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get userName;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Enter Name'**
  String get enterName;

  /// No description provided for @noUserName.
  ///
  /// In en, this message translates to:
  /// **'No Name'**
  String get noUserName;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile No.'**
  String get mobileNumber;

  /// No description provided for @noMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'No Mobile No.'**
  String get noMobileNumber;

  /// No description provided for @enterMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter Mobile No.'**
  String get enterMobileNumber;

  /// No description provided for @userAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get userAddress;

  /// No description provided for @userNoAddress.
  ///
  /// In en, this message translates to:
  /// **'No Address'**
  String get userNoAddress;

  /// No description provided for @saveDetails.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveDetails;

  /// No description provided for @saveDetails1.
  ///
  /// In en, this message translates to:
  /// **'Save Details'**
  String get saveDetails1;

  /// No description provided for @userLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get userLogout;

  /// No description provided for @recentData.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get recentData;

  /// No description provided for @dressStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get dressStatus;

  /// No description provided for @validationMessage.
  ///
  /// In en, this message translates to:
  /// **'Please fill all the details and add a dress image.'**
  String get validationMessage;

  /// No description provided for @cost.
  ///
  /// In en, this message translates to:
  /// **'Cost'**
  String get cost;

  /// No description provided for @dueDate.
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get dueDate;

  /// No description provided for @noDateSelected.
  ///
  /// In en, this message translates to:
  /// **'No date selected!'**
  String get noDateSelected;

  /// No description provided for @howToMeasure.
  ///
  /// In en, this message translates to:
  /// **'How To Measure?'**
  String get howToMeasure;

  /// No description provided for @cmMeasurement.
  ///
  /// In en, this message translates to:
  /// **'Cm'**
  String get cmMeasurement;

  /// No description provided for @inchMeasurement.
  ///
  /// In en, this message translates to:
  /// **'Inch'**
  String get inchMeasurement;

  /// No description provided for @neck.
  ///
  /// In en, this message translates to:
  /// **'Neck'**
  String get neck;

  /// No description provided for @bust.
  ///
  /// In en, this message translates to:
  /// **'Bust'**
  String get bust;

  /// No description provided for @underBust.
  ///
  /// In en, this message translates to:
  /// **'Under\nBust'**
  String get underBust;

  /// No description provided for @waist.
  ///
  /// In en, this message translates to:
  /// **'Waist'**
  String get waist;

  /// No description provided for @hips.
  ///
  /// In en, this message translates to:
  /// **'Hips'**
  String get hips;

  /// No description provided for @neckAbove.
  ///
  /// In en, this message translates to:
  /// **'Neck to above\nknee'**
  String get neckAbove;

  /// No description provided for @armLength.
  ///
  /// In en, this message translates to:
  /// **'Arm Length'**
  String get armLength;

  /// No description provided for @shoulderSeam.
  ///
  /// In en, this message translates to:
  /// **'Shoulder\nSeam'**
  String get shoulderSeam;

  /// No description provided for @armHole.
  ///
  /// In en, this message translates to:
  /// **'Arm Hole'**
  String get armHole;

  /// No description provided for @bicep.
  ///
  /// In en, this message translates to:
  /// **'Bicep'**
  String get bicep;

  /// No description provided for @foreArm.
  ///
  /// In en, this message translates to:
  /// **'Fore Arm'**
  String get foreArm;

  /// No description provided for @wrist.
  ///
  /// In en, this message translates to:
  /// **'Wrist'**
  String get wrist;

  /// No description provided for @shoulderWaist.
  ///
  /// In en, this message translates to:
  /// **'Shoulder\nto waist'**
  String get shoulderWaist;

  /// No description provided for @bottomLength.
  ///
  /// In en, this message translates to:
  /// **'Bottom\nLength'**
  String get bottomLength;

  /// No description provided for @ankle.
  ///
  /// In en, this message translates to:
  /// **'Ankle'**
  String get ankle;

  /// No description provided for @stitchingCost.
  ///
  /// In en, this message translates to:
  /// **'Stitching\nCost'**
  String get stitchingCost;

  /// No description provided for @stitchingCost1.
  ///
  /// In en, this message translates to:
  /// **'Stitching Cost'**
  String get stitchingCost1;

  /// No description provided for @outstandingBalance.
  ///
  /// In en, this message translates to:
  /// **'Outstanding\nBalance'**
  String get outstandingBalance;

  /// No description provided for @outstandingBalance1.
  ///
  /// In en, this message translates to:
  /// **'Outstanding Balance'**
  String get outstandingBalance1;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @textHere.
  ///
  /// In en, this message translates to:
  /// **'Text Here'**
  String get textHere;

  /// No description provided for @order_Received.
  ///
  /// In en, this message translates to:
  /// **'Order is Received'**
  String get order_Received;

  /// No description provided for @order_cancelled.
  ///
  /// In en, this message translates to:
  /// **'Order is Cancelled'**
  String get order_cancelled;

  /// No description provided for @dressComplete.
  ///
  /// In en, this message translates to:
  /// **'Order is Completed'**
  String get dressComplete;

  /// No description provided for @dressProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get dressProgress;

  /// No description provided for @dressIsComplete.
  ///
  /// In en, this message translates to:
  /// **'Dress Complete'**
  String get dressIsComplete;

  /// No description provided for @dressName.
  ///
  /// In en, this message translates to:
  /// **'Dress Name'**
  String get dressName;

  /// No description provided for @noDressName.
  ///
  /// In en, this message translates to:
  /// **'No Dress Name'**
  String get noDressName;

  /// No description provided for @enterDressName.
  ///
  /// In en, this message translates to:
  /// **'Enter Dress Name'**
  String get enterDressName;

  /// No description provided for @dressPhoto.
  ///
  /// In en, this message translates to:
  /// **'Dress Photo'**
  String get dressPhoto;

  /// No description provided for @addImage.
  ///
  /// In en, this message translates to:
  /// **'Add Image'**
  String get addImage;

  /// No description provided for @advancedCost.
  ///
  /// In en, this message translates to:
  /// **'Advance Cost'**
  String get advancedCost;

  /// No description provided for @remainingBalance.
  ///
  /// In en, this message translates to:
  /// **'Remaining Cost'**
  String get remainingBalance;

  /// No description provided for @logOutConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Logout Confirmation'**
  String get logOutConfirmation;

  /// No description provided for @logOutConfirmationMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure, do you want to logout?'**
  String get logOutConfirmationMessage;

  /// No description provided for @yesMessage.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yesMessage;

  /// No description provided for @appCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get appCamera;

  /// No description provided for @appGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get appGallery;

  /// No description provided for @cropImage.
  ///
  /// In en, this message translates to:
  /// **'Crop Photo'**
  String get cropImage;

  /// No description provided for @newCustomer.
  ///
  /// In en, this message translates to:
  /// **'Add Customer'**
  String get newCustomer;

  /// No description provided for @searchCustomer.
  ///
  /// In en, this message translates to:
  /// **'Search Your Customer'**
  String get searchCustomer;

  /// No description provided for @mobileOrName.
  ///
  /// In en, this message translates to:
  /// **'Enter Mobile No. or Name.....'**
  String get mobileOrName;

  /// No description provided for @measurements.
  ///
  /// In en, this message translates to:
  /// **'Measurements'**
  String get measurements;

  /// No description provided for @dresses.
  ///
  /// In en, this message translates to:
  /// **'Dresses'**
  String get dresses;

  /// No description provided for @addNewDress.
  ///
  /// In en, this message translates to:
  /// **'Add New Dress'**
  String get addNewDress;

  /// No description provided for @warningMessage1.
  ///
  /// In en, this message translates to:
  /// **'Please fill all details'**
  String get warningMessage1;

  /// No description provided for @myTailor.
  ///
  /// In en, this message translates to:
  /// **'My Tailor'**
  String get myTailor;

  /// No description provided for @myDresses.
  ///
  /// In en, this message translates to:
  /// **'My Dresses'**
  String get myDresses;

  /// No description provided for @tailorDetail.
  ///
  /// In en, this message translates to:
  /// **'Tailor Details'**
  String get tailorDetail;

  /// No description provided for @searchTailor.
  ///
  /// In en, this message translates to:
  /// **' Search Your Tailor'**
  String get searchTailor;

  /// No description provided for @camera_permission_message.
  ///
  /// In en, this message translates to:
  /// **'This app needs camera and gallery access to capture photos. Please enable camera permissions in settings.'**
  String get camera_permission_message;

  /// No description provided for @permission_granted.
  ///
  /// In en, this message translates to:
  /// **'Camera and Gallery permission granted.'**
  String get permission_granted;

  /// No description provided for @permission_denied.
  ///
  /// In en, this message translates to:
  /// **'Camera and Gallery permission denied.'**
  String get permission_denied;

  /// No description provided for @application_notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get application_notifications;

  /// No description provided for @newOrder.
  ///
  /// In en, this message translates to:
  /// **'New Orders:'**
  String get newOrder;

  /// No description provided for @appointment_reminder.
  ///
  /// In en, this message translates to:
  /// **'Appointment Reminders:'**
  String get appointment_reminder;

  /// No description provided for @newOrdersDetails.
  ///
  /// In en, this message translates to:
  /// **'Notifications related to incoming tailoring requests'**
  String get newOrdersDetails;

  /// No description provided for @appointmentReminderDetails.
  ///
  /// In en, this message translates to:
  /// **'Reminders for upcoming appointments or deadlines.'**
  String get appointmentReminderDetails;

  /// No description provided for @remove_customer.
  ///
  /// In en, this message translates to:
  /// **'Remove Customer'**
  String get remove_customer;

  /// No description provided for @confirm_remove_customer.
  ///
  /// In en, this message translates to:
  /// **'Confirm Remove'**
  String get confirm_remove_customer;

  /// No description provided for @confirm_remove_customer_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure, Do you want to remove this customer from the customer list along with all their orders?'**
  String get confirm_remove_customer_message;

  /// No description provided for @language_selection_first.
  ///
  /// In en, this message translates to:
  /// **'Please select a language first!'**
  String get language_selection_first;

  /// No description provided for @add_warning_message.
  ///
  /// In en, this message translates to:
  /// **'Please fill all the required fields.'**
  String get add_warning_message;

  /// No description provided for @add_warning_message1.
  ///
  /// In en, this message translates to:
  /// **'Please fill stitching cost.'**
  String get add_warning_message1;

  /// No description provided for @unsaved_changes.
  ///
  /// In en, this message translates to:
  /// **'Unsaved changes'**
  String get unsaved_changes;

  /// No description provided for @unsaved_changes_warningMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to leave? If you leave then your current information will be removed.'**
  String get unsaved_changes_warningMessage;

  /// No description provided for @payment_information.
  ///
  /// In en, this message translates to:
  /// **'Payment Information'**
  String get payment_information;

  /// No description provided for @payment_Date.
  ///
  /// In en, this message translates to:
  /// **'Payment Date'**
  String get payment_Date;

  /// No description provided for @amount_Received.
  ///
  /// In en, this message translates to:
  /// **'Amount Received'**
  String get amount_Received;

  /// No description provided for @payment_Received.
  ///
  /// In en, this message translates to:
  /// **'Receive Payment'**
  String get payment_Received;

  /// No description provided for @advance_Payment.
  ///
  /// In en, this message translates to:
  /// **'Advance Payment'**
  String get advance_Payment;

  /// No description provided for @pending_Payment.
  ///
  /// In en, this message translates to:
  /// **'Pending Payment'**
  String get pending_Payment;

  /// No description provided for @on_Going_Orders.
  ///
  /// In en, this message translates to:
  /// **'On Going Orders'**
  String get on_Going_Orders;

  /// No description provided for @complete_Orders.
  ///
  /// In en, this message translates to:
  /// **'Completed Orders'**
  String get complete_Orders;

  /// No description provided for @total_Orders.
  ///
  /// In en, this message translates to:
  /// **'Total Orders'**
  String get total_Orders;

  /// No description provided for @no_customer_found.
  ///
  /// In en, this message translates to:
  /// **'No customers found.'**
  String get no_customer_found;

  /// No description provided for @no_tailor_found.
  ///
  /// In en, this message translates to:
  /// **'No Tailor Found'**
  String get no_tailor_found;

  /// No description provided for @ph_no.
  ///
  /// In en, this message translates to:
  /// **'Ph. No:'**
  String get ph_no;

  /// No description provided for @start_Work.
  ///
  /// In en, this message translates to:
  /// **'Start Work'**
  String get start_Work;

  /// No description provided for @cancel_Work.
  ///
  /// In en, this message translates to:
  /// **'Cancel Work'**
  String get cancel_Work;

  /// No description provided for @payment_done.
  ///
  /// In en, this message translates to:
  /// **'Payment is Done'**
  String get payment_done;

  /// No description provided for @cancel_order_warning.
  ///
  /// In en, this message translates to:
  /// **'Cancel Order Warning'**
  String get cancel_order_warning;

  /// No description provided for @subTitle_of_cancel_order_warning.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to Cancel the Order?'**
  String get subTitle_of_cancel_order_warning;

  /// No description provided for @recent_Reviews.
  ///
  /// In en, this message translates to:
  /// **'Recent Reviews'**
  String get recent_Reviews;

  /// No description provided for @no_dresses_found.
  ///
  /// In en, this message translates to:
  /// **'No dresses found'**
  String get no_dresses_found;

  /// No description provided for @tailor_call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get tailor_call;

  /// No description provided for @tailor_location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get tailor_location;

  /// No description provided for @tailor_whatsapp.
  ///
  /// In en, this message translates to:
  /// **'Whatsapp'**
  String get tailor_whatsapp;

  /// No description provided for @write_review.
  ///
  /// In en, this message translates to:
  /// **'Write a Review'**
  String get write_review;

  /// No description provided for @add_to_favourite.
  ///
  /// In en, this message translates to:
  /// **'Add to Favourite'**
  String get add_to_favourite;

  /// No description provided for @excellent_review.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get excellent_review;

  /// No description provided for @good_review.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get good_review;

  /// No description provided for @average_review.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get average_review;

  /// No description provided for @below_average_review.
  ///
  /// In en, this message translates to:
  /// **'Below Average'**
  String get below_average_review;

  /// No description provided for @poor_review.
  ///
  /// In en, this message translates to:
  /// **'Poor'**
  String get poor_review;

  /// No description provided for @submit_review.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit_review;

  /// No description provided for @upload_image.
  ///
  /// In en, this message translates to:
  /// **'Upload Max 3 Images'**
  String get upload_image;

  /// No description provided for @write_review_text.
  ///
  /// In en, this message translates to:
  /// **'Please Write Your Review Here (optional)'**
  String get write_review_text;

  /// No description provided for @my_favourites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get my_favourites;

  /// No description provided for @report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @state.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get state;

  /// No description provided for @code.
  ///
  /// In en, this message translates to:
  /// **'Postal Code'**
  String get code;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @street.
  ///
  /// In en, this message translates to:
  /// **'Street'**
  String get street;

  /// No description provided for @no_cancel_order.
  ///
  /// In en, this message translates to:
  /// **'No Cancelled orders available'**
  String get no_cancel_order;

  /// No description provided for @no_receive_order.
  ///
  /// In en, this message translates to:
  /// **'No Received Payment available'**
  String get no_receive_order;

  /// No description provided for @no_outstanding_data.
  ///
  /// In en, this message translates to:
  /// **'There is no outstanding balance found'**
  String get no_outstanding_data;

  /// No description provided for @payment_received.
  ///
  /// In en, this message translates to:
  /// **'Payment Received'**
  String get payment_received;

  /// No description provided for @cancel_order_title.
  ///
  /// In en, this message translates to:
  /// **'Cancel Order'**
  String get cancel_order_title;

  /// No description provided for @payment_received_details.
  ///
  /// In en, this message translates to:
  /// **'Payment Received Details'**
  String get payment_received_details;

  /// No description provided for @re_order.
  ///
  /// In en, this message translates to:
  /// **'Re-order'**
  String get re_order;

  /// No description provided for @cancel_order_details_title.
  ///
  /// In en, this message translates to:
  /// **'Cancel Order Details'**
  String get cancel_order_details_title;

  /// No description provided for @re_order_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to\nRe-order the Order?'**
  String get re_order_message;

  /// No description provided for @total_earning.
  ///
  /// In en, this message translates to:
  /// **'Total Earnings'**
  String get total_earning;

  /// No description provided for @order_received_title.
  ///
  /// In en, this message translates to:
  /// **'Order Received'**
  String get order_received_title;

  /// No description provided for @order_cancel_title.
  ///
  /// In en, this message translates to:
  /// **'Order Cancelled'**
  String get order_cancel_title;

  /// No description provided for @no_notification_message.
  ///
  /// In en, this message translates to:
  /// **'No new notifications'**
  String get no_notification_message;

  /// No description provided for @no_active_dress.
  ///
  /// In en, this message translates to:
  /// **'There is no active dress found'**
  String get no_active_dress;

  /// No description provided for @whatsapp_is_not_insatlled.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp is not Installed!'**
  String get whatsapp_is_not_insatlled;

  /// No description provided for @order_progress_title.
  ///
  /// In en, this message translates to:
  /// **'Order Progress'**
  String get order_progress_title;

  /// No description provided for @order_reopened_title.
  ///
  /// In en, this message translates to:
  /// **'Re-opened Order'**
  String get order_reopened_title;

  /// No description provided for @new_dress_order.
  ///
  /// In en, this message translates to:
  /// **'New Dress Order'**
  String get new_dress_order;

  /// No description provided for @cancelled_order_title.
  ///
  /// In en, this message translates to:
  /// **'Cancel Order'**
  String get cancelled_order_title;

  /// No description provided for @my_review.
  ///
  /// In en, this message translates to:
  /// **'My Review'**
  String get my_review;

  /// No description provided for @enterDueDate.
  ///
  /// In en, this message translates to:
  /// **'Please enter due date'**
  String get enterDueDate;

  /// No description provided for @enterStitchingCost.
  ///
  /// In en, this message translates to:
  /// **'Please enter stitching cost'**
  String get enterStitchingCost;

  /// No description provided for @enterAdvanceCost.
  ///
  /// In en, this message translates to:
  /// **'Please enter advance cost'**
  String get enterAdvanceCost;

  /// No description provided for @enterOutstandingBalance.
  ///
  /// In en, this message translates to:
  /// **'Please enter outstanding balance'**
  String get enterOutstandingBalance;

  /// No description provided for @selectImage.
  ///
  /// In en, this message translates to:
  /// **'Please select an image'**
  String get selectImage;

  /// No description provided for @cancel_reason.
  ///
  /// In en, this message translates to:
  /// **'Cancel Reason'**
  String get cancel_reason;

  /// No description provided for @estimated_earning.
  ///
  /// In en, this message translates to:
  /// **'Estimate Earnings'**
  String get estimated_earning;

  /// No description provided for @total_customer.
  ///
  /// In en, this message translates to:
  /// **'Total Customers'**
  String get total_customer;

  /// No description provided for @new_customer.
  ///
  /// In en, this message translates to:
  /// **'New Customers'**
  String get new_customer;

  /// No description provided for @no_cancel_reason.
  ///
  /// In en, this message translates to:
  /// **'No Cancel Reason Available'**
  String get no_cancel_reason;

  /// No description provided for @order_re_open.
  ///
  /// In en, this message translates to:
  /// **'Order is Reopened'**
  String get order_re_open;

  /// No description provided for @share_details.
  ///
  /// In en, this message translates to:
  /// **'Share Measurements'**
  String get share_details;

  /// No description provided for @noNotesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No Notes available'**
  String get noNotesAvailable;

  /// No description provided for @last_update.
  ///
  /// In en, this message translates to:
  /// **'Last Updated: '**
  String get last_update;

  /// No description provided for @payment_history.
  ///
  /// In en, this message translates to:
  /// **'Payment History'**
  String get payment_history;

  /// No description provided for @recent_payment.
  ///
  /// In en, this message translates to:
  /// **'Recent Payment'**
  String get recent_payment;

  /// No description provided for @previous_payment.
  ///
  /// In en, this message translates to:
  /// **'Previous Payments'**
  String get previous_payment;

  /// No description provided for @amount_paid.
  ///
  /// In en, this message translates to:
  /// **'Amount Paid'**
  String get amount_paid;

  /// No description provided for @payment_status.
  ///
  /// In en, this message translates to:
  /// **'Payment Status'**
  String get payment_status;

  /// No description provided for @no_payment_history_data_available.
  ///
  /// In en, this message translates to:
  /// **'No payment history data available'**
  String get no_payment_history_data_available;

  /// No description provided for @advance_payment.
  ///
  /// In en, this message translates to:
  /// **'Advance Payment'**
  String get advance_payment;

  /// No description provided for @show_payment_history.
  ///
  /// In en, this message translates to:
  /// **'Show Payment History'**
  String get show_payment_history;

  /// No description provided for @total_payment.
  ///
  /// In en, this message translates to:
  /// **'Total Payment'**
  String get total_payment;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @permission_required.
  ///
  /// In en, this message translates to:
  /// **'Permission Required'**
  String get permission_required;

  /// No description provided for @access_camera_permission.
  ///
  /// In en, this message translates to:
  /// **'Darzi needs access to your camera and gallery to let you upload images for your profile, dress orders, or reviews. Your images stay private, are never shared, and are only used inside the app. View our Privacy Policy for details.'**
  String get access_camera_permission;

  /// No description provided for @access_continue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get access_continue;

  /// No description provided for @enter_name.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Name'**
  String get enter_name;

  /// No description provided for @enter_name1.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Name First'**
  String get enter_name1;

  /// No description provided for @enter_name2.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Mobile No First'**
  String get enter_name2;

  /// No description provided for @delete_account.
  ///
  /// In en, this message translates to:
  /// **'Delete Your Account'**
  String get delete_account;

  /// No description provided for @contact_us.
  ///
  /// In en, this message translates to:
  /// **'Delete Now'**
  String get contact_us;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip For Now'**
  String get skip;

  /// No description provided for @not_registered.
  ///
  /// In en, this message translates to:
  /// **'Login Required'**
  String get not_registered;

  /// No description provided for @login_message.
  ///
  /// In en, this message translates to:
  /// **'You need to be registered to access this section. Please sign up or log in.'**
  String get login_message;

  /// No description provided for @tailor_account_deletion_title.
  ///
  /// In en, this message translates to:
  /// **'Confirm Account Deletion'**
  String get tailor_account_deletion_title;

  /// No description provided for @tailor_account_deletion_sub_title.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account?\nThis will permanently remove your orders, customers, payments, and all related data.\nThis action cannot be undone.'**
  String get tailor_account_deletion_sub_title;

  /// No description provided for @customer_account_deletion_sub_title.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account?\nThis will permanently remove your tailors, favourites, orders, and all related data.\nThis action cannot be undone.'**
  String get customer_account_deletion_sub_title;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get welcome;

  /// No description provided for @first_what_we_can_call_you.
  ///
  /// In en, this message translates to:
  /// **'First what we can call you?'**
  String get first_what_we_can_call_you;

  /// No description provided for @get_you_know_you.
  ///
  /// In en, this message translates to:
  /// **'We’d like to get you know you.'**
  String get get_you_know_you;

  /// No description provided for @hide_my_number.
  ///
  /// In en, this message translates to:
  /// **'Hide My Number'**
  String get hide_my_number;

  /// No description provided for @hide_your_number_from_customer.
  ///
  /// In en, this message translates to:
  /// **'(This will not hide your number from Customer you add.)'**
  String get hide_your_number_from_customer;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'en',
        'gu',
        'hi',
        'kn',
        'ml',
        'mr',
        'pa',
        'ta',
        'te'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'gu':
      return AppLocalizationsGu();
    case 'hi':
      return AppLocalizationsHi();
    case 'kn':
      return AppLocalizationsKn();
    case 'ml':
      return AppLocalizationsMl();
    case 'mr':
      return AppLocalizationsMr();
    case 'pa':
      return AppLocalizationsPa();
    case 'ta':
      return AppLocalizationsTa();
    case 'te':
      return AppLocalizationsTe();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
