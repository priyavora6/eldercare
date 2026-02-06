import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
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
    Locale('bn'),
    Locale('en'),
    Locale('gu'),
    Locale('hi'),
    Locale('kn'),
    Locale('ml'),
    Locale('mr'),
    Locale('pa'),
    Locale('ta'),
    Locale('te'),
  ];

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @loginToYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Login to your account'**
  String get loginToYourAccount;

  /// No description provided for @emailOrPhone.
  ///
  /// In en, this message translates to:
  /// **'Email or Phone'**
  String get emailOrPhone;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember Me'**
  String get rememberMe;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @loginWithFingerprint.
  ///
  /// In en, this message translates to:
  /// **'Login with Fingerprint'**
  String get loginWithFingerprint;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @pleaseEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter email or phone'**
  String get pleaseEnterEmail;

  /// No description provided for @pleaseEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter password'**
  String get pleaseEnterPassword;

  /// No description provided for @loginSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Login Successful!'**
  String get loginSuccessful;

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'User not found'**
  String get userNotFound;

  /// No description provided for @wrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Wrong password'**
  String get wrongPassword;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get loginFailed;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @sosButton.
  ///
  /// In en, this message translates to:
  /// **'SOS'**
  String get sosButton;

  /// No description provided for @callFamily.
  ///
  /// In en, this message translates to:
  /// **'Call Family'**
  String get callFamily;

  /// No description provided for @healthCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Health Check-in'**
  String get healthCheckIn;

  /// No description provided for @aiCompanion.
  ///
  /// In en, this message translates to:
  /// **'AI Companion'**
  String get aiCompanion;

  /// No description provided for @medicineReminder.
  ///
  /// In en, this message translates to:
  /// **'Medicine Reminder'**
  String get medicineReminder;

  /// No description provided for @emergencyContacts.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contacts'**
  String get emergencyContacts;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @helloPriya.
  ///
  /// In en, this message translates to:
  /// **'Hello, Priya'**
  String get helloPriya;

  /// No description provided for @howAreYouFeelingToday.
  ///
  /// In en, this message translates to:
  /// **'How are you feeling today?'**
  String get howAreYouFeelingToday;

  /// No description provided for @emergencySos.
  ///
  /// In en, this message translates to:
  /// **'EMERGENCY SOS'**
  String get emergencySos;

  /// No description provided for @activityLog.
  ///
  /// In en, this message translates to:
  /// **'Activity Log'**
  String get activityLog;

  /// No description provided for @todaysSummary.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Summary'**
  String get todaysSummary;

  /// No description provided for @medicines.
  ///
  /// In en, this message translates to:
  /// **'Medicines'**
  String get medicines;

  /// No description provided for @steps.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get steps;

  /// No description provided for @sleep.
  ///
  /// In en, this message translates to:
  /// **'Sleep'**
  String get sleep;

  /// No description provided for @contacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get contacts;

  /// No description provided for @familyView.
  ///
  /// In en, this message translates to:
  /// **'Family View'**
  String get familyView;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @noNewNotifications.
  ///
  /// In en, this message translates to:
  /// **'No new notifications.'**
  String get noNewNotifications;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'CLOSE'**
  String get close;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'CANCEL'**
  String get cancel;

  /// No description provided for @callNow.
  ///
  /// In en, this message translates to:
  /// **'CALL NOW'**
  String get callNow;

  /// No description provided for @emergencySosDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Emergency SOS'**
  String get emergencySosDialogTitle;

  /// No description provided for @emergencySosDialogContent.
  ///
  /// In en, this message translates to:
  /// **'This will call 911 and alert your family. Are you sure?'**
  String get emergencySosDialogContent;

  /// No description provided for @medicine.
  ///
  /// In en, this message translates to:
  /// **'Medicine'**
  String get medicine;

  /// No description provided for @aiChat.
  ///
  /// In en, this message translates to:
  /// **'AI Chat'**
  String get aiChat;

  /// No description provided for @tookMedicine.
  ///
  /// In en, this message translates to:
  /// **'Took Medicine'**
  String get tookMedicine;

  /// No description provided for @aspirin100mg.
  ///
  /// In en, this message translates to:
  /// **'Aspirin 100mg'**
  String get aspirin100mg;

  /// No description provided for @morningWalk.
  ///
  /// In en, this message translates to:
  /// **'Morning Walk'**
  String get morningWalk;

  /// No description provided for @feelingGreat.
  ///
  /// In en, this message translates to:
  /// **'Feeling great'**
  String get feelingGreat;

  /// No description provided for @metformin500mg.
  ///
  /// In en, this message translates to:
  /// **'Metformin 500mg'**
  String get metformin500mg;

  /// No description provided for @aiCompanionChat.
  ///
  /// In en, this message translates to:
  /// **'AI Companion Chat'**
  String get aiCompanionChat;

  /// No description provided for @listenedToMusic.
  ///
  /// In en, this message translates to:
  /// **'Listened to music'**
  String get listenedToMusic;

  /// No description provided for @lunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get lunch;

  /// No description provided for @ateAHealthyMeal.
  ///
  /// In en, this message translates to:
  /// **'Ate a healthy meal'**
  String get ateAHealthyMeal;

  /// No description provided for @videoCallWithFamily.
  ///
  /// In en, this message translates to:
  /// **'Video Call with Family'**
  String get videoCallWithFamily;

  /// No description provided for @talkedFor30Minutes.
  ///
  /// In en, this message translates to:
  /// **'Talked for 30 minutes'**
  String get talkedFor30Minutes;

  /// No description provided for @viewingActivitiesFor.
  ///
  /// In en, this message translates to:
  /// **'Viewing activities for {date}'**
  String viewingActivitiesFor(Object date);

  /// No description provided for @playMusic.
  ///
  /// In en, this message translates to:
  /// **'Play Music'**
  String get playMusic;

  /// No description provided for @tellStory.
  ///
  /// In en, this message translates to:
  /// **'Tell Story'**
  String get tellStory;

  /// No description provided for @readNews.
  ///
  /// In en, this message translates to:
  /// **'Read News'**
  String get readNews;

  /// No description provided for @memoryGame.
  ///
  /// In en, this message translates to:
  /// **'Memory Game'**
  String get memoryGame;

  /// No description provided for @typeYourMessage.
  ///
  /// In en, this message translates to:
  /// **'Type your message...'**
  String get typeYourMessage;

  /// No description provided for @listening.
  ///
  /// In en, this message translates to:
  /// **'Listening... Speak now'**
  String get listening;

  /// No description provided for @helloImYourAICompanion.
  ///
  /// In en, this message translates to:
  /// **'Hello! I\'m your AI companion. How can I help you today?'**
  String get helloImYourAICompanion;

  /// No description provided for @playSomeRelaxingMusic.
  ///
  /// In en, this message translates to:
  /// **'Play some relaxing music for me'**
  String get playSomeRelaxingMusic;

  /// No description provided for @tellMeAnInterestingStory.
  ///
  /// In en, this message translates to:
  /// **'Tell me an interesting story'**
  String get tellMeAnInterestingStory;

  /// No description provided for @whatsInTheNewsToday.
  ///
  /// In en, this message translates to:
  /// **'What\'s in the news today?'**
  String get whatsInTheNewsToday;

  /// No description provided for @letsPlayAMemoryGame.
  ///
  /// In en, this message translates to:
  /// **'Let\'s play a memory game'**
  String get letsPlayAMemoryGame;

  /// No description provided for @thisIsAVoiceMessage.
  ///
  /// In en, this message translates to:
  /// **'This is a voice message (simulated)'**
  String get thisIsAVoiceMessage;

  /// No description provided for @contextualResponseMusic.
  ///
  /// In en, this message translates to:
  /// **'🎵 Playing relaxing classical music for you. Would you like me to play something specific?'**
  String get contextualResponseMusic;

  /// No description provided for @contextualResponseStory.
  ///
  /// In en, this message translates to:
  /// **'📖 Once upon a time, there was a wise elder who loved to share stories with the younger generation. Would you like to hear a specific type of story?'**
  String get contextualResponseStory;

  /// No description provided for @contextualResponseNews.
  ///
  /// In en, this message translates to:
  /// **'📰 Here are today\'s top headlines:\n\n• Weather: Sunny, 72°F\n• Local Event: Community gathering at park\n• Health Tip: Remember to drink water!\n\nWould you like more details?'**
  String get contextualResponseNews;

  /// No description provided for @contextualResponseGame.
  ///
  /// In en, this message translates to:
  /// **'🎮 Let\'s play a memory game! I\'ll say 3 words, try to remember them:\n\nApple, Tree, Blue\n\nCan you repeat them back?'**
  String get contextualResponseGame;

  /// No description provided for @contextualResponseHelp.
  ///
  /// In en, this message translates to:
  /// **'I can help you with:\n• Playing music\n• Telling stories\n• Reading news\n• Playing memory games\n• Chatting anytime!\n\nWhat would you like?'**
  String get contextualResponseHelp;

  /// No description provided for @contextualResponseMedicine.
  ///
  /// In en, this message translates to:
  /// **'💊 I can remind you about your medicines. Would you like to check your medicine schedule?'**
  String get contextualResponseMedicine;

  /// No description provided for @contextualResponseFamily.
  ///
  /// In en, this message translates to:
  /// **'📞 Would you like me to help you call a family member? I can connect you quickly!'**
  String get contextualResponseFamily;

  /// No description provided for @contextualResponseDefault1.
  ///
  /// In en, this message translates to:
  /// **'That\'s interesting! Tell me more.'**
  String get contextualResponseDefault1;

  /// No description provided for @contextualResponseDefault2.
  ///
  /// In en, this message translates to:
  /// **'I understand. How can I help you with that?'**
  String get contextualResponseDefault2;

  /// No description provided for @contextualResponseDefault3.
  ///
  /// In en, this message translates to:
  /// **'I\'m here to listen. What else would you like to talk about?'**
  String get contextualResponseDefault3;

  /// No description provided for @contextualResponseDefault4.
  ///
  /// In en, this message translates to:
  /// **'That sounds nice! Anything else on your mind?'**
  String get contextualResponseDefault4;

  /// No description provided for @addContact.
  ///
  /// In en, this message translates to:
  /// **'Add Contact'**
  String get addContact;

  /// No description provided for @primary.
  ///
  /// In en, this message translates to:
  /// **'PRIMARY'**
  String get primary;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @couldNotOpenPhoneDialer.
  ///
  /// In en, this message translates to:
  /// **'Could not open phone dialer'**
  String get couldNotOpenPhoneDialer;

  /// No description provided for @addEmergencyContact.
  ///
  /// In en, this message translates to:
  /// **'Add Emergency Contact'**
  String get addEmergencyContact;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @relationship.
  ///
  /// In en, this message translates to:
  /// **'Relationship'**
  String get relationship;

  /// No description provided for @family.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get family;

  /// No description provided for @doctor.
  ///
  /// In en, this message translates to:
  /// **'Doctor'**
  String get doctor;

  /// No description provided for @neighbor.
  ///
  /// In en, this message translates to:
  /// **'Neighbor'**
  String get neighbor;

  /// No description provided for @friend.
  ///
  /// In en, this message translates to:
  /// **'Friend'**
  String get friend;

  /// No description provided for @emergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get emergency;

  /// No description provided for @contactAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Contact added successfully!'**
  String get contactAddedSuccessfully;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'ADD'**
  String get add;

  /// No description provided for @editContact.
  ///
  /// In en, this message translates to:
  /// **'Edit Contact'**
  String get editContact;

  /// No description provided for @contactDeleted.
  ///
  /// In en, this message translates to:
  /// **'Contact deleted'**
  String get contactDeleted;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'DELETE'**
  String get delete;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'SAVE'**
  String get save;

  /// No description provided for @contactUpdated.
  ///
  /// In en, this message translates to:
  /// **'Contact updated!'**
  String get contactUpdated;

  /// No description provided for @selectYourMood.
  ///
  /// In en, this message translates to:
  /// **'Select your mood below'**
  String get selectYourMood;

  /// No description provided for @yourMood.
  ///
  /// In en, this message translates to:
  /// **'Your Mood'**
  String get yourMood;

  /// No description provided for @great.
  ///
  /// In en, this message translates to:
  /// **'Great'**
  String get great;

  /// No description provided for @good.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get good;

  /// No description provided for @okay.
  ///
  /// In en, this message translates to:
  /// **'Okay'**
  String get okay;

  /// No description provided for @sad.
  ///
  /// In en, this message translates to:
  /// **'Sad'**
  String get sad;

  /// No description provided for @unwell.
  ///
  /// In en, this message translates to:
  /// **'Unwell'**
  String get unwell;

  /// No description provided for @voiceCheck.
  ///
  /// In en, this message translates to:
  /// **'Voice Check'**
  String get voiceCheck;

  /// No description provided for @recordYourVoice.
  ///
  /// In en, this message translates to:
  /// **'Record your voice to check for speech patterns'**
  String get recordYourVoice;

  /// No description provided for @recording.
  ///
  /// In en, this message translates to:
  /// **'Recording...'**
  String get recording;

  /// No description provided for @tapToRecord.
  ///
  /// In en, this message translates to:
  /// **'Tap to record'**
  String get tapToRecord;

  /// No description provided for @speakClearly.
  ///
  /// In en, this message translates to:
  /// **'Speak clearly'**
  String get speakClearly;

  /// No description provided for @iAmFeelingGoodToday.
  ///
  /// In en, this message translates to:
  /// **'Say: \"I am feeling good today\"'**
  String get iAmFeelingGoodToday;

  /// No description provided for @submitCheckIn.
  ///
  /// In en, this message translates to:
  /// **'SUBMIT CHECK-IN'**
  String get submitCheckIn;

  /// No description provided for @recordingYourVoice.
  ///
  /// In en, this message translates to:
  /// **'Recording your voice...'**
  String get recordingYourVoice;

  /// No description provided for @voiceRecordingSaved.
  ///
  /// In en, this message translates to:
  /// **'Voice recording saved'**
  String get voiceRecordingSaved;

  /// No description provided for @checkInComplete.
  ///
  /// In en, this message translates to:
  /// **'Check-in Complete'**
  String get checkInComplete;

  /// No description provided for @yourHealthCheckInHasBeenRecorded.
  ///
  /// In en, this message translates to:
  /// **'Your health check-in has been recorded!'**
  String get yourHealthCheckInHasBeenRecorded;

  /// No description provided for @mood.
  ///
  /// In en, this message translates to:
  /// **'Mood: {mood}'**
  String mood(Object mood);

  /// No description provided for @yourFamilyHasBeenNotified.
  ///
  /// In en, this message translates to:
  /// **'Your family has been notified.'**
  String get yourFamilyHasBeenNotified;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'DONE'**
  String get done;

  /// No description provided for @medicineTracker.
  ///
  /// In en, this message translates to:
  /// **'Medicine Tracker'**
  String get medicineTracker;

  /// No description provided for @todaysSchedule.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Schedule'**
  String get todaysSchedule;

  /// No description provided for @adherenceRate.
  ///
  /// In en, this message translates to:
  /// **'Adherence Rate'**
  String get adherenceRate;

  /// No description provided for @taken.
  ///
  /// In en, this message translates to:
  /// **'Taken'**
  String get taken;

  /// No description provided for @missed.
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get missed;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @take.
  ///
  /// In en, this message translates to:
  /// **'Take'**
  String get take;

  /// No description provided for @scanPrescription.
  ///
  /// In en, this message translates to:
  /// **'Scan Prescription'**
  String get scanPrescription;

  /// No description provided for @scanPrescriptionHelperText.
  ///
  /// In en, this message translates to:
  /// **'Take a clear photo of your prescription. The app will automatically extract medicine details.'**
  String get scanPrescriptionHelperText;

  /// No description provided for @scanNow.
  ///
  /// In en, this message translates to:
  /// **'SCAN NOW'**
  String get scanNow;

  /// No description provided for @cameraPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Camera permission required'**
  String get cameraPermissionRequired;

  /// No description provided for @prescriptionScannedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Prescription scanned successfully!'**
  String get prescriptionScannedSuccessfully;

  /// No description provided for @addMedicine.
  ///
  /// In en, this message translates to:
  /// **'Add Medicine'**
  String get addMedicine;

  /// No description provided for @medicineName.
  ///
  /// In en, this message translates to:
  /// **'Medicine Name'**
  String get medicineName;

  /// No description provided for @dosage.
  ///
  /// In en, this message translates to:
  /// **'Dosage (e.g., 100mg)'**
  String get dosage;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time (e.g., 08:00 AM)'**
  String get time;

  /// No description provided for @medicineAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Medicine added successfully!'**
  String get medicineAddedSuccessfully;

  /// No description provided for @medicineHistory.
  ///
  /// In en, this message translates to:
  /// **'Medicine History'**
  String get medicineHistory;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String daysAgo(Object count);

  /// No description provided for @medicinesTaken.
  ///
  /// In en, this message translates to:
  /// **'{count} of {total} medicines taken'**
  String medicinesTaken(Object count, Object total);

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @signUpToGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Sign up to get started'**
  String get signUpToGetStarted;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @enterYourFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterYourFullName;

  /// No description provided for @pleaseEnterYourName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get pleaseEnterYourName;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmail;

  /// No description provided for @pleaseEnterAValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get pleaseEnterAValidEmail;

  /// No description provided for @enterYourPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get enterYourPhoneNumber;

  /// No description provided for @pleaseEnterYourPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get pleaseEnterYourPhoneNumber;

  /// No description provided for @pleaseEnterAValidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get pleaseEnterAValidPhoneNumber;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @selectDateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Select date of birth'**
  String get selectDateOfBirth;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter password'**
  String get enterPassword;

  /// No description provided for @passwordMustBeAtLeast6Characters.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMustBeAtLeast6Characters;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @reEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Re-enter password'**
  String get reEnterPassword;

  /// No description provided for @pleaseConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Please confirm password'**
  String get pleaseConfirmPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @iAcceptTheTerms.
  ///
  /// In en, this message translates to:
  /// **'I accept the Terms & Conditions and Privacy Policy'**
  String get iAcceptTheTerms;

  /// No description provided for @createAccountButton.
  ///
  /// In en, this message translates to:
  /// **'CREATE ACCOUNT'**
  String get createAccountButton;

  /// No description provided for @accountCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Account Created Successfully!'**
  String get accountCreatedSuccessfully;

  /// No description provided for @pleaseAcceptTerms.
  ///
  /// In en, this message translates to:
  /// **'Please accept terms & conditions'**
  String get pleaseAcceptTerms;

  /// No description provided for @alreadyHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAnAccount;
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
    'bn',
    'en',
    'gu',
    'hi',
    'kn',
    'ml',
    'mr',
    'pa',
    'ta',
    'te',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
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
    'that was used.',
  );
}
