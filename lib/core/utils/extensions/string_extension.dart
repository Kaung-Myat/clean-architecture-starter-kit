extension StringExtension on String {
  String get capitalize =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  String get titleCase => split(' ').map((w) => w.capitalize).join(' ');

  bool get isBlank => trim().isEmpty;

  String? get nullIfBlank => isBlank ? null : this;
}

extension NullableStringExtension on String? {
  bool get isNullOrBlank => this == null || this!.trim().isEmpty;
}
