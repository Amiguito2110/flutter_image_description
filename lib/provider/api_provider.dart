import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../settings/screen_settings.dart';

class CaptionResponse {
  final String captionEn;
  final String captionEs;

  CaptionResponse({required this.captionEn, required this.captionEs});

  factory CaptionResponse.fromJson(Map<String, dynamic> json) {
    return CaptionResponse(
      captionEn: json['caption_en'] ?? '',
      captionEs: json['caption_es'] ?? '',
    );
  }
}

class ApiProvider {
  static Future<CaptionResponse?> predictCaption(File imageFile) async {
    try {
      final baseUrl = await getApiBaseUrl();
      final uri = Uri.parse("$baseUrl/predict_caption");

      var request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        final body = await response.stream.bytesToString();
        final data = json.decode(body);

        return CaptionResponse.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
