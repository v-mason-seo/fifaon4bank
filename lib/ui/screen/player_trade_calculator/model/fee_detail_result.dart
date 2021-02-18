import 'package:fifa_on4_bank/core/model/fifa_meta/player.dart';

class FeeDeatilResult {

  Player player;
  int purchaseAmount;
  int sellAmount;
  bool isCheckedTop;
  bool isCheckedPcRoom;
  int discountRate;
  int addDiscountRate;
  int discountAmount;
  int fee;
  int totalFee;
  int finalPrice;


  FeeDeatilResult({
    this.player,
    this.purchaseAmount = 0,
    this.sellAmount = 0,
    this.isCheckedPcRoom = false,
    this.isCheckedTop = false,
    this.discountRate = 0,
    this.addDiscountRate = 0,
    this.discountAmount = 0,
    this.fee = 0,
    this.totalFee = 0,
    this.finalPrice = 0,
  });


  FeeDeatilResult.fromJson(Map<String, dynamic> json)
    : player = Player.fromJson(json['player']),
      purchaseAmount = json['purchaseAmount'],
      sellAmount = json['sellAmount'],
      isCheckedTop = json['isCheckedTop'],
      isCheckedPcRoom = json['isCheckedPcRoom'],
      discountRate = json['discountRate'],
      addDiscountRate = json['addDiscountRate'],
      discountAmount = json['discountAmount'],
      fee = json['fee'],
      totalFee = json['totalFee'],
      finalPrice = json['finalPrice']
      ;

  Map<String, dynamic> toJson() => {
    'purchaseAmount' : purchaseAmount,
    'sellAmount' : sellAmount,
    'isCheckedTop' : isCheckedTop,
    'isCheckedPcRoom' : isCheckedPcRoom,
    'discountRate' : discountRate,
    'addDiscountRate' : addDiscountRate,
    'discountAmount' : discountAmount,
    'fee' : fee,
    'totalFee' : totalFee,
    'finalPrice' : finalPrice,
  };

  int getTotalDiscountRate() {
    int sumDiscountRate = discountRate + addDiscountRate;
    if ( sumDiscountRate > 100) {
      return 100;
    }

    return sumDiscountRate;
  }

}