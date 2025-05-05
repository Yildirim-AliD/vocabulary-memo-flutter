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
  @override
  void initState() {
    super.initState();
    _getAllWords = _getWordsFromDB();
  }

  Future<List<Word>> _getWordsFromDB() async {
    return await widget.wordService.getAllWords();
  }

  void _refreshWords() {
    setState(() {
      _getAllWords = _getWordsFromDB();
    });
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
    return ListView.builder(
      itemBuilder: (context, index) {
        var currentWord = data?[index];
        return ListTile(
          title: Text(currentWord!.englishWord),
          subtitle: Text(currentWord.turkishWord),
          trailing: Switch(
            value: currentWord.isLearned,
            onChanged: (value) async {
              await widget.wordService.toggleWordLearned(currentWord.id);
              _refreshWords();
            },
          ),
        );
      },
      itemCount: data?.length,
    );
  }
}
