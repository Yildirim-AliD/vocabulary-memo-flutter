import 'package:flutter/material.dart';
import 'package:vocabulary_memo_flutter/models/word.dart';
import 'package:vocabulary_memo_flutter/screens/add_word_screen.dart';
import 'package:vocabulary_memo_flutter/screens/word_list_screen.dart';
import 'package:vocabulary_memo_flutter/services/word_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final wordservice = WordService();
  try {
    await wordservice.init();

    // Word eklenecekKelime = Word(englishWord: "garden", turkishWord: "bahçe", wordType: "noun");
    // await wordservice.saveWord(eklenecekKelime);
    final words = await wordservice.getAllWords();
    debugPrint(words.toString());
  } catch (e) {
    debugPrint("$e");
  }
  runApp(MyApp(wordservice: wordservice));
}

class MyApp extends StatelessWidget {
  final WordService wordservice;
  const MyApp({super.key, required this.wordservice});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MainPage(wordservice: wordservice),
    );
  }
}

class MainPage extends StatefulWidget {
  final WordService wordservice;
  const MainPage({super.key, required this.wordservice});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedScreen = 0;
  Word? _wordToEdit;

  void _editWord(Word guncellenecekKelime) {
    setState(() {
      _selectedScreen = 1;
      _wordToEdit = guncellenecekKelime;
    });
  }

  List<Widget> getScreens() {
    return [
      WordList(wordService: widget.wordservice, onEditWord: _editWord),
      AddWordScreen(
        wordService: widget.wordservice,
        wordToEdit: _wordToEdit,
        onSave: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("The word has been saved")),
          );
          setState(() {
            _selectedScreen = 0;
            _wordToEdit = null;
          });
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Words")),
      body: getScreens()[_selectedScreen],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedScreen,
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.list_alt),
            label: "Words",
          ),
          NavigationDestination(
            icon: const Icon(Icons.add_circle_outline),
            label: _wordToEdit == null ? "Add" : 'Update',
          ),
        ],
        onDestinationSelected: (value) {
          setState(() {
            _selectedScreen = value;
            if (_selectedScreen == 0) {
              _wordToEdit = null;
            }
          });
        },
      ),
    );
  }
}
