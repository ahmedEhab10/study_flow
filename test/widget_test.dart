import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:study_flow/main.dart';

void main() {
  setUpAll(() {
    // Disable HTTP fetching for Google Fonts in tests to prevent hanging/network calls
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('StudyFlow splash screen smoke test', (WidgetTester tester) async {
    // Initialize SharedPreferences mock
    SharedPreferences.setMockInitialValues({});

    // Initialize Hive in temporary directory
    final tempDir = Directory.systemTemp.createTempSync();
    Hive.init(tempDir.path);
    await Hive.openBox('tasks_box');
    await Hive.openBox('subjects_box');

    // Build our app and trigger a frame.
    await tester.pumpWidget(const StudyFlow());
    await tester.pump(); // Pump a frame to let builders render

    // Verify that Splash Screen contents are shown.
    expect(find.text('StudyFlow'), findsOneWidget);

    // Clean up temporary Hive files
    try {
      tempDir.deleteSync(recursive: true);
    } catch (_) {}
  });
}
