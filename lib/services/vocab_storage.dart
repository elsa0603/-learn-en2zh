import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/vocab_entry.dart';
import '../utils/text_clean.dart';

class VocabStorage {
  static const _storageKey = 'vocab_entries_v1';
  List<VocabEntry> _entries = [];

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) {
      _entries = [];
      return;
    }
    try {
      final data = jsonDecode(raw);
      if (data is List) {
        _entries = data
            .whereType<Map<String, dynamic>>()
            .map((e) => VocabEntry.fromJson(e))
            .toList();
      } else {
        _entries = [];
      }
    } catch (_) {
      _entries = [];
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final list = _entries.map((e) => e.toJson()).toList();
    await prefs.setString(_storageKey, jsonEncode(list));
  }

  List<VocabEntry> loadAll() {
    return List.unmodifiable(_entries);
  }

  Future<void> addOrUpdate(VocabEntry entry) async {
    final key = cleanWord(entry.word);
    if (key.isEmpty) return;

    final index = _entries.indexWhere((e) => cleanWord(e.word) == key);

    if (index >= 0) {
      _entries[index] = entry;
    } else {
      _entries.add(entry);
    }
    await _save();
  }

  Future<void> removeByWord(String word) async {
    final key = cleanWord(word);
    _entries.removeWhere((e) => cleanWord(e.word) == key);
    await _save();
  }
}
