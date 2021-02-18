import 'package:fifa_on4_bank/core/model/fifa_meta/player.dart';
import 'package:fifa_on4_bank/core/util/common_util.dart';
import 'package:fifa_on4_bank/ui/widget/input_player_trade_grade.dart';
import 'package:fifa_on4_bank/ui/widget/select_player_trade.dart';
import 'package:fifa_on4_bank/ui/widget/title_text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectFavoritePlayerScreen extends StatefulWidget {

  @override
  _SelectFavoritePlayerScreenState createState() => _SelectFavoritePlayerScreenState();
}

class _SelectFavoritePlayerScreenState extends State<SelectFavoritePlayerScreen> {
  
  Player player;
  int playerGrade = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("관심선수 추가"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //--------------------------------
          TitleText(
            title: "선수",
            subTitle: "(필수)",
          ),
          SelectPlayerTrade(
            player: player,
            onSelected: (selectedPlayer) {
              setState(() {
                player = selectedPlayer;
              });
            },
          ),
          //--------------------------------
          TitleText(
            title: "강화등급",
            subTitle: "(선택)",
          ),
          InputPlayerTradeGrade(
            playerGrade: playerGrade,
            onChanged: (grade) {
              setState(() {
                playerGrade = grade;
              });
            },
          ),
          //--------------------------------
          Spacer(),
          //--------------------------------
          MaterialButton(
            height: 48.0,
            minWidth: double.infinity,
            color: Theme.of(context).accentColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8.0), 
                bottomRight: Radius.circular(8.0),
              ),
            ),
            child: Center(
              child: Text(
                "관심선수 등록하기",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.white
                ),
              ),
            ),
            onPressed: () => _handleSubmit(context),
          ),
        ],
      ),
    );
  }

  ///
  /// 관심선수 등록버튼 
  ///
  void _handleSubmit(BuildContext context) async {
    if ( CommonUtil.isEmpty(player)) {
      showMessage(context, "입력오류", "선수를 입력해주세요");
      return;
    }

    Navigator.pop(context, [player, playerGrade]);
  }

  ///
  ///
  ///
  void showMessage(BuildContext context, String title, String body) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
              content: ListTile(
              title: Text(title),
              subtitle: Text(body),
              ),
              actions: <Widget>[
              FlatButton(
                  child: Text('Ok'),
                  onPressed: () => Navigator.of(context).pop(),
              ),
          ],
      ),
    );
  }
}