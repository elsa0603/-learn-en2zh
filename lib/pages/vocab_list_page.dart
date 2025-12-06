import 'package:flutter/material.dart';
import '../models/vocab_entry.dart';
import '../services/vocab_storage.dart';
import '../services/tts_service.dart';

class VocabListPage extends StatefulWidget {
  final VocabStorage vocabStorage;
  final TtsService ttsService;

  const VocabListPage({
    super.key,
    required this.vocabStorage,
    required this.ttsService,
  });

  @override
  State<VocabListPage> createState() => _VocabListPageState();
}

class _VocabListPageState extends State<VocabListPage> {
  late List<VocabEntry> _entries;

  @override
  void initState() {
    super.initState();
    _entries = widget.vocabStorage.loadAll();
  }

  Future<void> _refresh() async {
    setState(() {
      _entries = widget.vocabStorage.loadAll();
    });
  }

  Future<void> _deleteWord(VocabEntry entry) async {
    await widget.vocabStorage.removeByWord(entry.word);
    await _refresh();
  }

  Future<void> _speakWord(VocabEntry entry) async {
    await widget.ttsService.speak(entry.word);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('我的生字本'),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: _entries.isEmpty
            ? ListView(
                children: const [
                  SizedBox(height: 80),
                  Center(
                    child: Text('目前沒有任何生字，回文章裡點單字加入吧！'),
                  ),
                ],
              )
            : ListView.builder(
                itemCount: _entries.length,
                itemBuilder: (context, index) {
                  final v = _entries[index];
                  return Dismissible(
                    key: ValueKey(v.word + index.toString()),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (_) => _deleteWord(v),
                    child: ListTile(
                      title: Text(
                        v.word,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (v.phonetic != null && v.phonetic!.isNotEmpty)
                            Text(v.phonetic!),
                          if (v.partOfSpeech != null &&
                              v.partOfSpeech!.isNotEmpty)
                            Text(
                              v.partOfSpeech!,
                              style:
                                  const TextStyle(fontStyle: FontStyle.italic),
                            ),
                          if (v.definition != null) Text(v.definition!),
                          if (v.definitionZh != null &&
                              v.definitionZh!.isNotEmpty)
                            Text(
                              v.definitionZh!,
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.volume_up),
                        onPressed: () => _speakWord(v),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
