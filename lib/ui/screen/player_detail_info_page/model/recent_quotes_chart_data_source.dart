import 'package:fifa_on4_bank/core/util/value_util.dart';
import 'package:fl_chart/fl_chart.dart';

class RecentQuotesChartDataSource {

  final List<String> times;
  final List<int> prices;
  List<FlSpot> chartData;
  String maxHorizontalValue;
  String minHorizontalValue;
  double maxVerticalValue;
  double minVerticalValue;


  RecentQuotesChartDataSource({
    this.times,
    this.prices,
  });

  void initData() {
    chartData = [];

    for(int i=0; i < times.length; i++) {
      var item = FlSpot(i.toDouble(), prices[i].toDouble());
      chartData.add(item);
    }

    List cloneTimes = List.from(times);
    List clonePrices = prices.map((element) {
      return element;
    }).toList();
    clonePrices.sort();

    maxHorizontalValue = cloneTimes.last;
    minHorizontalValue = cloneTimes.first;

    maxVerticalValue = clonePrices.last.toDouble();
    minVerticalValue = clonePrices.first.toDouble();
  }


  String getTitle(double value) {

    int index = value.toInt();
    if ( value.toInt() % 4 == 0 ) {
      return times[index];
    }

    return "";
    
  }


  String getLeftTitle(double value) {

    var index = value - minVerticalValue;
    if ( index % 3 == 0.0) {
      //return value.toInt().toString();
      int amount = value.toInt();

      if ( amount >= 100000000) {
        double divAmount = amount / 100000000;
        return "${divAmount.toStringAsFixed(1)}억";
      }  else if ( amount >= 10000) {
        double divAmount = amount / 10000;
        return "${divAmount.toStringAsFixed(1)}만";
      } else if ( amount >= 1000) {
        double divAmount = amount / 1000;
        return "${divAmount.toStringAsFixed(1)}천";
      }

      return value.toStringAsFixed(0);
    }

    return "";
  }


  String getFormattedPrice(int index) {
    if ( index < 0) {
      return "-";
    }

    int price = prices[index];
    return ValueUtil.getCurrencyFormatFromInt(price);
  }

}