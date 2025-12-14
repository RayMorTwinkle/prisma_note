// This is a basic Flutter widget test for Prisma Note app.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:prisma_note/main.dart';

void main() {
  testWidgets('Prisma Note app starts correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const PrismaNoteApp());

    // Verify that bottom navigation is present with all tabs
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    
    // Verify that navigation items are present (use semantic labels for accuracy)
    final bottomNavBar = tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
    expect(bottomNavBar.items.length, equals(3));
    
    // Verify the app title or header is present
    expect(find.text('Timeline'), findsWidgets);
  });
}
