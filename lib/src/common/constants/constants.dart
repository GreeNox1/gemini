class AppConstants {
  const AppConstants._();

  static const String settings = "settings";

  static const String theme = "$settings.theme";
  static const String locale = "$settings.locale";

  static const String apiKey = "AIzaSyD0S4W5QJv_OEGqAUfQyjSTDNPFeAMHRcA";
  static const String baseUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey";
}
