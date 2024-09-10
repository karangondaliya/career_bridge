// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:career_bridge/main.dart';



void main() {
  testWidgets('CareerBridgeApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(CareerBridgeApp());

    // Verify that our app shows the login page initially.
    expect(find.text('CareerBridge Login'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));  // Email and Password fields
    expect(find.byType(ElevatedButton), findsOneWidget);  // Login button
  });
}
