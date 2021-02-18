import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fifa_on4_bank/core/api/player_value_count_type.dart';
import 'package:fifa_on4_bank/core/model/fifa_meta/player.dart';
import 'package:fifa_on4_bank/core/util/common_util.dart';
import 'package:fifa_on4_bank/ui/screen/player_comment/player_comment.dart';
import 'package:fifa_on4_bank/ui/screen/player_detail_info_page/model/max_min_trade_price.dart';
import 'package:fifa_on4_bank/ui/screen/player_news/model/player_news.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_table/my_player/model/current_price.dart';

class FifaOn4BankApi {

  Dio dio; 

  FifaOn4BankApi() {
    dio = new Dio();
    dio.options.baseUrl = "http://www.api.fifameta.com/fifa/";
  }


  Future<List<Player>> getPlayerByName(String name) async {

    try {
      Response response = await dio.get(
        "players", queryParameters: {
          "name": name
        }
      );

      List<dynamic> parsedList = response.data;
      List<Player> players = parsedList.map((e) => Player.fromJson(e)).toList();

      return players;

    } catch(e) {
      //print(e);
      throw("[getUser] 데이터가 없습니다.");
    }
  }


  getPlayerById(int id) async {
    try {
      Response response = await dio.get("players", queryParameters: {
        "id": id
      });

      // response.data 가 Map 형태이기 때문에 아래코드는 실행 안해도 된다.
      // var userMap = jsonDecode(response.data);
      Player player = Player.fromJson(response.data);
      return player;

    } catch(e) {
      //print(e);
      throw("[getUser] 데이터가 없습니다.");
    }
  }


  Future<List<Player>> getPlayersByIdList(List<int> idList) async {

    if ( CommonUtil.isEmpty(idList)) {
      return [];
    }
    
    try {
      Response response = await dio.get("players", queryParameters: {
        "idList": idList.join(",")
      });

      // response.data 가 Map 형태이기 때문에 아래코드는 실행 안해도 된다.
      //var userMap = jsonDecode(response.data);
      List<dynamic> parsedList = response.data;
      
      //Player player = Player.fromJson(userMap);
      List<Player> players = parsedList.map((e) => Player.fromJson(e)).toList();
      //print(user);
      return players;

    } catch(e) {
      //print(e);
      throw("[getUser] 데이터가 없습니다.");
    }
  }


  ///
  /// 현재 시세 정보를 조회한다. (한 건)
  ///
  Future<CurrentPrice> getCurrentPrice(int id, int grade) async {

    List<CurrentPrice> currentPriceList = await getCurrentPriceList([id], [grade]);

    if ( CommonUtil.isNotEmpty(currentPriceList)) {
      return currentPriceList.first;
    } else {
      return CurrentPrice();
    }
  }


  ///
  /// 현재 시세 정보를 조회한다.
  ///  - 최근 한달동안 시세정보도 포함
  ///
  Future<CurrentPrice> getCurrentDetailPrice(int playerId, int playerGrade) async {

    try {
        Response response = await dio.get("player/price/$playerId/$playerGrade");
        return CurrentPrice.fromJson(response.data);
    } catch(e) {
      // print(e);
      return CurrentPrice();
    }
  }

  ///
  /// 현재 시세 정보를 조회힌다. (다 건)
  ///
  Future<List<CurrentPrice>> getCurrentPriceList(List<int> idList, List<int> gradeList) async {

    if ( CommonUtil.isEmpty(idList)) {
      return [];
    }

    //http://www.api.fifameta.com/fifa/player/price/234181291/5
    //http://www.api.fifameta.com/fifa/players/price/234181291/5


    List<String> idNGradeList = [];

    int index = 0;
    idList.forEach((element) {
      idNGradeList.add("${idList[index]}:${gradeList[index]}");
      index++;
    });

    try {
      Response response = await dio.get("players/price", queryParameters: {
        "values": idNGradeList.join(",")
      });

      //print(response);

      // response.data 가 Map 형태이기 때문에 아래코드는 실행 안해도 된다.
      //var userMap = jsonDecode(response.data);
      List<dynamic> parsedList = response.data;
      
      //Player player = Player.fromJson(userMap);
      List<CurrentPrice> currentPriceList = parsedList.map((e) => CurrentPrice.fromJson(e)).toList();
      //print(user);
      return currentPriceList;

    } catch(e) {
      throw e;
    }
  }


  insertManager(String nickName) async {
    try {

      await dio.post(
        "manager", 
        options: Options(
          contentType: "application/json", 
          headers: {
            'contentType': "application/json"
          },
        ),
        data: {
          "nickname": nickName
        }
      );
    } catch(e) {
      //print("[insertManager] $e");
    }
  }


  insertPurchaseList(List items) async {

    try {
      await dio.post(
        "purchases", 
        options: Options(
          contentType: "application/json", 
          headers: {
            'contentType': "application/json"
          },
        ),
        data: jsonEncode(items)     
      );
    } catch(e) {
      throw e;
    }
  }


  // todo - 1. cpid?, 2. offset, limit
  Future<List<PlayerComment>> getPlayerComments(int playerId, {int offset = 0, int limit = 10}) async {
    
    int page = offset ~/ limit;

    try {
      Response response = await dio.get("players/comments", queryParameters: {
        "spid": playerId,
        "page": page,
        "size": limit,
        //"orderByList": "created:desc"
      });

      // response.data 가 Map 형태이기 때문에 아래코드는 실행 안해도 된다.
      List<dynamic> parsedList = response.data;
      List<PlayerComment> playerComments = parsedList.map((e) => PlayerComment.fromJson(e)).toList();
      return playerComments;

    } catch(e) {
      throw(e);
    }
  }


  Future<PlayerComment> insertPlayerComment(PlayerComment playerComment) async {
    try {

      var res = await dio.post(
        "players/comment", 
        options: Options(
          contentType: "application/json", 
          headers: {
            'contentType': "application/json"
          },
        ),
        data: playerComment.toJson()
      );

      PlayerComment insertedPlayerComment = PlayerComment.fromJson(res.data);

      return insertedPlayerComment;

    } catch(e) {
      throw "$e";
    }
  }


  ///
  /// 선수 코멘트 신고하기
  ///
  Future<PlayerComment> reportPlayerComment(int commentId) async {
    try {

      var res = await dio.post(
        "players/comment/report", 
        options: Options(
          contentType: "application/json", 
          headers: {
            'contentType': "application/json"
          },
        ),
        data: {
          "id": commentId,
          "reportCount" : 1
        }
      );

      PlayerComment reportedPlayerComment = PlayerComment.fromJson(res.data);
      return reportedPlayerComment;

    } catch(e) {
      throw e;
    }
  }


  Future<MinMaxTradePrice> getMaxMinTradePrice(int spid, int grade) async {

    try {
      //http://34.64.72.18:8080/fifa/players/marketPrice?spid=201000488&grade=1
      Response response = await dio.get(
        "players/marketPrice", queryParameters: {
          "spid": spid,
          "grade": grade
        }
      );

      MinMaxTradePrice maxMinTradePrice = MinMaxTradePrice.fromJson(response.data);
      return maxMinTradePrice;

    } catch(e) {
      throw e;
    }

  }

  //http://34.64.72.18:8080/fifa/players/comments?cpid=503158023&orderByList=writerName:desc,cpid:asc
  //http://34.64.72.18:8080/fifa/


  Future<List<PlayerNews>> getPlayerNews(int playerId, {int offset = 0, int limit = 5}) async {
   
   int page = offset ~/ limit;

    try {

      await Future.delayed(Duration(milliseconds: 500));

      Response response = await dio.get("news/players", queryParameters: {
          "spid": playerId,
          "page": page,
          "size": limit,
        });

      // response.data 가 Map 형태이기 때문에 아래코드는 실행 안해도 된다.
      List<dynamic> parsedList = response.data;
      List<PlayerNews> playerComments = parsedList.map((e) => PlayerNews.fromJson(e)).toList();
      return playerComments;

    } catch(e) {
      throw(e);
    }
  }


  updateHit(int playerId, PlayerValueCountType type) async {
    try {

      var data;
      if ( type == PlayerValueCountType.newsValuable) {
        data = {
          "id": playerId,
          "newsValuable": 1
        };
      } else if ( type == PlayerValueCountType.hit_newsValuable) {
        data = {
          "id": playerId,
          "hit" : 1,
          "newsValuable": 1
        };
      } else if ( type == PlayerValueCountType.hit_newsValuable_favoriteCnt) {
        data = {
          "id": playerId,
          "hit" : 1,
          "newsValuable": 1,
          "favoriteCnt": 1
        };
      }

      await dio.post(
        "players/count", 
        options: Options(
          contentType: "application/json", 
          headers: {
            'contentType': "application/json"
          },
        ),
        data: data
      );
    } catch(e) {
      throw e;
    }
  } 
}