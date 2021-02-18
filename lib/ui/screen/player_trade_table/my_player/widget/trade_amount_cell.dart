import 'package:fifa_on4_bank/core/util/value_util.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_table/my_player/model/minSalesAmount.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TradeAmountCell extends StatelessWidget {
  
  final MinSalesAmount minSalesAmount;
  final double width;
  final bool isMultiColor;

  TradeAmountCell({
    this.minSalesAmount,
    this.width,
    this.isMultiColor = false
  });
  
  @override
  Widget build(BuildContext context) {

    // Color color1 = Color(0xfff6f7d4);
    // Color color2 = Color(0xffd2f6c5);
    // Color color3 = Color(0xff99f3bd);

    Color color1 = Colors.lime[200];
    Color color2 = Colors.deepPurple[200];
    Color color3 = Colors.cyan[400];

    return Container(
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.0),
            child: Text(
              "${ValueUtil.getCurrencyFormatFromInt(minSalesAmount.minSalesAmountOfTop)}",
              style: TextStyle(
                color: isMultiColor ? color1 : null,
                fontSize: getFontSize("${minSalesAmount.minSalesAmountOfTop}"),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.0),
            child: Text(
              "${ValueUtil.getCurrencyFormatFromInt(minSalesAmount.minSalesAmountOfPcRoom)}",
              style: TextStyle(
                color: isMultiColor ? color2 : null,
                fontSize: getFontSize("${minSalesAmount.minSalesAmountOfPcRoom}"),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.0),
            child: Text(
              "${ValueUtil.getCurrencyFormatFromInt(minSalesAmount.minSalesAmountOfTopAndPcRoom)}",
              style: TextStyle(
                color: isMultiColor ? color3 : null,
                fontSize: getFontSize("${minSalesAmount.minSalesAmountOfTopAndPcRoom}"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double getFontSize(String text) {
    if ( text.length > 12) {
      return 12.0;
    } else if ( text.length > 11) {
      return 13.0;
    }

    return 14.0;
  }
}