extension StringUtils on String {
  String get capitalizeFirstLetter => this[0].toUpperCase() + substring(1);
}
