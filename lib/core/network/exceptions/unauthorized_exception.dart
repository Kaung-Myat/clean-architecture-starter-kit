import 'api_exception.dart';

/// A 401 that represents an expired/invalid session (not bad credentials).
///
/// Bad-credentials 401s should be surfaced as a normal [ApiException] by
/// passing `kSkip401Redirect` so the [AuthInterceptor] does not treat them as
/// session expiry.
class UnauthorizedException extends ApiException {
  const UnauthorizedException({super.message = 'Session expired. Please sign in again.'})
      : super(statusCode: 401);
}
