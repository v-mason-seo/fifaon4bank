import 'package:fifa_on4_bank/ui/screen/player_trade_calculator/model/fee_detail_result.dart';
 import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class InputPlayerTradeDiscount extends StatefulWidget {

  final FeeDeatilResult feeResult;
  final ValueChanged<int> onAddDiscountChanged;
  final ValueChanged<bool> onTopChanged;
  final ValueChanged<bool> onPcRoomChanged;

  InputPlayerTradeDiscount({
    @required this.feeResult,
    @required this.onTopChanged,
    @required this.onPcRoomChanged,
    @required this.onAddDiscountChanged,
  }); 

  @override
  _InputPlayerTradeDiscount createState() => _InputPlayerTradeDiscount();
}

class _InputPlayerTradeDiscount extends State<InputPlayerTradeDiscount> {

  TextEditingController discountRateController;

  @override
  void initState() {
    super.initState();
    discountRateController = TextEditingController();
  }

  @override
  void dispose() {
    if ( discountRateController != null ) {
      discountRateController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 4.0, bottom: 4.0),
      decoration: BoxDecoration(
        //color: Colors.grey[900],
        border: Border.all(width: 1, color: Colors.grey[300]),
        borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child: Column(
        children: [
          //----------------------------------------------
          SwitchListTile(
            value: widget.feeResult.isCheckedPcRoom?? false,
            title: Text(
              "프리미엄 PC방 기본수수료 30% 할인",
              style: TextStyle(fontSize: 13.0),
            ),
            contentPadding: EdgeInsets.all(0.0),
            onChanged: widget.onPcRoomChanged,
          ),
          //----------------------------------------------
          SwitchListTile(
            value: widget.feeResult.isCheckedTop?? false,
            contentPadding: EdgeInsets.all(0.0),
            title: Text(
              "TOP CLASS 기본수수료 20% 할인",
              style: TextStyle(fontSize: 13.0),
            ),
            onChanged: widget.onTopChanged,
          ),
          //----------------------------------------------
          Row(
            children: [
              Text(
                "추가 할인율 입력",
                style: TextStyle(fontSize: 13.0),
              ),
              //-----------------------------
              SizedBox(width: 20.0,),
              //-----------------------------
              Expanded(
                child: Form(
                  autovalidateMode: AutovalidateMode.always,
                  child: discountRateField()
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0,),
        ]
      ),
    );
  }  

  Widget discountRateField() {
    return TextFormField(
      autofocus: false,
      controller: discountRateController,
      keyboardType: TextInputType.number,
      validator: validateDiscountRate,      
      onChanged: (value) {
        //widget.feeResult.discountRate = int.tryParse(value) ?? 0;
        int rate = int.tryParse(value) ?? 0;
        widget.onAddDiscountChanged(rate);
      },
      textAlign: TextAlign.end,
      decoration: InputDecoration(
        suffixText: "%",
        // border: OutlineInputBorder(
        //   borderSide: BorderSide(),
        // ),
        //hintText: "추가할인율을 입력하세요",
        hintStyle: const TextStyle(color: Color.fromRGBO(142, 142, 147, 1))
      ),
    );
  }

  String validateDiscountRate(String value) {
    int rate = int.tryParse(value) ?? 0;
    if ( rate > 100) {
      return '최대 할인율은 100입니다.';
    }

    return null;
  }



}