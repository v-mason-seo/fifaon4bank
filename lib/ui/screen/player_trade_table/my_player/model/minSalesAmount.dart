import 'package:fifa_on4_bank/core/util/calc_util.dart';

class MinSalesAmount {
  int addDiscountRate;
  int minSalesAmountOfTop;
  int minSalesAmountOfPcRoom;
  int minSalesAmountOfTopAndPcRoom;

  MinSalesAmount({
    this.addDiscountRate = 0,
    this.minSalesAmountOfTop = 0,
    this.minSalesAmountOfPcRoom = 0,
    this.minSalesAmountOfTopAndPcRoom = 0
  });


  calculateAmount(int purchaseAmount) {
    minSalesAmountOfTop = CalcUtil.calcMinSalesAmountOfTop(purchaseAmount, addRate: addDiscountRate);
    minSalesAmountOfPcRoom = CalcUtil.calcMinSalesAmountOfPcRoom(purchaseAmount, addRate: addDiscountRate);
    minSalesAmountOfTopAndPcRoom = CalcUtil.calcMinSalesAmountOfTopAndPcRoom(purchaseAmount, addRate: addDiscountRate);
  }


  MinSalesAmount.fromJson(Map<String, dynamic> json)
    : addDiscountRate = json['addDiscountRate'];


  Map<String, dynamic> toJson() => {
    'addDiscountRate' : addDiscountRate
  };
  
}