/// Compile-time / runtime app flavor.
enum AppFlavor {
  dev,
  uat,
  prod;

  static AppFlavor fromName(String name) {
    return AppFlavor.values.firstWhere(
      (f) => f.name == name.toLowerCase(),
      orElse: () => AppFlavor.dev,
    );
  }
}
