import 'dart:convert';

import 'package:fifa_on4_bank/core/db/table_model/favorite_player.dart';
import 'package:fifa_on4_bank/core/db/table_model/trade_record.dart';
import 'package:fifa_on4_bank/core/model/fifa_meta/player.dart';
import 'package:fifa_on4_bank/core/model/fifa_meta/player_trade_record.dart';
import 'package:fifa_on4_bank/core/model/fifa_meta/season.dart';
import 'package:fifa_on4_bank/core/util/common_util.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_table/my_player/model/current_price.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_table/my_player/model/minSalesAmount.dart';
import 'package:fifa_on4_bank/ui/screen/search_player_trade_record/model/search_player_trade_record.dart';

class PlayerTradeTableContent {
  int id;
  bool isRowChecked;
  Player player;
  int grade;
  int purchaseAmount; 
  CurrentPrice currentPrice;
  int sellAmount;
  MinSalesAmount minSalesAmount;
  List<MinSalesAmount> minAmountFromAddDiscount = [];
  String tradeDate;
  

  List<int> getDynamicDiscountList() {

    if ( CommonUtil.isNotEmpty(minAmountFromAddDiscount) ) {
      return minAmountFromAddDiscount.map((e) => e.addDiscountRate).toList();
    }

    return [];
  }


  factory PlayerTradeTableContent.clone(PlayerTradeTableContent obj) {
    var jsonData = json.encode(obj);
    var decodeData = json.decode(jsonData);

    return PlayerTradeTableContent.fromJson(decodeData);
  }


  PlayerTradeTableContent.fromFavoritePlayer(FavoritePlayer item) {
    id = int.parse(item.playerId.toString() + item.playerGrade.toString());
    isRowChecked = false;
    player = Player(
      id: item.playerId,
      name: item.playerName,
      season: Season(
        seasonId: item.seasonId,
        className: item.className,
        seasonImg: item.seasonImg,
      )
    );
    grade = item.playerGrade;
    purchaseAmount = 0;
    sellAmount = 0;
    tradeDate = "";

    if ( CommonUtil.isNotEmpty(item.additionalDiscount)) {
      List dynamicList = item.additionalDiscount.split(",");
      dynamicList.forEach((element) {
        int discountRate = int.tryParse(element);
        minAmountFromAddDiscount.add(MinSalesAmount(addDiscountRate: discountRate));
      });
    }
  }


  PlayerTradeTableContent.fromTradeRecord(TradeRecord record) {
    id = record.id;
    isRowChecked = false;
    player = Player(
      id: record.playerId,
      name: record.playerName,
      season: Season(
        seasonId: record.seasonId,
        className: record.className,
        seasonImg: record.seasonImg,
      )
    );
    grade = record.playerGrade;
    purchaseAmount = record.purchaseAmount;
    sellAmount = 0;
    tradeDate = record.tradeDate;

    if ( CommonUtil.isNotEmpty(record.additionalDiscount)) {
      List dynamicList = record.additionalDiscount.split(",");
      dynamicList.forEach((element) {
        int discountRate = int.tryParse(element);
        minAmountFromAddDiscount.add(MinSalesAmount(addDiscountRate: discountRate));
      });
    }
  }


  PlayerTradeTableContent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isRowChecked = json['isRowChecked'];
    player = Player.fromJson(json['player']);
    grade = json['grade'];
    purchaseAmount = json['purchaseAmount'];
    sellAmount = json['sellAmount'];
    tradeDate = json['tradeDate']??"";
    if (json['minAmountFromAddDiscount'] != null) {
      minAmountFromAddDiscount = new List<MinSalesAmount>();
      json['minAmountFromAddDiscount'].forEach((v) {
        minAmountFromAddDiscount.add(MinSalesAmount.fromJson(v));
      });
    }
  }
    


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['isRowChecked'] = isRowChecked;
    data['player'] = player.toJson();
    data['grade'] = grade;
    data['purchaseAmount'] = purchaseAmount;
    data['sellAmount'] = sellAmount;
    data['tradeDate'] = tradeDate??"";

    if (this.minAmountFromAddDiscount != null) {
      data['minAmountFromAddDiscount'] =
          this.minAmountFromAddDiscount.map((v) => v.toJson()).toList();
    }
    return data;
    
  }


  PlayerTradeTableContent({
    this.isRowChecked = false,
    this.player,
    this.grade = 1,
    this.purchaseAmount = 0,
    this.sellAmount = 0,
    this.tradeDate = "",
  }) : this.minSalesAmount = MinSalesAmount();

  PlayerTradeTableContent.from(PlayerTradeRecord record)
    : isRowChecked = false,
      player = Player(id: record.spid),
      grade = record.grade,
      purchaseAmount = record.value,
      sellAmount = record.value,
      tradeDate = record.tradeDate??""
      ;

  PlayerTradeTableContent.fromSearchPlayerTradeRecord(SearchPlayerTradeRecord item)
    : isRowChecked =false,
      player = item.player,
      grade = item.grade,
      purchaseAmount = item.value,
      sellAmount = item.value,
      tradeDate = item.tradeDate;
}