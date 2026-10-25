import '../../l10n/generated/app_localizations.dart';
import '../errors/app_failure.dart';

extension LocalizedFailure on AppFailure {
  String localize(AppLocalizations l10n) => switch (code) {
    AppFailureCode.connection => l10n.connectionFailed,
    AppFailureCode.forbidden => l10n.requestForbidden,
    AppFailureCode.rateLimited => l10n.rateLimited,
    AppFailureCode.unauthorized => l10n.unauthorized,
    AppFailureCode.requestFailed => l10n.requestFailed,
    AppFailureCode.userNotFound => l10n.userNotFound,
    AppFailureCode.missingEmail => l10n.missingEmail,
    AppFailureCode.missingPassword => l10n.missingPassword,
    AppFailureCode.invalidLoginResponse => l10n.invalidLoginResponse,
    AppFailureCode.cacheReadFailed => l10n.cacheReadFailed,
    AppFailureCode.uncachedPage => l10n.uncachedPage,
    AppFailureCode.sessionReadFailed => l10n.sessionReadFailed,
    AppFailureCode.credentialsRequired => l10n.credentialsRequired,
    AppFailureCode.invalidEmail => l10n.invalidEmail,
  };
}
