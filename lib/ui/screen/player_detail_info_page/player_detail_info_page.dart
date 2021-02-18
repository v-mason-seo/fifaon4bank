import 'package:fifa_on4_bank/core/model/fifa_meta/player.dart';
import 'package:fifa_on4_bank/ui/base_widget/base_widget.dart';
import 'package:fifa_on4_bank/ui/screen/player_detail_info_page/player_detail_info_provider.dart';
import 'package:fifa_on4_bank/ui/screen/player_detail_info_page/widget/current_price_by_grade_card.dart';
import 'package:fifa_on4_bank/ui/screen/player_detail_info_page/widget/current_price_card.dart';
import 'package:fifa_on4_bank/ui/screen/player_detail_info_page/widget/min_max_trade_price_card.dart';
import 'package:fifa_on4_bank/ui/screen/player_detail_info_page/widget/recent_quotes_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayerDetailInfoPage extends StatelessWidget {

  final Player player;
  final int playerGrade;
  final int myPurchaseAmout;

  PlayerDetailInfoPage({
    Key key,
    this.player,
    this.playerGrade,
    this.myPurchaseAmout = 0,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    
    return BaseWidget<PlayerDetailInfoProvider>(
      model: PlayerDetailInfoProvider(
        player: player,
        playerGrade: playerGrade,
      ),
      onModelReady: (model) => model.loadData(),
      builder: (context, model, child) {

        if ( model.busy) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            return await Future.delayed(Duration(seconds: 1));
          },
          child: buildDetailInfoListView(),
        );
      },
    );
  }

  Widget buildDetailInfoListView() {

    return Consumer<PlayerDetailInfoProvider>(
      builder: (context, model, child) {

        return ListView(
          children: [
            //-----------------------------
            _buildTitle("최근시세"),
            CurrentPriceCard(
              currentPrice: model.currentPrice,
            ),
            //-----------------------------
            _buildTitle("최근시세 (그래프)"),
            RecentQuotesLineChart(currentPrice: model.currentPrice),
            //-----------------------------
            _buildTitle("등급별 현재시세"),
            CurrentPriceByGradeCard(
              currentPriceList: model.currentPriceByGrade,
            ),
            //-----------------------------
            _buildTitle("최저최고"),
            MinMaxTradePriceCard(
              minMaxTradePrice: model.minMaxTradePrice,
              myPurchaseAmount: myPurchaseAmout,
            ),
            //-----------------------------
          ],
        );
      },
    );    
  }

  Widget _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 28,
        bottom: 12,
        left: 12,
        right: 12,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold
        )
        ,
      ),
    );
  }
}