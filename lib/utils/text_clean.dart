/// 清理單字用：移除句點、逗號、引號... 等符號，只保留 a-z / A-Z / ' / -
String cleanWord(String w) {
  return w.replaceAll(RegExp(r"[^A-Za-z'-]"), '').trim().toLowerCase();
}
