import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:tn_party_connect/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: TNPartyConnectApp()));

    // Verify that the app starts up without crashing and displays the MaterialApp
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
