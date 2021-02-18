import 'package:fifa_on4_bank/core/constant/player_grade_color.dart';
import 'package:fifa_on4_bank/core/model/fifa_meta/player.dart';
import 'package:fifa_on4_bank/core/util/value_util.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_table/my_player/model/player_trade_table_content.dart';
import 'package:fifa_on4_bank/ui/widget/player_grade_badge.dart';
import 'package:fifa_on4_bank/ui/widget/player_avatar.dart';
import 'package:fifa_on4_bank/ui/widget/season_badge.dart';
import 'package:flutter/cupertino.dart';

class TradePlayerCell extends StatelessWidget {

  final PlayerTradeTableContent content;
  final double width;

  TradePlayerCell({
    this.content,
    this.width = 100
  });

  @override
  Widget build(BuildContext context) {

    Player player = content.player;
    int grade = content.grade;

    return Container(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              PlayerAvatar(
                size: 38,
                url: ValueUtil.getPlayerImageUrl(player.id),
              ),
              Column(
                children: [
                  if(player.season != null)
                    SeasonBadgeImage(
                      size: 20,
                      url: player.season?.seasonImg,
                    ),
                  if (grade > 0)
                    PlayerGradeBadge(
                      text: "+$grade",
                      background: PlayerGradeColor.getColor(grade),
                      fontColor : PlayerGradeColor.getFontColor(grade)
                    ),
                ],
              )
            ],
          ),
          SizedBox(height: 4,),
          Text(
            "${player.name}",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }
}