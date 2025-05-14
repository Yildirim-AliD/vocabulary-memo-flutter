import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vocabulary_memo_flutter/models/word.dart';
import 'package:vocabulary_memo_flutter/services/word_service.dart';

class WordList extends StatefulWidget {
  final WordService wordService;
  final Function(Word) onEditWord;
  const WordList({
    super.key,
    required this.wordService,
    required this.onEditWord,
  });

  @override
  State<WordList> createState() => _WordListState();
}

class _WordListState extends State<WordList> {
  late Future<List<Word>> _getAllWords;
  List<Word> _words = [];
  List<Word> _filteredWords = [];
  List<String> wordType = [
    "All",
    "Noun",
    "Adjective",
    "Verb",
    "Adverb",
    "phrasal verb",
    "Idiom",
  ];
  String _selectedWordType = "All";
  bool _showLearned = false;

  _applyFilter() {
    _filteredWords = List.from(_words);
    if (_selectedWordType != "All") {
      _filteredWords =
          _filteredWords
              .where(
                (element) =>
                    element.wordType.toLowerCase() ==
                    _selectedWordType.toLowerCase(),
              )
              .toList();
    }

    if (_showLearned) {
      _filteredWords =
          _filteredWords
              .where((element) => element.isLearned != _showLearned)
              .toList();
    }
  }

  @override
  void initState() {
    super.initState();
    _getAllWords = _getWordsFromDB();
  }

  Widget _buildFilterCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.filter_alt_rounded),
                const SizedBox(width: 8),
                const Text("Filter"),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: "Word Type",
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedWordType,
                    items:
                        wordType
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedWordType = value!;
                        _applyFilter();
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text("Hide my learned words"),
                Switch(
                  value: _showLearned,
                  onChanged: (value) {
                    setState(() {
                      _showLearned = !_showLearned;
                      _applyFilter();
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Word>> _getWordsFromDB() async {
    var wordsFromDB = await widget.wordService.getAllWords();
    _words = wordsFromDB.reversed.toList();
    return wordsFromDB;
  }

  void _deleteWord(Word wordToBeDeleted) async {
    await widget.wordService.deleteWord(wordToBeDeleted.id);
    _words.removeWhere((element) => element.id == wordToBeDeleted.id);
  }

  // void _refreshWords() {
  //   setState(() {
  //     _getAllWords = _getWordsFromDB();
  //   });
  // }

  _toggleUpdateWord(Word currentWord) async {
    await widget.wordService.toggleWordLearned(currentWord.id);

    setState(() {
      final index = _words.indexWhere(
        (element) => element.id == currentWord.id,
      );
      var changeWord = _words[index];
      changeWord.isLearned = !changeWord.isLearned;
      _words[index] = changeWord;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildFilterCard(),
        Expanded(
          child: FutureBuilder<List<Word>>(
            future: _getAllWords,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text("Hata var ${snapshot.error.toString()}"),
                );
              }
              if (snapshot.hasData) {
                // ignore: prefer_is_empty
                return snapshot.data?.length == 0
                    ? Center(child: Text("Lütfen kelime giriniz:"))
                    : _buildListView(snapshot.data);
              } else {
                return SizedBox();
              }
            },
          ),
        ),
      ],
    );
  }

  _buildListView(List<Word>? data) {
    _applyFilter();
    return ListView.builder(
      itemBuilder: (context, index) {
        var currentWord = _filteredWords[index];
        return Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.endToStart,
          background: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: Icon(
              Icons.delete_rounded,
              color: Theme.of(context).colorScheme.error,
              size: 24,
            ),
          ),
          onDismissed: (direction) => _deleteWord(currentWord),
          confirmDismiss: (direction) async {
            return await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Delete word"),
                  content: Text(
                    "Are you sure you want to delete the word ${currentWord.englishWord}",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: const Text("No"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: const Text("Yes"),
                    ),
                  ],
                );
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: GestureDetector(
              onTap: () => widget.onEditWord(currentWord),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 8,
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(currentWord.englishWord),
                        subtitle: Text(currentWord.turkishWord),
                        leading: Chip(label: Text(currentWord.wordType)),
                        trailing: Switch(
                          value: currentWord.isLearned,
                          onChanged: (value) => _toggleUpdateWord(currentWord),
                        ),
                      ),
                      if (currentWord.story != null &&
                          currentWord.story!.isNotEmpty)
                        Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.secondaryContainer.withAlpha(200),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.lightbulb),
                                  SizedBox(width: 8),
                                  Text("Note"),
                                ],
                              ),
                              SizedBox(height: 4),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  currentWord.story ?? " ",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (currentWord.imageBytes != null)
                        Image.memory(
                          Uint8List.fromList(currentWord.imageBytes!),
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      itemCount: _filteredWords.length,
    );
  }
}
