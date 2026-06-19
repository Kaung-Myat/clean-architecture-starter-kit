/// HTTP verbs supported by [ApiService].
enum ApiMethod { get, post, put, patch, delete }

extension ApiMethodX on ApiMethod {
  String get value => switch (this) {
    ApiMethod.get => 'GET',
    ApiMethod.post => 'POST',
    ApiMethod.put => 'PUT',
    ApiMethod.patch => 'PATCH',
    ApiMethod.delete => 'DELETE',
  };
}
