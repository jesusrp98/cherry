import 'package:cherry/ui/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_page.dart';

void main() {
  group('ErrorView', () {
    testWidgets('renders the info', (tester) async {
      await tester.pumpWidget(
        TestPage(
          (context) => ErrorView(),
        ),
      );

      expect(find.text('spacex.other.loading_error.message'), findsOneWidget);
      expect(find.text('spacex.other.loading_error.reload'), findsOneWidget);
      expect(find.byIcon(Icons.cloud_off), findsOneWidget);
    });
  });

  group('ErrorSliverView', () {
    testWidgets('renders the info', (tester) async {
      await tester.pumpWidget(
        TestPage(
          (context) => CustomScrollView(
            slivers: const [ErrorSliverView()],
          ),
        ),
      );

      expect(find.text('spacex.other.loading_error.message'), findsOneWidget);
      expect(find.text('spacex.other.loading_error.reload'), findsOneWidget);
      expect(find.byIcon(Icons.cloud_off), findsOneWidget);
    });
  });
}
