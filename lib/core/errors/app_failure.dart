enum AppFailureCode {
  connection,
  forbidden,
  rateLimited,
  unauthorized,
  requestFailed,
  userNotFound,
  missingEmail,
  missingPassword,
  invalidLoginResponse,
  cacheReadFailed,
  uncachedPage,
  sessionReadFailed,
  credentialsRequired,
  invalidEmail,
}

class AppFailure implements Exception {
  final AppFailureCode code;
  final String? detail;

  const AppFailure(this.code, {this.detail});

  factory AppFailure.from(Object error) => error is AppFailure
      ? error
      : AppFailure(AppFailureCode.requestFailed, detail: error.toString());

  String get message => detail ?? code.name;

  @override
  String toString() => message;
}
