import '../network/exceptions/api_exception.dart';

/// Maps [ApiException.errors] → per-field messages for form UIs.
///
/// Convention:
/// ```dart
/// try {
///   await submit();
/// } on ApiException catch (e) {
///   setState(() => fieldErrors = FormFieldErrors.fromApi(e));
/// }
/// ```
class FormFieldErrors {
  const FormFieldErrors([this._errors = const {}]);

  final Map<String, String> _errors;

  static FormFieldErrors fromApi(ApiException exception) {
    final mapped = <String, String>{};
    exception.errors.forEach((key, messages) {
      if (messages.isNotEmpty) mapped[key] = messages.first;
    });
    return FormFieldErrors(mapped);
  }

  String? operator [](String field) => _errors[field];

  bool get isEmpty => _errors.isEmpty;

  bool get isNotEmpty => _errors.isNotEmpty;

  FormFieldErrors without(String field) {
    if (!_errors.containsKey(field)) return this;
    final next = Map<String, String>.from(_errors)..remove(field);
    return FormFieldErrors(next);
  }
}
