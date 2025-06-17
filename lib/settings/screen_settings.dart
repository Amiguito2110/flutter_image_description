import 'package:shared_preferences/shared_preferences.dart';

/// URL por defecto cuando no hay ninguna guardada
const String defaultApiBaseUrl = "http://tu_url_api_ejemplo:8000";

/// Llave usada en SharedPreferences
const String apiUrlKey = "api_url";

/// Obtiene la URL actual, ya sea guardada o la por defecto
Future<String> getApiBaseUrl() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(apiUrlKey) ?? defaultApiBaseUrl;
}
