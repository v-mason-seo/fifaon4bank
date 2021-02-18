import 'package:fifa_on4_bank/ui/screen/player_detail_info_page/model/purchase_info.dart';

class MinMaxTradePrice {
  int spid;
  String name;
  int grade;
  PurchaseInfo purchaseInfo;

  MinMaxTradePrice({
    this.spid,
    this.name,
    this.grade,
    this.purchaseInfo,
  });

  MinMaxTradePrice.fromJson(Map<String, dynamic> json) {
    spid = json['spid'];
    name = json['name'];
    grade = json['grade'];
    purchaseInfo = json['purchaseInfo'] != null 
        ? PurchaseInfo.fromJson(json['purchaseInfo']) 
        : PurchaseInfo();
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['spid'] = spid;
    data['name'] = name;
    data['grade'] = grade;
    data['purchaseInfo'] = purchaseInfo;
    
    return data;
  }
}