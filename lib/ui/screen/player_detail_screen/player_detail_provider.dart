import 'package:fifa_on4_bank/core/api/db_api.dart';
import 'package:fifa_on4_bank/core/api/favorite_player_db_api.dart';
import 'package:fifa_on4_bank/core/api/fifa_on4_bank_api.dart';
import 'package:fifa_on4_bank/core/api/player_value_count_type.dart';
import 'package:fifa_on4_bank/core/db/table_model/favorite_player.dart';
import 'package:fifa_on4_bank/core/model/fifa_meta/player.dart';
import 'package:fifa_on4_bank/core/provider/base_model.dart';
import 'package:fifa_on4_bank/core/service_locator/service_locator.dart';
import 'package:fifa_on4_bank/core/util/common_util.dart';

class PlayerDetailProvider extends BaseModel {

  final Player player;
  int playerGrade;
  int purchaseAmount;
  final FavoritePlayerDbApi favoritePlayerDbApi = serviceLocator.get<FavoritePlayerDbApi>();
  final FifaOn4BankApi fifaApi = serviceLocator.get<FifaOn4BankApi>();
  final DBApi dbApi = serviceLocator.get<DBApi>();
  bool isFavorited = false;

  PlayerDetailProvider({
    this.player,
    this.playerGrade,
    this.purchaseAmount
  });


  loadData() async {
    setBusy(true);

    if ( purchaseAmount == null) {
      try {
        purchaseAmount = await dbApi.getRecentPurchaseAmount(player.id, playerGrade);
      } catch(e) {
        purchaseAmount = 0;
      }
    }

    isFavoritePlayer();

    fifaApi.updateHit(player.id, PlayerValueCountType.hit_newsValuable);

    setBusy(false);
  }


  isFavoritePlayer() async {

    try {
      FavoritePlayer favoritePlayer = await favoritePlayerDbApi.getFavoritePlayer(player.id, playerGrade);
      if ( CommonUtil.isNotEmpty(favoritePlayer) ) {
        isFavorited = true;
      } else {
        isFavorited = false;
      }
    } catch(e) {
      // print(e);
      isFavorited = false;
    }
    

    notifyListeners();
  }


  changeFavoritePlayer() async{
    isFavorited = !isFavorited;

    // try {
    //   if ( isFavorited ) {
    //     FavoritePlayer insertData = FavoritePlayer.fromPlayer(player, playerGrade);
    //     await favoritePlayerDbApi.careteFavoritePlayer(insertData);
    //   } else {
    //     await favoritePlayerDbApi.deleteFavoritePlayer(player.id, playerGrade);
    //   }
    // } catch(e) {
    //   isFavorited = !isFavorited;
    // }    

    notifyListeners();
  }
}