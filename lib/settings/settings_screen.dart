import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../settings/screen_settings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _controller = TextEditingController();
  String _currentUrl = "";

  @override
  void initState() {
    super.initState();
    _loadCurrentUrl();
  }

  Future<void> _loadCurrentUrl() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUrl = prefs.getString("api_url") ?? defaultApiBaseUrl;
    setState(() {
      _currentUrl = storedUrl;
      _controller.text = storedUrl;
    });
  }

  Future<void> _saveUrl() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("api_url", _controller.text.trim());
    setState(() {
      _currentUrl = _controller.text.trim();
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("URL guardada correctamente")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Configuración del Servidor")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "📡 ¿Qué es esto?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Aquí debes ingresar la URL del servidor donde está corriendo la API que procesa las imágenes. "
              "Este servidor puede estar en tu computadora local o en un servidor remoto (como uno en la nube).",
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 10),
            const Text(
              "Ejemplos válidos:\n• http://10.0.2.2:8000\n• http://192.168.0.101:8000\n• https://miapi.com",
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              "🌐 URL del servidor API:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "http://10.0.2.2:8000",
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: _saveUrl,
                icon: const Icon(Icons.save),
                label: const Text("Guardar URL"),
              ),
            ),
            const SizedBox(height: 30),
            Center(child: Text("🌍 URL actual: $_currentUrl")),
            const SizedBox(height: 40),
            const Divider(),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                "Hecho por:\nDiego Omar García Ortiz\nDavid Josué Hernández Cortés\nWilmer Hernández Herrera\nTrabajo escolar - UTM 2025",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
