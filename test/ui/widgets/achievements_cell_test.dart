import 'package:cherry/models/achievement.dart';
import 'package:cherry/ui/widgets/index.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_page.dart';

void main() {
  group('AchievementCell', () {
    testWidgets('can render data', (tester) async {
      await tester.pumpWidget(TestPage(
        (_) => AchievementCell(
          index: 0,
          achievement: Achievement(
            date: DateTime.now(),
            details: 'Details',
            id: '0',
            name: 'Lorem Ipsum',
            url: 'http://google.es',
          ),
        ),
      ));

      expect(find.text('1'), findsOneWidget);
      expect(find.text('Details'), findsOneWidget);
      expect(find.text('Lorem Ipsum'), findsOneWidget);
    });
  });
}
