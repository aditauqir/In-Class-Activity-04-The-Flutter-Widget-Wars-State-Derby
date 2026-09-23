// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bug/main.dart';

void main() {
  testWidgets('spell console casts fireball and updates its readout', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MagicSpellConsoleApp());

    expect(find.text('MAGIC SPELL'), findsOneWidget);
    expect(find.text('100'), findsOneWidget);
    expect(find.text('NONE'), findsOneWidget);

    final fireball = find.text('FIREBALL').first;
    await tester.ensureVisible(fireball);
    await tester.tap(fireball);
    await tester.pump();

    expect(find.text('80'), findsOneWidget);
    expect(find.text('FIREBALL'), findsWidgets);
    expect(find.text('FIREBALL cast successfully.'), findsOneWidget);
  });

  testWidgets('theme toggle switches the console theme', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MagicSpellConsoleApp());

    expect(find.byIcon(Icons.light_mode_rounded), findsOneWidget);

    await tester.tap(find.byTooltip('Toggle light and dark mode'));
    await tester.pump();

    expect(find.byIcon(Icons.dark_mode_rounded), findsOneWidget);
  });
}
