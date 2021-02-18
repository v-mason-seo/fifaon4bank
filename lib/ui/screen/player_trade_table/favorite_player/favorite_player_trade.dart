import 'package:fifa_on4_bank/core/db/table_model/favorite_player.dart';
import 'package:fifa_on4_bank/core/model/fifa_meta/player.dart';
import 'package:fifa_on4_bank/core/model/fifa_meta/season.dart';
import 'package:fifa_on4_bank/core/util/common_util.dart';
import 'package:fifa_on4_bank/core/util/value_util.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_table/my_player/model/current_price.dart';

class FavoritePlayerTrade {

 Player player;
 int playerGrade;
 CurrentPrice currentPrice;
 List<CurrentPrice> currentPriceList;
 bool isExpanded = false;

  FavoritePlayerTrade({
    this.player,
    this.playerGrade,
    this.currentPrice,
  });


  @override
  String toString() {
    return """FavoritePlayerTrade(
      player: $player,
      playerGrade: $playerGrade,
      currentPrice: $currentPrice,
    )""";
  }

  String getCurrentPrice() {

    if ( CommonUtil.isEmpty(currentPrice)) {
      return "-";
    }

    return ValueUtil.getCurrencyFormatFromInt(currentPrice.presentPrice);
  }


  FavoritePlayerTrade.fromFavoritePlayer(FavoritePlayer favoritePlayer) {
    player = Player(
      id: favoritePlayer.playerId,
      name: favoritePlayer.playerName,
      season: Season(
        seasonId: favoritePlayer.seasonId,
        className: favoritePlayer.className,
        seasonImg: favoritePlayer.seasonImg,
      ),
    );
    playerGrade = favoritePlayer.playerGrade;
  }




}