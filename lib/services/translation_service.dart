import 'dart:convert';
import 'package:http/http.dart' as http;

class TranslationService {
  final String apiKey;

  TranslationService(this.apiKey);

  Future<String?> translateToZhTw(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return null;

    final url = Uri.parse(
        'https://translation.googleapis.com/language/translate/v2?key=$apiKey');

    try {
      final res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'q': trimmed,
          'source': 'en',
          'target': 'zh-TW',
          'format': 'text',
        }),
      );

      if (res.statusCode != 200) {
        return null;
      }

      final data = jsonDecode(res.body);
      final translations = data['data']?['translations'];
      if (translations is List && translations.isNotEmpty) {
        final t0 = translations.first;
        if (t0 is Map && t0['translatedText'] is String) {
          return t0['translatedText'] as String;
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
