
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fifa_on4_bank/core/model/fifa_meta/fifa_match_type.dart';
import 'package:fifa_on4_bank/core/model/fifa_meta/season.dart';
import 'package:flutter/services.dart';





///
/// ------------------------------------------
/// API 사용
/// ------------------------------------------
/// 메타정보 조회 API는 다른 API와 다르게 Base url 이 다르기 때문에
/// 클래스를 분리했다.
///
class FifaMetaApi {


  Dio dio;

  FifaMetaApi() {

    dio = new Dio();
    dio.options.baseUrl = "https://static.api.nexon.co.kr/fifaonline4/";
    dio.options.headers = {
      "Authorization": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2NvdW50X2lkIjoiNzU1MTcwNzIxIiwiYXV0aF9pZCI6IjQiLCJ0b2tlbl90eXBlIjoiQWNjZXNzVG9rZW4iLCJzZXJ2aWNlX2lkIjoiNDMwMDExNDgxIiwiWC1BcHAtUmF0ZS1MaW1pdCI6IjIwMDAwOjEwIiwibmJmIjoxNjAxMzkxMDg2LCJleHAiOjE2NjQ0NjMwODYsImlhdCI6MTYwMTM5MTA4Nn0.yOmrJ-Jwc8tAIkUJnlCrFyT-DF0ajPNuyEGiR6r2MJs"
    };
  }


  ///
  /// [GET] 매치 종류(matchtype) 메타데이터 조회
  /// https://static.api.nexon.co.kr/fifaonline4/latest/matchtype.json
  ///
  // Future<List<MatchType>> getMatchType() async {

  //   try {

  //     Response response = await dio.get("matchtype.json");
  //     List jsonResponse = json.decode(response.data);

  //     List<MatchType> list 
  //         = (jsonResponse).map((e) => MatchType.fromJson(e)).toList();
  //     //print(response);
      
  //     return list;
      
  //   } catch(e) {
  //     throw("[getMatchType] $e");
  //   }
  // }


  ///
  /// [GET] 선수 고유 식별자(spid) 메타데이터 조회
  /// https://static.api.nexon.co.kr/fifaonline4/latest/spid.json
  /// 
  /// [
  ///      {
  ///              "id": 101000001,
  ///              "name": "데이비드 시먼"
  ///      },
  ///      {
  ///              "id": 101000195,
  ///              "name": "로비 파울러"
  ///      },
  ///      ...
  ///  ]
  /// 
  /// json이 List 타입일 경우 #방법-1, #방법-2 두 가지 방법으로 변환할 수 있다.
  /// 모두 같은 기능을 하기 때문에 편한걸 사용하면 된다.
  ///
  // Future<List<Player>> getPlayers() async {
    
  //   try {

  //     Response response = await dio.get("spid.json");

  //     //#1. 방법-1
  //     //List<FifaPlayer> playerList = List<FifaPlayer>.from(response.data.map((x) => FifaPlayer.fromJson(x)));

  //     //#2. 방법-2
  //     var list = response.data as List;
  //     List<Player> playerList 
  //         = list.map((e) => Player.fromJson(e)).toList();
  //     //print("player list length : ${playerList.length}");

  //     return playerList;

  //   } catch(e) {
  //     throw("[getPlayers] $e");
  //   }
  // }


  // Future<List<Player>> searchLocalPlayer(String playerName) async {

  //   String jsonPlayers = await rootBundle.loadString("assets/json/fifa_players.json");
  //   List jsonResponse = json.decode(jsonPlayers);
  //   List<Player> findList 
  //         = jsonResponse.map((e) => Player.fromJson(e))
  //                       .where((element) => element.name.contains(playerName))
  //                       .toList();

  //   List<Season> seasonList = await getSeasonList();

  //     findList = findList.map((e) {
  //       int seasonId = ValueUtil.getSeasonIdFromPlayerId(e.id);
  //       Season season = seasonList.firstWhere(
  //         (element) => element.seasonId == seasonId,
  //         orElse: () => null,
  //       );
        
  //       if ( season != null ) {
  //         e.season = Season(
  //         seasonId: season.seasonId,
  //         className: season.className,
  //         seasonImg: season.seasonImg
  //       );
  //       } else {
  //         e.season = Season();
  //       }       

  //       return e;

  //     }).toList();

  //     return findList;
  // }


  // Future<List<Player>> searchPlayer(String playerName) async {

  //   Response response = await dio.get("spid.json");
  //   var list = response.data as List;

  //   // 넥슨  api가 안되는 경우에는 로컬 데이터를 불러온다.
  //   if ( CommonUtil.isEmpty(list)) {
  //       return searchLocalPlayer(playerName);
  //     }
  //   List<Player> playerList 
  //        = list.map((e) => Player.fromJson(e)).toList();

  //   try {
  //     List<Player> findList = playerList.where((element) 
  //             => element.name.contains(playerName)).toList();

  //     List<Season> seasonList = await getSeasonList();

  //     findList = findList.map((e) {
  //       int seasonId = ValueUtil.getSeasonIdFromPlayerId(e.id);
  //       Season season = seasonList.firstWhere(
  //         (element) => element.seasonId == seasonId,
  //         orElse: () => null,
  //       );
        
  //       if ( season != null ) {
  //         e.season = Season(
  //           seasonId: season.seasonId,
  //           className: season.className,
  //           seasonImg: season.seasonImg
  //         );
  //       } else {
  //         e.season = Season();
  //       }        
  //       return e;
  //     }).toList();

  //     return findList;
  //   } catch(e) {
  //     throw("[searchPlayer] 오류");
  //   }    
  // }



  ///
  /// [GET] 선수 고유 식별자(spid) 메타데이터 조회
  /// [ 서버가 아닌 로컬 json파일에서 데이터를 읽어온다. ]
  /// 
  /// https://static.api.nexon.co.kr/fifaonline4/latest/spid.json
  /// 
  /// [
  ///      {
  ///              "id": 101000001,
  ///              "name": "데이비드 시먼"
  ///      },
  ///      {
  ///              "id": 101000195,
  ///              "name": "로비 파울러"
  ///      },
  ///      ...
  ///  ]
  /// 
  /// json이 List 타입일 경우 #방법-1, #방법-2 두 가지 방법으로 변환할 수 있다.
  /// 모두 같은 기능을 하기 때문에 편한걸 사용하면 된다.
  ///
  // Future<List<Player>> getLocalPlayers(int offset, int limit) async {

  //   try {

  //     String jsonPlayers = await rootBundle.loadString("assets/json/fifa_players.json");
  //     List jsonResponse = json.decode(jsonPlayers);

  //     // List<FifaPlayer> players 
  //     //     = jsonResponse.getRange(offset, limit)
  //     //                   .map((e) => FifaPlayer.fromJson(e)).toList();


  //     List<Player> players 
  //         = jsonResponse.skip(offset).take(limit)
  //                       .map((e) => Player.fromJson(e)).toList();


  //     // Iterable<Map<String, dynamic>> iter = jsonResponse.getRange(offset, limit);
  //     // List<FifaPlayer> players  = iter.map((e) => FifaPlayer.fromJson(e)).toList();


  //     return players;

  //   } catch(e) {
  //     throw("[getPlayers] $e");
  //   }
  // }


  Future<List<Season>> getSeasonList() async {
    try {

      String jsonSeason = await rootBundle.loadString("assets/json/fifa_season.json");
      List jsonResponse = json.decode(jsonSeason);

      List<Season> seasonList 
          = jsonResponse.map((e) => Season.fromJson(e)).toList();

      return seasonList;

    } catch(e) {
      return <Season>[];
    }
  }


  ///
  /// 매치 종류(matchtype) 메타데이터 조회
  ///
  Future<List<FifaMatchType>> getMatchType() async {
    try {

      Response response = await dio.get("latest/matchtype.json");
      List<dynamic> parsedList = response.data;
      List<FifaMatchType> matchTypeList 
          = parsedList.map((e) => FifaMatchType.fromJson(e)).toList();

      return matchTypeList;

    } catch(e) {
      return <FifaMatchType>[];
    }
  }

}