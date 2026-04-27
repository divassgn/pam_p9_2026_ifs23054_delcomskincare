class ApiConstants {
  // static const String baseUrl = "http://10.0.2.2:5000"; // Android emulator
  static const String baseUrl = "http://localhost:5000"; // Web / iOS

  static const String login    = "$baseUrl/auth/login";
  static const String skincare = "$baseUrl/skincare";
  static const String generate = "$baseUrl/skincare/generate";
}