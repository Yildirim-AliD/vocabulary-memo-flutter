import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:isar/isar.dart';
import 'package:vocabulary_memo_flutter/models/word.dart';

class WordService {
  late Isar isar;

  Future<void> init() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      isar = await Isar.open(([WordSchema]), directory: directory.path);
      debugPrint("Isar started ${directory.path}");
    } catch (e) {
      debugPrint("An error occurred during Isar initialization");
    }
  }
}
