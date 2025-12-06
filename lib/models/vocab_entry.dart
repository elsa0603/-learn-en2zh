class VocabEntry {
  final String word;
  final String? phonetic;
  final String? partOfSpeech;
  final String? definition;
  final String? example;
  final String? definitionZh; // 中文釋義（翻譯出來的）

  VocabEntry({
    required this.word,
    this.phonetic,
    this.partOfSpeech,
    this.definition,
    this.example,
    this.definitionZh,
  });

  factory VocabEntry.fromJson(Map<String, dynamic> json) {
    return VocabEntry(
      word: json['word'] as String,
      phonetic: json['phonetic'] as String?,
      partOfSpeech: json['partOfSpeech'] as String?,
      definition: json['definition'] as String?,
      example: json['example'] as String?,
      definitionZh: json['definitionZh'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      if (phonetic != null) 'phonetic': phonetic,
      if (partOfSpeech != null) 'partOfSpeech': partOfSpeech,
      if (definition != null) 'definition': definition,
      if (example != null) 'example': example,
      if (definitionZh != null) 'definitionZh': definitionZh,
    };
  }
}
