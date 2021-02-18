import 'package:fifa_on4_bank/core/model/fifa_meta/player.dart';
import 'package:fifa_on4_bank/core/provider/base_model.dart';
import 'package:fifa_on4_bank/core/util/common_util.dart';

import '../player_trade_table/my_player/model/player_trade_table_content.dart';

class InputPlayerTradeRecordProvider extends BaseModel {
  PlayerTradeTableContent player;

  InputPlayerTradeRecordProvider({
    this.player
  }){
    if ( this.player == null ) {
      this.player = PlayerTradeTableContent();
    }
  }


  setPlayer(Player p) {
    if ( CommonUtil.isEmpty(p)) {
      return;
    }

    player.player = p;
    notifyListeners();    
  }

  setPurchaseAmount(int amount) {
    player.purchaseAmount = amount;
    notifyListeners();    
  }


  setSalesAmount(int amount) {
    player.sellAmount = amount;
    notifyListeners();
  }

  // setAddDiscountRate(int addDiscountRate) {
  //   player.addDiscountRate = addDiscountRate;
  //   notifyListeners();
  // }

  setGrade(int grade) {
    player.grade = grade;
    notifyListeners();
  }
}