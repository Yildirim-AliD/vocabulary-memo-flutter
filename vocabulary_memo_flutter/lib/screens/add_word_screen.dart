import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddWordScreen extends StatefulWidget {
  const AddWordScreen({super.key});

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

  void _saveWord() {}

  Future<void> _selectedImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _imageFile = File(image.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Form(
        child: ListView(
          children: [
            TextFormField(
              controller: _englishController,
              decoration: InputDecoration(
                labelText: "English Word",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
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
