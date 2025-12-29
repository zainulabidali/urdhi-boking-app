// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:urdhi_tracker/main.dart';
import 'package:urdhi_tracker/providers/booking_provider.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    // Initialize Hive for testing
    await Hive.initFlutter();

    // Create a test booking provider
    final bookingProvider = BookingProvider();
    await bookingProvider.init();

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [ChangeNotifierProvider.value(value: bookingProvider)],
        child: const RamadanSpeechApp(),
      ),
    );

    // Verify that the app title is displayed
    expect(find.text('Ramadan Speech Notebook'), findsOneWidget);
  });
}
