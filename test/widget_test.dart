import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Example widget to test
class GreetingWidget extends StatelessWidget {
  final String name;

  GreetingWidget({required this.name});

  @override
  Widget build(BuildContext context) {
    return Text('Hello, $name!', key: Key('greeting_text'));
  }
}

void main() {
  // Define a test group
  group('GreetingWidget Tests', () {
    testWidgets('renders greeting text with the given name',
        (WidgetTester tester) async {
      // Arrange: Create the widget and provide a name
      const testName = 'John';
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: GreetingWidget(name: testName),
        ),
      ));

      // Act: Look for the widget by the Key and verify the output
      expect(find.byKey(Key('greeting_text')), findsOneWidget);
      expect(find.text('Hello, John!'), findsOneWidget);
    });
  });
}
