import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';

class ArticleRepository {
  final String url;

  ArticleRepository(this.url);

  Future<List<Article>> fetchArticles() async {
    final uri = Uri.parse(url);
    final res = await http.get(uri);

    if (res.statusCode != 200) {
      throw Exception('無法取得文章：${res.statusCode}');
    }

    final data = jsonDecode(res.body);
    if (data is! List) {
      throw Exception('文章 JSON 格式錯誤（應為 List）');
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map((e) => Article.fromJson(e))
        .toList();
  }
}
