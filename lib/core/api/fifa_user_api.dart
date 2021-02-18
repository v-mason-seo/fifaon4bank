import 'package:dio/dio.dart';
import 'package:fifa_on4_bank/core/model/fifa_meta/fifa_match.dart';
import 'package:fifa_on4_bank/core/model/fifa_meta/fifa_user.dart';
import 'package:fifa_on4_bank/core/model/fifa_meta/player_trade_record.dart';




///
/// ------------------------------------------
/// API 사용
/// ------------------------------------------
/// API Docs에서 조회한 요청 URL을 호출하면 오픈 API를 사용하실 수 있으며, API에 따라 필요한 요청 변수를 함께 전송하셔야 합니다.
/// NEXON DEVELOPERS에서 제공되는 오픈 API를 호출할 때에는, API Key값을 Header에 포함하셔야 정상적으로 사용 가능합니다.
/// ------------------------------------------
/// Type	  KeyName	      Content Type
/// Header	Authorization	String
/// ------------------------------------------
///
class FifaUserApi {

  Dio dio;

  FifaUserApi() {
    dio = new Dio();
    dio.options.baseUrl = "https://api.nexon.co.kr/fifaonline4/v1.0/";
    dio.options.headers = {
      "Authorization": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2NvdW50X2lkIjoiNzU1MTcwNzIxIiwiYXV0aF9pZCI6IjQiLCJ0b2tlbl90eXBlIjoiQWNjZXNzVG9rZW4iLCJzZXJ2aWNlX2lkIjoiNDMwMDExNDgxIiwiWC1BcHAtUmF0ZS1MaW1pdCI6IjIwMDAwOjEwIiwibmJmIjoxNjAxMzkxMDg2LCJleHAiOjE2NjQ0NjMwODYsImlhdCI6MTYwMTM5MTA4Nn0.yOmrJ-Jwc8tAIkUJnlCrFyT-DF0ajPNuyEGiR6r2MJs"
    };
  }



  ///
  /// [GET] 유저 닉네임으로 유저 정보 조회
  /// https://api.nexon.co.kr/fifaonline4/v1.0/users?nickname={nickname}
  /// 
  /// {
  ///       "accessId": "1165727691ef9f057c67e523",
  ///       "nickname": "매시",
  ///       "level": 80
  /// }
  /// 
  Future<FifaUser> getUser(String nickName) async {

    try {
      Response response = await dio.get("users", queryParameters: {
        "nickname": nickName
      });

      // response.data 가 Map 형태이기 때문에 아래코드는 실행 안해도 된다.
      // var userMap = jsonDecode(response.data);
      FifaUser user = FifaUser.fromJson(response.data);
      return user;

    } catch(e) {
      //print(e);
      throw("[getUser] 데이터가 없습니다.");
    }
  }


  /// 
  /// [GET] 유저 고유 식별자로 유저 정보 조회
  /// https://api.nexon.co.kr/fifaonline4/v1.0/users/{accessid}
  /// 
  /// {
  ///       "accessId": "1165727691ef9f057c67e523",
  ///       "nickname": "매시",
  ///       "level": 80
  /// }
  ///
  Future<FifaUser> getUserByAccessId(String accessId) async {

    try {
      Response response = await dio.get("users/$accessId");

      // response.data 가 Map 형태이기 때문에 아래코드는 실행 안해도 된다.
      // var userMap = jsonDecode(response.data);
      var user = FifaUser.fromJson(response.data);
      //print(response);

      return user;

    } catch(e) {
      //print(e);
      throw("데이터가 없습니다.");
    }
  }


  ///
  /// [GET] 유저 고유 식별자로 역대 최고 등급 조회
  /// https://api.nexon.co.kr/fifaonline4/v1.0/users/{accessid}/maxdivision
  ///
  /// [
  ///       {
  ///               "matchType": 50,
  ///               "division": 2400,
  ///               "achievementDate": "2018-06-20T01:38:26"
  ///       }
  /// ]
  /// 
  getUserMaxDvisionByAccessId(String accessId) async {

    try {
      await dio.get("users/$accessId/maxdivision");
      //print(response);
    } catch(e) {
      //print(e);
    }

  }


  ///
  /// [GET] 유저 고유 식별자로 유저의 매치 기록 조회
  /// https://api.nexon.co.kr/fifaonline4/v1.0/users/{accessid}/matches?matchtype={matchtype}&offset={offset}&limit={limit}
  /// 
  /// [
  ///         "5eda21d8ef21e838262ff5af",
  ///         "5ec504a29b234bed9b827481",
  ///         "5eb5ad45f3138ff97560833e",
  ///         "5eb5aa815bb54e192aa9d8c7",
  ///         "5eb0d1ceb37258d331f951c5"
  /// ]
  ///
  Future<List<String>> getUserMatchHistory(String accessId, int matchType) async {
    try {
      Response response = await dio.get("users/$accessId/matches", queryParameters: {
        "matchtype": matchType,
        "offset": 0,
        "limit": 100,
      });
      //print(response);

      List<dynamic> list = response.data;

      return list.cast<String>();
    } catch(e) {
      return <String>[];
    }
  }


  ///
  /// 매치 고유 식별자{matchid}로 매치의 상세 정보를 조회합니다.
  ///
  getMatchDetailInfo(String matchId) async {
    try {
      Response response = await dio.get("matches/$matchId");
      FifaMatch match = FifaMatch.fromJson(response.data);
      return match;
    } catch(e) {
      // print(e);
    }
  }


  ///
  /// 유저 고유 식별자로 유저의 거래 기록 조회
  /// https://api.nexon.co.kr/fifaonline4/v1.0/users/{accessid}/markets?tradetype={tradetype}&offset={offset}&limit={limit}
  ///
  /// Parameter   type     필수   설명
  /// -----------------------------------
  /// tradetype   String   Y     거래 종류 (구입 : buy, 판매 : sell)
  /// 
  /// [
  ///   {
  ///           "tradeDate": "2020-05-09T03:26:47",
  ///           "saleSn": "5eb5a43d57b12b82e2bbe7ec",
  ///           "spid": 216215558,
  ///           "grade": 3,
  ///           "value": 33000000
  ///   },
  ///   {
  ///           "tradeDate": "2020-05-09T03:18:42",
  ///           "saleSn": "5eb5a23fb189446a96f00ea5",
  ///           "spid": 216181458,
  ///           "grade": 5,
  ///           "value": 222000000
  ///   }
  /// ]
  Future<List<PlayerTradeRecord>> getUserPlyaerTradeList(String accessId, String tradeType, {int offset=0, int limit=100}) async {
    try {
      Response response = await dio.get("users/$accessId/markets", queryParameters: {
        "tradetype": tradeType,
        "offset": offset,
        "limit": limit,
      });

      var list = response.data as List;
      List<PlayerTradeRecord> transactionRecordList 
                  = list.map((e) => PlayerTradeRecord.fromJson(e)).toList();

      //print("transactionRecordList item size : ${transactionRecordList.length}");

      return transactionRecordList;
    } catch(e) {
      //print(e);
      return null;
    }
  }


  getMatchList(int matchType, {int offset, int limit}) async {

    try {
      // Response response = dio.get("/matches", queryParameters: {
      //   '': 
      // });
    } catch(e) {
      //print(e);
      throw("[getMatchList] $e");
    }
  }


}