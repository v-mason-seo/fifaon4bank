import 'package:fifa_on4_bank/core/util/value_util.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_calculator/model/fee_detail_result.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlayerTradeFeeResult extends StatelessWidget {

  final FeeDeatilResult feeResult;

  PlayerTradeFeeResult({
    @required this.feeResult,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 4.0, bottom: 4.0),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey[300]),
        borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child: Column(
        children: [
          //-----------------------------------
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              children: [
                Text("기본 수수료(40%)"),
                Expanded(
                  child: Text(
                    "${ValueUtil.getCurrencyFormatFromInt(feeResult.fee)} BP",
                    textAlign: TextAlign.end,
                  ),
                )
              ],
            ),
          ),
          //-----------------------------------
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              children: [
                Text("수수료 할인 금액(${feeResult.getTotalDiscountRate()} %할인)"),
                Expanded(
                  child: Text(
                    "${ValueUtil.getCurrencyFormatFromInt(feeResult.discountAmount)} BP",
                    textAlign: TextAlign.end,
                  ),
                )
              ],
            ),
          ),
          //-----------------------------------
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              children: [
                Text("최종 수수료"),
                Expanded(
                  child: Text(
                    "${ValueUtil.getCurrencyFormatFromInt(feeResult.totalFee)} BP",
                    textAlign: TextAlign.end,
                  ),
                )
              ],
            ),
          ),
          //-----------------------------------
          Divider(height: 15.0,),
          //-----------------------------------
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              children: [
                Text("최종 받는 금액"),
                Expanded(
                  child: Text(
                    "${ValueUtil.getCurrencyFormatFromInt(feeResult.finalPrice)} BP",
                    textAlign: TextAlign.end,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }    
}