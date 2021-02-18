import 'package:fifa_on4_bank/core/util/date_util.dart';
import 'package:fifa_on4_bank/core/util/value_util.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_table/my_player/model/current_price.dart';
import 'package:flutter/material.dart';

class CurrentPriceCard extends StatelessWidget {

  final CurrentPrice currentPrice;

  CurrentPriceCard({
    this.currentPrice,
  });

  @override
  Widget build(BuildContext context) {

    Color textColor = Theme.of(context).textTheme.headline1.color;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildRow("최저가", "${ValueUtil.getCurrencyFormatFromInt(currentPrice.minPrice)} BP", textColor, Colors.blue[300]),
            Divider(),
            _buildRow("현재가", "${ValueUtil.getCurrencyFormatFromInt(currentPrice.presentPrice)} BP", textColor, textColor),
            Divider(),
            _buildRow("최고가", "${ValueUtil.getCurrencyFormatFromInt(currentPrice.maxPrice)} BP", textColor, Colors.red[300]),
            Divider(),
            _buildRow("업데이트 시간", DateUtils.getDateStringFromString(currentPrice.updated, format: "yyyy-MM-dd HH:mm"), textColor, textColor),
            Divider(),
          ],
        ),
      )
    );
  }

  Widget _buildRow(String left, String right, Color leftColor, Color rightColor) {
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            left ?? "-",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: leftColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            right ?? "-",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: rightColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}