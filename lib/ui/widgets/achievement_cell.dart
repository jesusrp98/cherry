import 'package:cherry_components/cherry_components.dart';
import 'package:flutter/material.dart';
import 'package:row_collection/row_collection.dart';

import '../../models/achievement.dart';
import '../../utils/index.dart';

class AchievementCell extends StatelessWidget {
  final Achievement achievement;
  final int index;

  const AchievementCell({
    Key key,
    @required this.achievement,
    @required this.index,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        DetailsCell(
          leading: (index + 1).toString(),
          title: achievement.name,
          subtitle: achievement.getDate,
          body: achievement.details,
          onTap: achievement.hasLink
              ? () => context.openUrl(achievement.url)
              : null,
        ),
        Separator.divider(indent: 16),
      ],
    );
  }
}
