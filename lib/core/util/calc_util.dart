import 'package:fifa_on4_bank/ui/screen/player_trade_calculator/model/fee_detail_result.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_table/my_player/model/minSalesAmount.dart';

class CalcUtil {

  //기본 수수료(%)
  //static int baseFeeRate = 40;
  //TOP 할인율(%)
  //static int topDiscountRate = 20;
  //PC방 할인율
  //static int pcRoomDiscountRate = 30;


  // 기본 수수료 / 100
  static double basicFeeRate = 0.4;
  //TOP 할인율(%) / 100
  static double topDiscountRate = 0.2;
  //PC방 할인율 / 100
  static double pcRoomDiscountRate = 0.3;
  // (TOP + PC방) / 100
  static double topAndPcRoomDiscountRate = 0.5;

  static int basicFeePer = 40;
  static int topDiscountPer = 20;
  static int pcRoomDiscountPer = 30;
  static int topAndPcRoomDiscountPer = 50;

  static int tradeFee(int sellAmount) {
    return (sellAmount * 0.4).floor();
  }

  static tradePrice(int sellAmount, bool checkedTop, bool checkedPcRoom, int discountRate) {
    int fee = tradeFee(sellAmount);
    int totalDiscountRate = 0;
    
    if ( checkedTop) {
      totalDiscountRate = totalDiscountRate + 20;
    }

    if ( checkedPcRoom) {
      totalDiscountRate = totalDiscountRate + 30;
    }

    if ( discountRate > 0 ) {
      totalDiscountRate = totalDiscountRate + discountRate;
    }

    if ( totalDiscountRate > 100 ) {
      totalDiscountRate = 100;
    }

    int discountAmount = (fee * ( totalDiscountRate / 100 )).floor();

    return fee - discountAmount;
  }

  static calcPlayerTrade(FeeDeatilResult item) {
    if ( item.sellAmount == 0) {
      item.fee = 0;
      item.discountRate = 0;
      item.finalPrice = 0;
      item.totalFee = 0;
      return;
    }
      

    item.fee = (item.sellAmount * 0.4).floor();

    item.discountRate = 0;
    if ( item.isCheckedTop) {
      item.discountRate += 20;
    }

    if ( item.isCheckedPcRoom) {
      item.discountRate += 30;
    }    

    int sumDiscountRate = item.discountRate;
    if ( item.addDiscountRate > 0) {
      sumDiscountRate += item.addDiscountRate;
      if ( sumDiscountRate > 100) {
        sumDiscountRate = 100;
      }
    }

    item.discountAmount = (item.fee * ( sumDiscountRate / 100 )).floor();

    item.totalFee = item.fee - item.discountAmount;

    item.finalPrice = item.sellAmount - item.totalFee;
  }


  ///
  /// 기본 수수료 금액을 리턴한다.
  /// 구매금액의 40%가 기본 수수료인다.
  ///
  static int calcBasicFeeAmount(int amount) {

    return (amount * basicFeeRate).round();
  }


  ///
  /// 할인율을 적용한 수수료 할인 금액을 리턴한다.
  /// 기본수수료에서 할인율을 적용한 금액을 리턴한다.
  ///
  static int calcFeeDiscountAmount(int amount, int discountPer) {
    int basicFeeAmount = calcBasicFeeAmount(amount);
    if ( discountPer >= 100) {
      discountPer = 100;
    }
    double discountRate = discountPer / 100;
    return (basicFeeAmount * discountRate).round();
  }


  static int calcFeeAdditionalDiscountAmount(int amount, int discountPer, int addDiscountPer) {
    int basicFeeAmount = calcBasicFeeAmount(amount);
    if ( discountPer + addDiscountPer >= 100) {
      addDiscountPer = 100 - discountPer;
    }
    double discountRate = addDiscountPer / 100;
    return (basicFeeAmount * discountRate).round();
  }


  ///
  /// 기본수수료에서 수수료 할인 금액을 뺀 최종 수수료를 리턴한다.
  ///
  static int calcFinalFeeAmount(int amount, int discountPer, int addDiscountPer) {
    int basicFeeAmount = calcBasicFeeAmount(amount);
    int feeDiscountAmount = calcFeeDiscountAmount(amount, discountPer+addDiscountPer);

    return basicFeeAmount - feeDiscountAmount;
  }


  static int finalReceivedAmount(int amount, int discountPer, int addDiscountPer) {
    int finalDiscountAmount = calcFinalFeeAmount(amount, discountPer, addDiscountPer);

    return amount - finalDiscountAmount;
  }


  ///
  /// TOP 할인 할인 적용하여 손해 없이 팔 수 있는 최소금액
  ///
  static int calcMinSalesAmountOfTop(int purchaseAmount, {int addRate = 0}) {

    if ( purchaseAmount == null || purchaseAmount == 0) {
      return 0;
    }

    double additionalDiscountRate = ( addRate != null && addRate != 0 ) ? addRate / 100 : 0;
    double totalDiscountRate = basicFeeRate * (topDiscountRate + additionalDiscountRate);

    if ( totalDiscountRate > basicFeeRate ) {
      totalDiscountRate = basicFeeRate;
    }

    double feeRate = 1 - (basicFeeRate - totalDiscountRate);

    int minSalesAmount = (purchaseAmount / feeRate).round();

    return minSalesAmount;
  }

  ///
  /// PC방 할인 적용하여 손해 없이 팔 수 있는 최소금액
  ///
  static calcMinSalesAmountOfPcRoom(int purchaseAmount, {int addRate = 0}) {
    if ( purchaseAmount == null || purchaseAmount == 0) {
      return 0;
    }

    double additionalDiscountRate = ( addRate != null && addRate != 0 ) ? addRate / 100 : 0;
    double totalDiscountRate = basicFeeRate * (pcRoomDiscountRate + additionalDiscountRate);

    if ( totalDiscountRate > basicFeeRate ) {
      totalDiscountRate = basicFeeRate;
    }

    double feeRate = 1 - (basicFeeRate - totalDiscountRate);

    int minSalesAmount = (purchaseAmount / feeRate).round();

    return minSalesAmount;
  }

  ///
  /// TOP 할인 + PC방 할인 적용하여 손해 없이 팔 수 있는 최소금액
  ///
  static calcMinSalesAmountOfTopAndPcRoom(int purchaseAmount, {int addRate = 0}) {
    if ( purchaseAmount == null || purchaseAmount == 0) {
      return 0;
    }

    double additionalDiscountRate = ( addRate != null && addRate != 0 ) ? addRate / 100 : 0;
    double totalDiscountRate = basicFeeRate * (topAndPcRoomDiscountRate + additionalDiscountRate);

    if ( totalDiscountRate > basicFeeRate ) {
      totalDiscountRate = basicFeeRate;
    }

    double feeRate = 1 - (basicFeeRate - totalDiscountRate);

    int minSalesAmount = (purchaseAmount / feeRate).round();

    return minSalesAmount;
  }

  static MinSalesAmount calcMinSalesAmount(int purchaseAmount, int addDicountRate) {

    return MinSalesAmount(
      minSalesAmountOfTop: calcMinSalesAmountOfTop(purchaseAmount, addRate: addDicountRate),
      minSalesAmountOfPcRoom : calcMinSalesAmountOfPcRoom(purchaseAmount, addRate: addDicountRate),
      minSalesAmountOfTopAndPcRoom : calcMinSalesAmountOfTopAndPcRoom(purchaseAmount, addRate: addDicountRate)
    );
  }

  static calcMinAmount(int purchaseAmount, MinSalesAmount item) {

    int rate = item.addDiscountRate;

    item.minSalesAmountOfTop = calcMinSalesAmountOfTop(purchaseAmount, addRate: rate);
    item.minSalesAmountOfPcRoom = calcMinSalesAmountOfPcRoom(purchaseAmount, addRate: rate);
    item.minSalesAmountOfTopAndPcRoom = calcMinSalesAmountOfTopAndPcRoom(purchaseAmount, addRate: rate);
    return item;
  }
}