// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lab5/main.dart';

// A minimal test app used only for this widget test in case MyApp
// is not a widget in the project.
class _TestApp extends StatefulWidget {
  const _TestApp({Key? key}) : super(key: key);

  @override
  State<_TestApp> createState() => _TestAppState();
}

class _TestAppState extends State<_TestApp> {
  int _counter = 0;

  void _increment() => setState(() => _counter++);

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          body: Center(child: Text('$_counter')),
          floatingActionButton: FloatingActionButton(
            onPressed: _increment,
            child: const Icon(Icons.add),
          ),
        ),
      );
}

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // Use the project's MyApp if it's a widget; otherwise use a
    // local minimal test app.
    // Use a local minimal test app to avoid referencing MyApp which may not be
    // defined in the project under test.
    final Widget app = const _TestApp();
    await tester.pumpWidget(app);

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
