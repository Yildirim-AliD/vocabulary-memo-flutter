import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vocabulary_memo_flutter/models/word.dart';
import 'package:vocabulary_memo_flutter/services/word_service.dart';

class AddWordScreen extends StatefulWidget {
  final WordService wordService;
  final VoidCallback onSave;
  const AddWordScreen({
    super.key,
    required this.wordService,
    required this.onSave,
  });

  @override
  State<AddWordScreen> createState() => _AddWordScreenState();
}

class _AddWordScreenState extends State<AddWordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _englishController = TextEditingController();
  final _turkishController = TextEditingController();
  final _storyController = TextEditingController();
  String _selectedWordType = "Noun";
  bool _isLearned = false;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  List<String> wordType = [
    "Noun",
    "Adjective",
    "Verb",
    "Adverb",
    "phrasal vern",
    "Idiom",
  ];

  @override
  void dispose() {
    _englishController.dispose();
    _turkishController.dispose();
    _storyController.dispose();
    super.dispose();
  }

  Future<void> _saveWord() async {
    if (_formKey.currentState!.validate()) {
      var _englishWord = _englishController.text;
      var _turkishWord = _turkishController.text;
      var _story = _storyController.text;
      await widget.wordService.saveWord(
        Word(
          englishWord: _englishWord,
          turkishWord: _turkishWord,
          wordType: _selectedWordType,
          story: _story,
          imageBytes:
              _imageFile != null ? await _imageFile!.readAsBytes() : null,
        ),
      );
      widget.onSave();
    }
  }

  Future<void> _selectedImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter english word";
                }
                return null;
              },
              controller: _englishController,
              decoration: InputDecoration(
                labelText: "English Word",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter turkish word";
                }
                return null;
              },
              controller: _turkishController,
              decoration: InputDecoration(
                labelText: "Turkish Word",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedWordType,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                label: Text("Word Type"),
              ),
              items:
                  wordType.map((e) {
                    return DropdownMenuItem(child: Text(e), value: e);
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedWordType = value!;
                });
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _storyController,
              decoration: InputDecoration(
                labelText: "Word Story",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text("Learned"),
                Switch(
                  value: _isLearned,
                  onChanged: (value) {
                    setState(() {
                      _isLearned = !_isLearned;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _selectedImage,
              label: Text("Add Image"),
              icon: Icon(Icons.image),
            ),
            SizedBox(height: 8),
            if (_imageFile != null)
              Image.file(_imageFile!, height: 150, fit: BoxFit.cover),
            SizedBox(height: 8),
            ElevatedButton(onPressed: _saveWord, child: Text("Save Word")),
          ],
        ),
      ),
    );
  }
}
