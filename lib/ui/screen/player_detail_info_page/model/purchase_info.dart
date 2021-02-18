class PurchaseInfo {
  String maxNickname;
  int maxValue;
  String maxTradeDate;
  String minNickname;
  int minValue;
  String minTradeDate;

  PurchaseInfo({
    this.maxNickname = "",
    this.maxValue = 0,
    this.maxTradeDate = "",
    this.minNickname = "",
    this.minValue = 0,
    this.minTradeDate = "",
  });


  PurchaseInfo.fromJson(Map<String, dynamic> json) {
    maxNickname = json['maxNickname'];
    maxValue = json["maxValue"];
    maxTradeDate = json["maxTradeDate"];
    minNickname = json["minNickname"];
    minValue = json["minValue"];
    minTradeDate = json["minTradeDate"];
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['maxNickname'] = maxNickname;
    data['maxValue'] = maxValue;
    data['maxTradeDate'] = maxTradeDate;
    data['minNickname'] = minNickname;
    data['minValue'] = minValue;
    data['minTradeDate'] = minTradeDate;

    return data;
  }
}