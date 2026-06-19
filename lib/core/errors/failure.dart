/// Optional base failure type.
///
/// The default flow in this kit does **not** wrap results in `Either`/`Failure`
/// (see ABOUT-ARCHI §2): datasources let typed exceptions
/// (`ApiException`/`NetworkException`) propagate to the notifier, where Riverpod
/// captures them as `AsyncError`. These types exist only as scaffolding for
/// teams that prefer a functional error-handling style.
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
