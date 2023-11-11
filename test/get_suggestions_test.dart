// test/word_suggestions_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_suggestions/get_suggestions.dart';

void main() {
  testWidgets('TextFieldWithSuggestions Widget Test',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TextFieldWithSuggestions(
            textFieldController: TextEditingController(),
          ),
        ),
      ),
    );

    // Verify that the TextFieldWithSuggestions widget is rendered.
    expect(find.byType(TextFieldWithSuggestions), findsOneWidget);

    // Verify that the TextField is rendered.
    expect(find.byType(TextField), findsOneWidget);

    // Enter text into the TextField.
    await tester.enterText(find.byType(TextField), 'ban');

    // Wait for the suggestions to appear after the 4-second delay.
    await tester.pump(Duration(seconds: 5));

    // Verify that suggestions are rendered.
    expect(find.byType(ListTile),
        findsNWidgets(1)); // Adjust the count based on your expectations.

    // Tap on a suggestion.
    await tester.tap(find.byType(ListTile).first);
    await tester.pump();

    // Verify that the TextField is updated with the selected suggestion.
    expect(find.text('banana'), findsOneWidget);
  });
}
