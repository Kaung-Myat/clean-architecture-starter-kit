/// Optional base failure type for teams that prefer `Either`/`Failure`.
///
/// **v2 default:** do **not** wrap results in `Either`/`Failure`. Datasources
/// throw typed exceptions (`ApiException` / `NetworkException`); Riverpod
/// notifiers capture them as `AsyncError`. Keep this file only if you adopt a
/// functional error-handling style — otherwise leave unused.
sealed class Failure {
  const Failure(this.message);
  final String message;
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection.']);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}
