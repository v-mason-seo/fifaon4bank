import 'package:fifa_on4_bank/core/util/date_util.dart';
import 'package:fifa_on4_bank/core/util/value_util.dart';
import 'package:fifa_on4_bank/ui/screen/player_detail_info_page/model/max_min_trade_price.dart';
import 'package:fifa_on4_bank/ui/screen/player_detail_info_page/model/purchase_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MinMaxTradePriceCard extends StatelessWidget {

  final MinMaxTradePrice minMaxTradePrice;
  final int myPurchaseAmount;

  MinMaxTradePriceCard({
    this.minMaxTradePrice,
    this.myPurchaseAmount,
  });

  @override
  Widget build(BuildContext context) {

    PurchaseInfo purchaseInfo = minMaxTradePrice.purchaseInfo ?? PurchaseInfo();
    Color accentColor = Theme.of(context).accentColor.withAlpha(180);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            //------------------------------------------------------------
            _buildRow(
              purchaseInfo.minNickname, 
              "감독", 
              purchaseInfo.maxNickname, 
              Theme.of(context).textTheme.headline1.color,
              accentColor,
              Theme.of(context).textTheme.headline1.color),
            //------------------------------------------------------------
            Divider(),
            //------------------------------------------------------------
            _buildRow(
              ValueUtil.getCurrencyFormatFromInt(purchaseInfo.minValue), 
              "금액", 
              ValueUtil.getCurrencyFormatFromInt(purchaseInfo.maxValue),
              Theme.of(context).textTheme.headline1.color,
              accentColor,
              Theme.of(context).textTheme.headline1.color),
            //------------------------------------------------------------
            Divider(),
            //------------------------------------------------------------
            _buildDiffAmountRow(
              ValueUtil.getCurrencyFormatFromInt((myPurchaseAmount ?? 0 - purchaseInfo.minValue ?? 0)), 
              "차액", 
              ValueUtil.getCurrencyFormatFromInt((purchaseInfo.maxValue ?? 0 - myPurchaseAmount ?? 0)), 
              Colors.blue[300],
              accentColor,
              Colors.red[300]),
            //------------------------------------------------------------
            Divider(),
            //------------------------------------------------------------
            _buildRow(
              DateUtils.getDateStringFromString(purchaseInfo.minTradeDate), 
              "거래일자", 
              DateUtils.getDateStringFromString(purchaseInfo.maxTradeDate), 
              Theme.of(context).textTheme.headline1.color,
              accentColor,
              Theme.of(context).textTheme.headline1.color,),
            //------------------------------------------------------------
          ],
        ),
      )
    );
  }

  Widget _buildRow(String left, String middle, String right, Color leftColor, Color middleColor, Color rightColor) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              left ?? "-",
              textAlign: TextAlign.left,
              style: TextStyle(
                color: leftColor,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              middle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: middleColor,
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              right ?? "-",
              textAlign: TextAlign.right,
              style: TextStyle(
                color: rightColor,
              ),
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildDiffAmountRow(String left, String middle, String right, Color leftColor, Color middleColor, Color rightColor) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              children: [
                Icon(
                  Icons.arrow_drop_down,
                  color: leftColor,
                ),
                SizedBox(width: 8,),
                Text(
                  left,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: leftColor,
                    fontSize: getFontSize(left)
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              middle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: middleColor,
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.arrow_drop_up,
                  color: rightColor,
                ),
                SizedBox(width: 8,),
                Text(
                  right,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: rightColor,
                    fontSize: getFontSize(right)
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  double getFontSize(String text) {
    if ( text == null )
      return 14.0;
      
    if ( text.replaceAll(",", "").length > 12) {
      return 11.0;
    } else if ( text.length > 11) {
      return 12.0;
    }

    return 14.0;
  }
}