import 'package:flutter/material.dart';
import 'package:vocabulary_memo_flutter/screens/add_word_screen.dart';
import 'package:vocabulary_memo_flutter/screens/word_list_screen.dart';
import 'package:vocabulary_memo_flutter/services/word_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final wordService = WordService();
  try {
    await wordService.init();

    // Word wordToAdd = Word(
    //   englishWord: "Garden",
    //   turkishWord: "Bahçe",
    //   wordType: "Noun",
    // );
    // await wordService.saveWord(wordToAdd);
    final words = await wordService.getAllWords();
    debugPrint(words.toString());
  } catch (e) {
    debugPrint("Error $e");
  }
  runApp(MaterialApp(home: MainPage(wordService: wordService)));
}

class MainPage extends StatefulWidget {
  final WordService wordService;
  const MainPage({super.key, required this.wordService});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Widget> getScreens() {
    return [WordList(wordService: widget.wordService), AddWordScreen()];
  }

  int _selectedScreen = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Words")),
      body: getScreens()[_selectedScreen],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedScreen,
        destinations: [
          NavigationDestination(icon: Icon(Icons.list_alt), label: "Words"),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            label: "Add",
          ),
        ],
        onDestinationSelected: (value) {
          setState(() {
            _selectedScreen = value;
          });
        },
      ),
    );
  }
}
