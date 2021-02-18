import 'package:fifa_on4_bank/core/util/value_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';


class InputPlayerTradeAmount extends StatefulWidget {

  //final PlayerTradeTableContent playerTradeTableData;
  final int saleAmount;
  final ValueChanged<String> onChanged;

  InputPlayerTradeAmount({
    this.saleAmount,
    @required this.onChanged
  });

  _InputPlayerTradeAmountState createState() => _InputPlayerTradeAmountState();
}


class _InputPlayerTradeAmountState extends State<InputPlayerTradeAmount> {

  TextEditingController _sellPriceController;

  @override
  void initState() {
    super.initState();
    _sellPriceController = TextEditingController();
    if ( widget.saleAmount != null ){
      _sellPriceController.text = ValueUtil.getCurrencyFormatFromInt(widget.saleAmount);
    }
  }

  @override

  @override
  void dispose(){
    _sellPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 4.0, bottom: 4.0),
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        //border: Border.all(width: 1),
        borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child: Row(
        children: [
          Icon(Icons.attach_money, size: 32.0),
          SizedBox(width: 12.0,),
          Expanded(
            child: TextField(
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                NumericTextFormatter()
              ],
              textAlign: TextAlign.end,
              controller: _sellPriceController,
              decoration: InputDecoration(
                border: InputBorder.none
              ),
              keyboardType: TextInputType.number,
              onChanged: widget.onChanged,
            ),
          ),
        ],
      ),
    );
  }
}




class NumericTextFormatter extends TextInputFormatter {
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, TextEditingValue newValue) {
    
    if (newValue.text.length == 0) {
     
      return newValue.copyWith(text: '');

    } else if (newValue.text.compareTo(oldValue.text) != 0) {

      int selectionIndexFromTheRight = newValue.text.length - newValue.selection.end;
      final f = new NumberFormat("#,###");
      int num = int.parse(newValue.text.replaceAll(f.symbols.GROUP_SEP, ''));
      final newString = f.format(num);
      
      return new TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(offset: newString.length - selectionIndexFromTheRight),
      );

    } else {

      return newValue;

    }
  }
}