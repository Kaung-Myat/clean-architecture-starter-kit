/// Lightweight currency formatting (no `intl` dependency).
class CurrencyFormatter {
  const CurrencyFormatter._();

  /// e.g. `format(1234567.5)` → `"$1,234,567.50"`.
  static String format(num amount, {String symbol = '\$', int decimals = 2}) {
    final fixed = amount.toStringAsFixed(decimals);
    final parts = fixed.split('.');
    final intPart = parts[0];
    final neg = intPart.startsWith('-');
    final digits = neg ? intPart.substring(1) : intPart;

    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
      buffer.write(digits[i]);
    }

    final grouped = buffer.toString();
    final dec = parts.length > 1 ? '.${parts[1]}' : '';
    return '${neg ? '-' : ''}$symbol$grouped$dec';
  }
}
