import 'package:fifa_on4_bank/core/model/fifa_meta/player.dart';
import 'package:fifa_on4_bank/core/model/fifa_meta/player_trade_record.dart';

class SearchPlayerTradeRecord {
  Player player;
  //Season season;

  //거래일자 (ex. 2019-05-13T18:03:10) 
  //구매(buy)일 - 구매 등록 시점 
  //판매(sell)일 - 판매 완료 시점 
  String tradeDate;

  //	거래 고유 식별자 
  String saleSn;

  //거래 선수 강화 등급 
  int grade;

  //	거래 선수 가치(BP) 
  int value;

  // 선택 여부
  bool isSelected = false;

  String nickname;


  SearchPlayerTradeRecord.fromPlayerTradeRecord(PlayerTradeRecord record)
  : tradeDate = record.tradeDate,
    grade = record.grade,
    saleSn = record.saleSn,
    value = record.value
    ;


  Map<String, dynamic> toPurchaseJson() => {
   'nickname' : nickname,
   'tradeDate': tradeDate,
   'saleSn': saleSn,
   'spid': player.id,
   'grade': grade,
   'value': value,
  };
}