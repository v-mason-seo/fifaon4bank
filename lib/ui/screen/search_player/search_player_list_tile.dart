import 'package:fifa_on4_bank/core/model/fifa_meta/player.dart';
import 'package:fifa_on4_bank/core/util/value_util.dart';
import 'package:fifa_on4_bank/ui/widget/player_avatar.dart';
import 'package:fifa_on4_bank/ui/widget/season_badge.dart';
import 'package:flutter/material.dart';

class SearchPlayerListTile extends StatelessWidget {
  final Player player;

  SearchPlayerListTile({
    @required this.player
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        // 선수 이미지
        leading: PlayerAvatar(
          url: ValueUtil.getPlayerImageUrl(player.id, isFullId: true),
          size: 48.0,
        ),
        title: Row(
          children: <Widget>[
            SeasonBadgeImage(
              url: player.season.seasonImg,
              size: 24.0,
            ),
            SizedBox(width: 8.0,),
            Text(player.name)
          ],
        ),
        //subtitle: Text(player.season.className),
        onTap: () {
          Navigator.pop(context, player);
        },
      ),
    );
  }
}