import 'dart:io';
import '../provider/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../settings/settings_screen.dart';

class PredictScreen extends StatefulWidget {
  const PredictScreen({super.key});

  @override
  State<PredictScreen> createState() => _PredictScreenState();
}

class _PredictScreenState extends State<PredictScreen> {
  File? _selectedImage;
  CaptionResponse? _caption;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
        _caption = null;
      });
    }
  }

  Future<void> _generateCaption() async {
    if (_selectedImage == null) return;

    setState(() {
      _isLoading = true;
      _caption = null;
    });

    final result = await ApiProvider.predictCaption(_selectedImage!);

    setState(() {
      _caption = result;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DescribeVision'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // Título descriptivo
            const Text(
              "Sube una imagen y obtén una descripción automática.",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            // Imagen seleccionada
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blueAccent, width: 1.5),
              ),
              child: _selectedImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(_selectedImage!, fit: BoxFit.cover),
                    )
                  : const Center(
                      child: Text(
                        "Imagen no seleccionada",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
            ),

            const SizedBox(height: 25),

            // Botones
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image),
                  label: Text(
                    _selectedImage == null ? "Cargar Imagen" : "Otra Imagen",
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _selectedImage != null && !_isLoading
                      ? _generateCaption
                      : null,
                  icon: const Icon(Icons.text_snippet),
                  label: const Text("Generar"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Resultado
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_caption != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Descripción en Inglés:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _caption!.captionEn,
                      style: const TextStyle(fontSize: 15),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Descripción en Español:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _caption!.captionEs,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      _showStartupAlert,
    ); // Muestra la alerta al iniciar
  }

  void _showStartupAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Configuración necesaria"),
        content: const Text(
          "Para que la app funcione correctamente, debes establecer la URL de la API en la configuración.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cerrar"),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
            icon: const Icon(Icons.settings),
            label: const Text("Ir a Configuración"),
          ),
        ],
      ),
    );
  }
}
