import 'package:fifa_on4_bank/core/constant/player_grade_color.dart';
import 'package:fifa_on4_bank/core/util/common_util.dart';
import 'package:fifa_on4_bank/core/util/date_util.dart';
import 'package:fifa_on4_bank/core/util/value_util.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_table/my_player/model/current_price.dart';
import 'package:fifa_on4_bank/ui/widget/player_grade_badge.dart';
import 'package:fifa_on4_bank/ui/widget/rounded_corner_container.dart';
import 'package:flutter/material.dart';

class CurrentPriceByGradeCard extends StatelessWidget {

  final List<CurrentPrice> currentPriceList;

  CurrentPriceByGradeCard({
    this.currentPriceList,
  });

  @override
  Widget build(BuildContext context) {

    if ( CommonUtil.isEmpty(currentPriceList)) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

     Color textColor = Theme.of(context).textTheme.headline1.color;
     String updated = currentPriceList.length > 0
      ? DateUtils.getDateStringFromString(currentPriceList[0].updated, format: "yyyy-MM-dd HH:mm")
      : "";

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            //---------------------------------
            ...List.generate(currentPriceList.length, (index) {
                CurrentPrice price = currentPriceList[index];
                return _buildCurrentPrice(
                  price.grade, 
                  "${ValueUtil.getCurrencyFormatFromInt(price.presentPrice)}  BP",
                  price.amountMultiple
                );
              } 
            ),
            //---------------------------------
            Divider(),
            //---------------------------------
            _buildRow("업데이트 시간", updated, textColor, textColor),
            //---------------------------------
          ],
        ),
      )
    );
  }

  Widget _buildCurrentPrice(int grade, String price, double multiple) {
    return Padding(
      padding: const EdgeInsets.only(left: 1.0, right: 1.0, top: 1.0, bottom: 1.0),
      child: Row(
          children: [
            //-----------------------------------
            PlayerGradeBadge(
              text: "$grade",
              background: PlayerGradeColor.getColor(grade),
              fontColor : PlayerGradeColor.getFontColor(grade)
            ),
            //-----------------------------------
            if ( multiple != null )
            RoundedCornerContainer(
              text: "X ${multiple.toStringAsFixed(2)}",
              backgroundColor: Colors.blueGrey,
              foreColor: Colors.white,
            ),
            //-----------------------------------
            Spacer(),
            //-----------------------------------
            Text(
              price,
              style: TextStyle(
                //color: Theme.of(context).textTheme.caption.color,
                color: grade == 1 
                  ? Colors.grey
                  : PlayerGradeColor.getColor(grade)
              ),
            ),
            //-----------------------------------
          ],
        ),
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