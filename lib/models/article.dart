class Article {
  final int id;
  final String title;

  /// 英文全文
  final String english;

  /// 若未來 JSON 有直接附中文，可用；目前主要用 Translation API
  final String? chinese;

  /// 初級 / 中級（可為 null）
  final String? level;

  /// 旅遊 / 飲食 / 生活 / 知識（可為 null）
  final String? category;

  Article({
    required this.id,
    required this.title,
    required this.english,
    this.chinese,
    this.level,
    this.category,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: (json['title'] as String?) ?? '',
      english: (json['english'] as String?) ?? '',
      chinese: json['chinese'] as String?,
      level: json['level'] as String?,
      category: json['category'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'english': english,
      if (chinese != null) 'chinese': chinese,
      if (level != null) 'level': level,
      if (category != null) 'category': category,
    };
  }
}
