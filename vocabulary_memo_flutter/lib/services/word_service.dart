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

  Future<void> saveWord(Word word) async {
    try {
      await isar.writeTxn(() async {
        final id = await isar.words.put(word);
        debugPrint("New word '${word.englishWord}' was added with ID $id.");
      });
    } catch (e) {
      debugPrint("An error occurred while adding the word.$e");
    }
  }

  Future<List<Word>> getAllWords() async {
    try {
      final words = await isar.words.where().findAll();
      return words;
    } catch (e) {
      debugPrint("Error while fetching all words $e");
      return [];
    }
  }

  Future<void> deleteWord(int id) async {
    try {
      await isar.writeTxn(() async {
        await isar.words.delete(id);
        debugPrint("The word with ID $id has been deleted.");
      });
    } catch (e) {
      debugPrint("An error occurred while deleting the word.$e");
    }
  }

  Future<void> updateWord(Word word) async {
    try {
      await isar.writeTxn(() async {
        final id = await isar.words.put(word);
        debugPrint("Word '${word.englishWord}' was updated with $id.");
      });
    } catch (e) {
      debugPrint("An error occurred while updating the word.$e");
    }
  }

  Future<void> toggleWordLearned(int id) async {
    try {
      await isar.writeTxn(() async {
        final word = await isar.words.get(id);
        if (word != null) {
          word.isLearned = !word.isLearned;
          await isar.words.put(word);
          debugPrint("Word has been updated.");
        } else {
          debugPrint("Word could not be updated");
        }
      });
    } catch (e) {
      debugPrint("An error occurred while updating the word.$e");
    }
  }
}
