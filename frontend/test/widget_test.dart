import 'package:flutter_test/flutter_test.dart';

import 'package:clarity/main.dart';

void main() {
  testWidgets('Home screen loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ClarityApp());

    // Verify that home screen header text appears
    expect(find.text('What do you want help with today?'), findsOneWidget);

    // Verify main navigation cards are present
    expect(find.text('Break Down a Task'), findsOneWidget);
    expect(find.text('Read Safely'), findsOneWidget);
    expect(find.text('Ask a Tutor'), findsOneWidget);
  });
}
