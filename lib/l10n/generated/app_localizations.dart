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
/// import 'generated/app_localizations.dart';
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
  /// **'Amanos'**
  String get appTitle;

  /// No description provided for @userDirectory.
  ///
  /// In en, this message translates to:
  /// **'User directory'**
  String get userDirectory;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'eve.holt@reqres.in'**
  String get emailHint;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @users.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get users;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @showPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePassword;

  /// No description provided for @loginOfflineHint.
  ///
  /// In en, this message translates to:
  /// **'An internet connection is required for your first login. Once loaded, saved pages are available offline.'**
  String get loginOfflineHint;

  /// No description provided for @useDemoAccount.
  ///
  /// In en, this message translates to:
  /// **'Use demo account'**
  String get useDemoAccount;

  /// No description provided for @logoutFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to log out. Please try again.'**
  String get logoutFailed;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noData;

  /// No description provided for @noUsers.
  ///
  /// In en, this message translates to:
  /// **'No users found'**
  String get noUsers;

  /// No description provided for @cachedData.
  ///
  /// In en, this message translates to:
  /// **'Unable to connect. Showing data saved on this device.'**
  String get cachedData;

  /// No description provided for @cacheWriteFailed.
  ///
  /// In en, this message translates to:
  /// **'Data loaded, but could not be saved for offline use.'**
  String get cacheWriteFailed;

  /// No description provided for @totalUsers.
  ///
  /// In en, this message translates to:
  /// **'Total users: {count}'**
  String totalUsers(int count);

  /// No description provided for @pageIndicator.
  ///
  /// In en, this message translates to:
  /// **'{page} / {totalPages}'**
  String pageIndicator(int page, int totalPages);

  /// No description provided for @userDetails.
  ///
  /// In en, this message translates to:
  /// **'User details'**
  String get userDetails;

  /// No description provided for @userId.
  ///
  /// In en, this message translates to:
  /// **'User ID: {id}'**
  String userId(int id);

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change language'**
  String get changeLanguage;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @languageSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to save the language. Please try again.'**
  String get languageSaveFailed;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get loading;

  /// No description provided for @checkingSession.
  ///
  /// In en, this message translates to:
  /// **'Restoring session…'**
  String get checkingSession;

  /// No description provided for @connectionFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to connect. Check your internet connection and try again.'**
  String get connectionFailed;

  /// No description provided for @requestForbidden.
  ///
  /// In en, this message translates to:
  /// **'The service rejected the request. Check your ReqRes API key and usage limits.'**
  String get requestForbidden;

  /// No description provided for @rateLimited.
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Please try again later.'**
  String get rateLimited;

  /// No description provided for @unauthorized.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed. Check your credentials and API key.'**
  String get unauthorized;

  /// No description provided for @requestFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to complete the request. Please try again.'**
  String get requestFailed;

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'User not found. Check your login details.'**
  String get userNotFound;

  /// No description provided for @missingEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email.'**
  String get missingEmail;

  /// No description provided for @missingPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password.'**
  String get missingPassword;

  /// No description provided for @invalidLoginResponse.
  ///
  /// In en, this message translates to:
  /// **'The login response is invalid.'**
  String get invalidLoginResponse;

  /// No description provided for @cacheReadFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to read saved data. Connect to the internet to refresh it.'**
  String get cacheReadFailed;

  /// No description provided for @uncachedPage.
  ///
  /// In en, this message translates to:
  /// **'You are offline and this page is not saved. Load it when you have an internet connection.'**
  String get uncachedPage;

  /// No description provided for @sessionReadFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to read the saved session.'**
  String get sessionReadFailed;

  /// No description provided for @credentialsRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email and password.'**
  String get credentialsRequired;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email.'**
  String get invalidEmail;
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
