import 'package:flutter_test/flutter_test.dart';
import 'package:vocabulary_memo_flutter/main.dart';
import 'package:vocabulary_memo_flutter/services/word_service.dart';

void main() {
  testWidgets('MainPage renders without crashing', (WidgetTester tester) async {
    final wordService = WordService();
    await wordService.init();

    await tester.pumpWidget(
      MyApp(wordservice: wordService), 
    );

    await tester.pumpAndSettle(); 

    expect(find.text("My Words"), findsOneWidget);
  });
}
