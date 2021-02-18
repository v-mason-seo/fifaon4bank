import 'package:fifa_on4_bank/core/model/fifa_meta/player.dart';
import 'package:fifa_on4_bank/core/provider/base_model.dart';
import 'package:fifa_on4_bank/core/util/calc_util.dart';
import 'package:fifa_on4_bank/core/util/common_util.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_calculator/model/fee_detail_result.dart';

class PlayerTradeCalculatorProvider extends BaseModel {
  
  //PlayerTradeTableContent player;
  FeeDeatilResult feeResult;

  PlayerTradeCalculatorProvider({
    this.feeResult
  }){
    if ( this.feeResult == null ) {
      this.feeResult = FeeDeatilResult();
    }
  }

  setPlayer(Player p) {
    if ( CommonUtil.isEmpty(p)) {
      return;
    }

    feeResult.player = p;
    notifyListeners();    
  }

  setSellAmount(int amount) {
    feeResult.sellAmount = amount;
    calculatePrice();
    notifyListeners();
  }

  checkedPcRoom(bool selected) {
    feeResult.isCheckedPcRoom = selected;
    calculatePrice();
    notifyListeners();
  }

  checkedTop(bool selected) {
    feeResult.isCheckedTop = selected;
    calculatePrice();
    notifyListeners();
  }

  // todo - 숫자입력 작업해야 함.
  setAddDiscountRate(int addDiscountRate) {
    feeResult.addDiscountRate = addDiscountRate;
    calculatePrice();
    notifyListeners();
  }

  addDiscountRate(int addRate) {
    // if ( feeResult.addDiscountRate + addRate > 100 ) {
    //   player.addDiscountRate = 100;
    // } else {
    //   feeResult.addDiscountRate += addRate;
    // }                        

    calculatePrice();
    notifyListeners();
  }

  clearDiscountRate() {
    feeResult.addDiscountRate = 0;
    calculatePrice();
    notifyListeners();
  }

  minusDiscountRate() {
    if ( feeResult.addDiscountRate -10 < 0 ) {
      feeResult.addDiscountRate = 0;
    } else {
      feeResult.addDiscountRate -= 10;
    }
    calculatePrice();
    notifyListeners();
  }

  calculatePrice() {
    CalcUtil.calcPlayerTrade(feeResult);
  }

}