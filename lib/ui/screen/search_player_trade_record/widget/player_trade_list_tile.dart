import 'package:fifa_on4_bank/core/constant/player_grade_color.dart';
import 'package:fifa_on4_bank/core/util/date_util.dart';
import 'package:fifa_on4_bank/core/util/value_util.dart';
import 'package:fifa_on4_bank/ui/screen/search_player_trade_record/model/search_player_trade_record.dart';
import 'package:fifa_on4_bank/ui/widget/player_grade_badge.dart';
import 'package:fifa_on4_bank/ui/widget/player_avatar.dart';
import 'package:fifa_on4_bank/ui/widget/season_badge.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlayerTradeListTile extends StatelessWidget {
  final SearchPlayerTradeRecord tradeRecord;
  final ValueChanged<bool> onChaneged;

  PlayerTradeListTile({
    @required this.tradeRecord,
    @required this.onChaneged,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      secondary: _buildLeading(),
      onChanged: onChaneged,
      value: tradeRecord.isSelected,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              SeasonBadgeImage(
                url: tradeRecord.player.season.seasonImg,
              ),
              SizedBox(
                width: 8.0,
              ),
              Text(
                "${tradeRecord.player.name ?? "-"}",
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
          Row(
            children: [
              PlayerGradeBadge(
                  text: "+${tradeRecord.grade}",
                  background: PlayerGradeColor.getColor(tradeRecord.grade),
                  fontColor: PlayerGradeColor.getFontColor(tradeRecord.grade)),
              SizedBox(
                width: 8.0,
              ),
              Text(
                "금액 : ${ValueUtil.getCurrencyFormatFromInt(tradeRecord.value)}",
                style: TextStyle(fontSize: 14.0),
              ),
            ],
          )
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Text(
          '거래일자: ${DateUtils.getDateString(DateTime.parse(tradeRecord.tradeDate), "yyyy-MM-dd HH:mm")}',
          //style: TextStyle(color: Colors.black54),
        ),
      ),
    );
  }

  Widget _buildLeading() {
    return Container(
      width: 48,
      height: 48,
      child: PlayerAvatar(
        url: ValueUtil.getPlayerImageUrl(tradeRecord.player.id, isFullId: true),
      ),
    );
  }
}
