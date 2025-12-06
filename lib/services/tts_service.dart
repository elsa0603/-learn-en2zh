import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:html' as html; // 只在 web 下使用

class TtsService {
  final String apiKey;

  TtsService(this.apiKey);

  Future<void> speak(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final url = Uri.parse(
        'https://texttospeech.googleapis.com/v1/text:synthesize?key=$apiKey');

    final body = {
      'input': {'text': trimmed},
      'voice': {
        'languageCode': 'en-US',
        'name': 'en-US-Wavenet-G', // 你可以去 console 挑其他 WaveNet
      },
      'audioConfig': {
        'audioEncoding': 'MP3',
        'speakingRate': 0.9,
      }
    };

    try {
      final res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (res.statusCode != 200) {
        return;
      }

      final data = jsonDecode(res.body);
      final audioContent = data['audioContent'];
      if (audioContent is! String || audioContent.isEmpty) {
        return;
      }

      final audio = html.AudioElement()
        ..src = 'data:audio/mp3;base64,$audioContent'
        ..autoplay = true;
      // 不需要加入 DOM，瀏覽器會直接播放
    } catch (_) {
      // 忽略錯誤
    }
  }
}
