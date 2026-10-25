// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Amanos';

  @override
  String get userDirectory => 'User directory';

  @override
  String get email => 'Email';

  @override
  String get emailHint => 'eve.holt@reqres.in';

  @override
  String get password => 'Password';

  @override
  String get login => 'Login';

  @override
  String get logout => 'Logout';

  @override
  String get users => 'Users';

  @override
  String get refresh => 'Refresh';

  @override
  String get previous => 'Previous';

  @override
  String get next => 'Next';

  @override
  String get retry => 'Retry';

  @override
  String get close => 'Close';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get loginOfflineHint =>
      'An internet connection is required for your first login. Once loaded, saved pages are available offline.';

  @override
  String get useDemoAccount => 'Use demo account';

  @override
  String get logoutFailed => 'Unable to log out. Please try again.';

  @override
  String get noData => 'No data available';

  @override
  String get noUsers => 'No users found';

  @override
  String get cachedData =>
      'Unable to connect. Showing data saved on this device.';

  @override
  String get cacheWriteFailed =>
      'Data loaded, but could not be saved for offline use.';

  @override
  String totalUsers(int count) {
    return 'Total users: $count';
  }

  @override
  String pageIndicator(int page, int totalPages) {
    return '$page / $totalPages';
  }

  @override
  String get userDetails => 'User details';

  @override
  String userId(int id) {
    return 'User ID: $id';
  }

  @override
  String get changeLanguage => 'Change language';

  @override
  String get arabic => 'العربية';

  @override
  String get english => 'English';

  @override
  String get languageSaveFailed =>
      'Unable to save the language. Please try again.';

  @override
  String get loading => 'Loading…';

  @override
  String get checkingSession => 'Restoring session…';

  @override
  String get connectionFailed =>
      'Unable to connect. Check your internet connection and try again.';

  @override
  String get requestForbidden =>
      'The service rejected the request. Check your ReqRes API key and usage limits.';

  @override
  String get rateLimited => 'Too many requests. Please try again later.';

  @override
  String get unauthorized =>
      'Authentication failed. Check your credentials and API key.';

  @override
  String get requestFailed =>
      'Unable to complete the request. Please try again.';

  @override
  String get userNotFound => 'User not found. Check your login details.';

  @override
  String get missingEmail => 'Please enter your email.';

  @override
  String get missingPassword => 'Please enter your password.';

  @override
  String get invalidLoginResponse => 'The login response is invalid.';

  @override
  String get cacheReadFailed =>
      'Unable to read saved data. Connect to the internet to refresh it.';

  @override
  String get uncachedPage =>
      'You are offline and this page is not saved. Load it when you have an internet connection.';

  @override
  String get sessionReadFailed => 'Unable to read the saved session.';

  @override
  String get credentialsRequired => 'Please enter your email and password.';

  @override
  String get invalidEmail => 'Please enter a valid email.';
}
