import 'package:fifa_on4_bank/ui/screen/player_detail_info_page/model/recent_quotes_chart_data_source.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_table/my_player/model/current_price.dart';
import 'package:fifa_on4_bank/ui/widget/card/rounded_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';


class RecentQuotesLineChart extends StatefulWidget {

  final CurrentPrice currentPrice;

  RecentQuotesLineChart({
    this.currentPrice,
  });

  @override
  _RecentQuotesLineChartState createState() => _RecentQuotesLineChartState();
}

class _RecentQuotesLineChartState extends State<RecentQuotesLineChart> {

  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  bool showAvg = false;
  RecentQuotesChartDataSource dsAmount;

  @override
  void initState() {
    super.initState();

    dsAmount = RecentQuotesChartDataSource(
      prices: widget.currentPrice.prices,
      times: widget.currentPrice.times
    )..initData();
  }


  @override
  Widget build(BuildContext context) {

    return RoundedCard(
      backgroundColor: Color(0xff232d37),
      childWidget: LineChart(
        mainData()
      ),
    );
  }

  LineChartData mainData() {
    return LineChartData(
      //----------------------------------------
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              final flSpot = barSpot;
              int index = flSpot.x.toInt();
              return LineTooltipItem(
                "${dsAmount.getFormattedPrice(index)} BP",
                const TextStyle(color: Colors.black),
              );
            }).toList();
          }
        ),
      ),
      //----------------------------------------
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      //----------------------------------------
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          rotateAngle: -45,
          showTitles: true,
          reservedSize: 16,
          getTextStyles: (value) => 
            const TextStyle(color: Color(0xff68737d), fontSize: 12),
          getTitles: dsAmount.getTitle,
          margin: 24
        ),
        //==============
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) =>const TextStyle(
            color: Color(0xff67727d),
            fontSize: 12,
          ),
          getTitles : dsAmount.getLeftTitle,
          reservedSize: 42,
          margin: 12
        ),
      ),
      //----------------------------------------
      borderData: FlBorderData(
        show: true,
        border: Border.all(
          color: const Color(0xff37434d),
          width: 1
        ),
      ),
      minX: 0,
      maxX: (dsAmount.times.length-1).toDouble(),
      minY: dsAmount.minVerticalValue,
      maxY: dsAmount.maxVerticalValue,
      //----------------------------------------
      lineBarsData: [
        LineChartBarData(
          //==============
          spots: dsAmount.chartData,
          //==============
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          )
          //==============
        ),
      ],
      //----------------------------------------
    );
  }
}