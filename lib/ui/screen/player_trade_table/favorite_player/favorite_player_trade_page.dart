import 'package:fifa_on4_bank/ui/screen/player_trade_table/favorite_player/favorite_player_trade_provider.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_table/favorite_player/favorite_player_trade_table.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritePlayerTradePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Consumer<FavoritePlayerTradeProvider>(
      builder: (context, model, child) {
        if ( model.busy) {
          return Center(
              child: CircularProgressIndicator(),
            );
        }

        return FavoritePlayerTradeTable();

        ///
        /// todo - 나중에 옵션으로 테이블형 리스트형 선택할 수 있도록 할 예정
        /// 리스트형 타입
        ///
        /*
        return SingleChildScrollView(
          child: Container(
            child: FavoritePlayerTradeListView(
              items: model.items,
                expansionCallback: (int index, bool isExpanded) {
                  model.changeExpanded(index);
                }
              ),
            ),
        );
        */
      },
    );
  }
}