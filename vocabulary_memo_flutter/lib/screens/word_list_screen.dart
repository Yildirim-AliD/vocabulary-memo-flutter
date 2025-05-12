import 'package:flutter/material.dart';
import 'package:vocabulary_memo_flutter/models/word.dart';
import 'package:vocabulary_memo_flutter/services/word_service.dart';

class WordList extends StatefulWidget {
  final WordService wordService;
  const WordList({super.key, required this.wordService});

  @override
  State<WordList> createState() => _WordListState();
}

class _WordListState extends State<WordList> {
  late Future<List<Word>> _getAllWords;
  List<Word> _words = [];
  @override
  void initState() {
    super.initState();
    _getAllWords = _getWordsFromDB();
  }

  Future<List<Word>> _getWordsFromDB() async {
    return await widget.wordService.getAllWords();
  }

  // ignore: unused_element
  void _refreshWords() {
    setState(() {
      _getAllWords = _getWordsFromDB();
    });
  }

  _toggleUpdateWord(Word currentWord) async {
    await widget.wordService.toggleWordLearned(currentWord.id);
    final index = _words.indexWhere((element) => element.id == currentWord.id);
    var changedWord = _words[index];
    changedWord.isLearned = !changedWord.isLearned;
    _words[index] = changedWord;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(),
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
    _words = data!;
    return ListView.builder(
      itemBuilder: (context, index) {
        var currentWord = _words[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
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
                ],
              ),
            ),
          ),
        );
      },
      itemCount: data.length,
    );
  }
}
