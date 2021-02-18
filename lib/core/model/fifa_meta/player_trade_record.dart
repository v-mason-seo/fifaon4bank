class PlayerTradeRecord {
  
  //거래일자 (ex. 2019-05-13T18:03:10) 
  //구매(buy)일 - 구매 등록 시점 
  //판매(sell)일 - 판매 완료 시점 
  String tradeDate;

  //	거래 고유 식별자 
  String saleSn;

  //	선수 고유 식별자 (/metadata/spid API 참고) 
  int spid;

  //거래 선수 강화 등급 
  int grade;

  //	거래 선수 가치(BP) 
  int value;

  //선수이름은 넥슨에서 제공해주지 않는다.
  //선수 spid 만 넘겨주기 때문에 찾아야 한다.
  String playerName;

  bool isSelected = false;

  PlayerTradeRecord({
    this.tradeDate,
    this.saleSn,
    this.spid,
    this.grade,
    this.value
  });


  PlayerTradeRecord.fromJson(Map<String, dynamic> json)
    : tradeDate = json['tradeDate'],
      saleSn = json['saleSn'],
      spid = json['spid'],
      grade = json['grade'],
      value = json['value'];


  Map<String, dynamic> toJson() => {
    'tradeDate': tradeDate,
    'saleSn': saleSn,
    'spid': spid,
    'grade': grade,
    'value': value
  };
}