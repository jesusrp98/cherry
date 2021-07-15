import 'package:cherry/ui/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_page.dart';

void main() {
  group('PatreonDialog', () {
    testWidgets('renders the info', (tester) async {
      await tester.pumpWidget(
        TestPage(
          (context) => TextButton(
            onPressed: () => showPatreonDialog(context),
            child: Text('Patreon'),
          ),
        ),
      );

      await tester.tap(find.text('Patreon'));
      await tester.pump();
      expect(find.text('about.patreon.title'.toUpperCase()), findsOneWidget);
      expect(find.text('about.patreon.dismiss'), findsOneWidget);
      expect(find.text('PATREON'), findsOneWidget);
    });
  });
}
