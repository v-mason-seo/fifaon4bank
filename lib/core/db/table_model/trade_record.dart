import 'package:fifa_on4_bank/core/util/common_util.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_table/my_player/model/player_trade_table_content.dart';
import 'package:fifa_on4_bank/ui/screen/search_player_trade_record/model/search_player_trade_record.dart';

class TradeRecord {
  int id;
  int playerId;
  String playerName;
  int playerGrade;
  int seasonId;
  String className;
  String seasonImg;
  int purchaseAmount;
  String additionalDiscount;
  String tradeDate;
  String created;


  TradeRecord({
    this.id,
    this.playerId,
    this.playerName,
    this.playerGrade,
    this.seasonId,
    this.className,
    this.seasonImg,
    this.purchaseAmount,
    this.additionalDiscount,
    this.tradeDate = "",
  });


  @override
  String toString() {
    return """TradeRecord(
      id: $id, 
      playerId: $playerId, 
      playerName: $playerName,
      playerGrade: $playerGrade,
      seasonId: $seasonId,
      className: $className,
      seasonImg: $seasonImg,
      purchaseAmount: $purchaseAmount,
      additionalDiscount: $additionalDiscount,
      tradeDate: $tradeDate,
      created: $created,
    )""";
  }

  TradeRecord.fromSearchPlayerTradeRecord(SearchPlayerTradeRecord record) {
    playerId = record.player.id;
    playerName = record.player.name;
    playerGrade = record.grade;
    seasonId = record.player?.season?.seasonId;
    className = record.player?.season?.className;
    seasonImg = record.player?.season?.seasonImg;
    purchaseAmount = record.value;
    tradeDate = record.tradeDate;
  }


  TradeRecord.fromPlayerTradeTableContent(PlayerTradeTableContent tableContent) {
    id = tableContent.id;
    playerId = tableContent.player.id;
    playerName = tableContent.player.name;
    playerGrade = tableContent.grade;
    seasonId = tableContent.player?.season?.seasonId;
    className = tableContent.player?.season?.className;
    seasonImg = tableContent.player?.season?.seasonImg;
    purchaseAmount = tableContent.purchaseAmount;
    tradeDate = tableContent.tradeDate??"";

    List<int> dynamicDiscount = tableContent.getDynamicDiscountList();
    if ( CommonUtil.isNotEmpty(dynamicDiscount)) {
      additionalDiscount = dynamicDiscount.join(",");
    }
  }


  TradeRecord.fromMap(Map<String, dynamic> maps) {

    id = maps['id'];
    playerId = maps['player_id'];
    playerName = maps['player_name'];
    playerGrade = maps['player_grade'];
    seasonId = maps["season_id"];
    className = maps["class_name"];
    seasonImg = maps["season_img"];
    purchaseAmount = maps['purchase_amount'];
    additionalDiscount = maps['additional_discount'];
    tradeDate = maps['trade_date'];
    created = maps['created'];
  }


  Map<String, dynamic> toMap() {

    return {
      'id': id,
      'player_id': playerId,
      'player_name': playerName,
      'player_grade': playerGrade,
      'season_id': seasonId,
      'class_name': className,
      'season_img': seasonImg,
      'purchase_amount' : purchaseAmount,
      //'additional_discount': additionalDiscount?.map((e) => "$e,"),
      'additional_discount': additionalDiscount,
      'trade_date': tradeDate,
      //'created' : created,
    };
  }

  



}