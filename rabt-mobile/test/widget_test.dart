// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rabt_mobile/main.dart';

void main() {
  testWidgets('App builds and navigates to Login after splash', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    // Let splash timer (600ms) elapse
    await tester.pump(const Duration(milliseconds: 700));
    expect(find.text('Login'), findsOneWidget);
  });
}
