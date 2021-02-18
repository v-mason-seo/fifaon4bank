import 'package:fifa_on4_bank/ui/widget/player_avatar.dart';
import 'package:fifa_on4_bank/ui/widget/season_badge.dart';
import 'package:flutter/cupertino.dart';

class PlayerSeasonAvatar extends StatelessWidget {

  final String playerUrl;
  final double playerSize;
  final String seasonUrl;
  final double seasonSize;


  PlayerSeasonAvatar({
    @required this.playerUrl,
    @required this.playerSize,
    @required this.seasonUrl,
    @required this.seasonSize,
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          PlayerAvatar(
            size: playerSize,
            url: playerUrl,
          ),
          SeasonBadgeImage(
              size: seasonSize,
              url: seasonUrl,
            ),
          Align(
            alignment: Alignment.bottomLeft,
            child: SeasonBadgeImage(
              size: seasonSize,
              url: seasonUrl,
            ),
          )
        ],
      ),
    );
  }
}