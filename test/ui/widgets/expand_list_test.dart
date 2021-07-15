import 'package:cherry/ui/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_page.dart';

void main() {
  group('ExpandList', () {
    testWidgets('renders the info', (tester) async {
      await tester.pumpWidget(
        TestPage(
          (context) => ExpandList(
            hint: 'Hint',
            child: Text('Lorem Ipsum'),
          ),
        ),
      );

      expect(find.text('HINT'), findsOneWidget);
      expect(find.text('Lorem Ipsum'), findsOneWidget);

      await tester.tap(find.text('HINT'));
      await tester.pump();

      expect(find.text('HINT'), findsOneWidget);
      expect(find.text('Lorem Ipsum'), findsOneWidget);
    });
  });
}
