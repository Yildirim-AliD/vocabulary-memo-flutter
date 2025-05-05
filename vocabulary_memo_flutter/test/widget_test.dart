// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vocabulary_memo_flutter/main.dart';
import 'package:vocabulary_memo_flutter/services/word_service.dart';

void main() {
  testWidgets('MainPage renders without crashing', (WidgetTester tester) async {
    final wordService = WordService();
    await wordService.init();

    await tester.pumpWidget(
      MaterialApp(home: MainPage(wordService: wordService)),
    );
    expect(find.text("My Words"), findsOneWidget);
  });
}
