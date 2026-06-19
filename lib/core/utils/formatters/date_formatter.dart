/// Lightweight date formatting (no `intl` dependency).
class DateFormatter {
  const DateFormatter._();

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  /// e.g. `"05 Jun 2026"`.
  static String dMonY(DateTime date) =>
      '${_two(date.day)} ${_months[date.month - 1]} ${date.year}';

  /// e.g. `"2026-06-05"`.
  static String iso(DateTime date) =>
      '${date.year}-${_two(date.month)}-${_two(date.day)}';

  /// e.g. `"14:09"`.
  static String hm(DateTime date) => '${_two(date.hour)}:${_two(date.minute)}';

  static String _two(int n) => n.toString().padLeft(2, '0');
}
