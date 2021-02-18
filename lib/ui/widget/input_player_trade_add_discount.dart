import 'package:fifa_on4_bank/ui/screen/player_trade_calculator/model/fee_detail_result.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputPlayerTradeAddDiscount extends StatelessWidget {

 final FeeDeatilResult feeDetail; 
 final ValueChanged<double> onAddDiscounntChangeEnd;
  final ValueChanged<double> onAddDiscountChanged;

  InputPlayerTradeAddDiscount({
    @required this.feeDetail,
    @required this.onAddDiscountChanged,
    @required this.onAddDiscounntChangeEnd
  }); 

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
      margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 4.0, bottom: 4.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(width: 1, color: Colors.grey[300]),
        borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child: Column(
        children: [
          //----------------------------------------------
          //----------------------------------------------
          Row(
            children: [
              Text(
                "추가 할인율 입력",
                style: TextStyle(fontSize: 13.0),
              ),
              SizedBox(width: 20.0,),
              Expanded(
                child: Container(
                  height: 38.0,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey
                    )
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "${feeDetail.addDiscountRate} %",
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
              ),
            ],
          ),
          //------------------------------------------
          Slider(
            value: feeDetail.addDiscountRate.toDouble(),
            label: "${feeDetail.addDiscountRate} %",
            max: 50,
            min: 0,
            //divisions: 20,
            onChangeEnd: onAddDiscounntChangeEnd,
            onChanged: onAddDiscountChanged,
          ),
          //------------------------------------------
        ]
      ),
    );
  }  
}