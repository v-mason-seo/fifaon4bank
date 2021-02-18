import 'dart:convert';

import 'package:fifa_on4_bank/core/util/common_util.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_table/my_player/model/player_trade_table_content.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalApi {

  Future<List<PlayerTradeTableContent>> loadPlayerTradeTableData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var jsonData = prefs.getString("player_trade_table_data_list");
// 컨버전 테스트 json
//     String jsonData = 
//           '''
//           [{
//         "id": 136,
//         "isRowChecked": false,
//         "player": {
//             "id": 216192387,
//             "name": "치로 임모빌레",
//             "season": null
//         },
//         "grade": 1,
//         "purchaseAmount": 2840000,
//         "sellAmount": 0,
//         "minAmountFromAddDiscount": [{
//                 "addDiscountRate": 25
//             }
//         ]
//     }, {
//         "id": 135,
//         "isRowChecked": false,
//         "player": {
//             "id": 216192563,
//             "name": "베른트 레노",
//             "season": null
//         },
//         "grade": 1,
//         "purchaseAmount": 3540000,
//         "sellAmount": 0,
//         "minAmountFromAddDiscount": [{
//                 "addDiscountRate": 25
//             }
//         ]
//     }
// ]
//           ''';
    // print(jsonData);

    if ( CommonUtil.isEmpty(jsonData)) {
      return [];
    }

    List jsonList = json.decode(jsonData);   
    List<PlayerTradeTableContent> list = jsonList.map((e) => PlayerTradeTableContent.fromJson(e)).toList();

    return list;        
  }


  savePlayerTradeTableDataList(List<PlayerTradeTableContent> items) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("player_trade_table_data_list", json.encode(items));

  }


  deletePlayerTradeTableDataList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("player_trade_table_data_list");
  }


  ///
  /// 선수 코멘트 작성자명을 저장한다.
  ///
  saveWriterName(String wirterName) async {

    String key = "writer_name";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, wirterName);
  }


  ///
  /// 선수 코멘트 작성자명을 불러온다.
  ///
  Future<String> loadWriterName() async {
    String key = "writer_name";
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String writerName = prefs.getString(key);

    //등록된 닉네임이 없으면 검색한 감독명을 불러온다.
    if ( CommonUtil.isEmpty(writerName)) {
      writerName = "";
      String suggestionsKey = "nickname_suggestions";  
      List<String> suggestions = prefs.getStringList(suggestionsKey);
      if ( CommonUtil.isNotEmpty(suggestions)) {
        writerName = suggestions[0];
      }
    }

    return writerName;
  }


  ///
  /// 감독명 자동 추천 검색어를 저장한다.
  ///
  saveNicknameSuggestions(String nickname) async {
    String suggestionsKey = "nickname_suggestions";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> suggestions = prefs.getStringList(suggestionsKey) ?? [];

    if ( suggestions.length > 0 ) {
      suggestions.removeWhere((element) => CommonUtil.isEmpty(element));
      suggestions = suggestions.toSet().toList();
      suggestions = suggestions.take(10).toList();
    }

    suggestions.insert(0, nickname);
    await prefs.setStringList(suggestionsKey, suggestions);
  }


  ///
  /// 감독명 자동 추천 검색어를 삭제한다.
  ///
  deleteNicknameSuggestions(String nickname) async {
    String suggestionsKey = "nickname_suggestions";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var suggestions = prefs.getStringList(suggestionsKey) ?? [];

    suggestions.remove(nickname);
    await prefs.setStringList(suggestionsKey, suggestions);
  }


  ///
  /// 감독명 자동 추천 검색어를 불러온다.
  ///
  loadNicknameSuggestions() async {
    String suggestionsKey = "nickname_suggestions";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var suggestions = prefs.getStringList(suggestionsKey) ?? [];

    return suggestions;    
  }


  ///
  /// 선수 코멘트 신고한건을 조회한다.
  ///
  Future<String> loadReportedCommentIdList() async {
    String key = "reported_comment_id_list";
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(key);
  }


  ///
  /// 선수 코멘트 신고한건은 아이디를 저장한다.
  ///
  saveReportedCommentId(int commentId) async {

    String key = "reported_comment_id_list";
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String reportedCommentIdList = await loadReportedCommentIdList() ?? "";
    prefs.setString(key, reportedCommentIdList + ",$commentId");
  }
}