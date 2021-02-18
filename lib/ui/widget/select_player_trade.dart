import 'package:fifa_on4_bank/core/model/fifa_meta/player.dart';
import 'package:fifa_on4_bank/core/util/value_util.dart';
import 'package:fifa_on4_bank/ui/screen/search_player/search_player_screen.dart';
import 'package:fifa_on4_bank/ui/widget/player_avatar.dart';
import 'package:fifa_on4_bank/ui/widget/season_badge.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class SelectPlayerTrade extends StatelessWidget {

  final Player player;
  final ValueChanged<Player> onSelected;

  SelectPlayerTrade({
    this.player,
    @required this.onSelected,
  });

  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Player selectedPlayer =  await Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => SearchPlayerScreen())
        );
        onSelected(selectedPlayer);
      },
      child: Container(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 4.0, bottom: 4.0),
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        child: Row(
          children: [
            //-------------------------------------
            player != null
              ? PlayerAvatar(
                url: ValueUtil.getPlayerImageUrl(player.id),
                size: 38.0,
              )
              : Container(),
            //-------------------------------------
            SizedBox(width: 16.0,),
            //-------------------------------------
            Expanded(
              child: player != null
                ? Row(
                  children: [
                    SeasonBadgeImage(
                      url: player.season.seasonImg,
                    ),
                    SizedBox(width: 12.0,),
                    Text("${player.name}")
                  ],
                )
                : Text("선수를 검색해 주세요"),
            ),
            //-------------------------------------
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
                
                Player selectedPlayer =  await Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => SearchPlayerScreen(
                    // api: Provider.of<FifaOn4BankApi>(context, listen: false),
                  ))
                );
                onSelected(selectedPlayer);
              },
            ),
            //-------------------------------------
          ],
        ),
      ),
    );   
  }
}