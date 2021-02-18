import 'package:fifa_on4_bank/core/model/fifa_match/fifa_defence.dart';
import 'package:fifa_on4_bank/core/model/fifa_match/fifa_pass.dart';
import 'package:fifa_on4_bank/core/model/fifa_match/fifa_shoot.dart';

class FifaMatch {
  String matchId; //matchId
  String matchDate;
  int matchType;
  List<FifaMatchInfo> matchInfo;


  FifaMatch.fromJson(Map<String, dynamic> json) {
    matchId = json['matchId'];
    matchDate = json['matchDate'];
    matchType = json['matchType'];
    if ( json['matchInfo'] != null ) {
      matchInfo = new List<FifaMatchInfo>();
      json['matchInfo'].forEach((v) {
        matchInfo.add(FifaMatchInfo.fromJson(v));
      });
    }
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['matchId'] = matchId;
    data['matchDate'] = matchDate;
    data['matchType'] = matchType;
    if ( matchInfo != null) {
      data['matchInfo'] = matchInfo.map((v) => v.toJson()).toList();
    }    

    return data;
  }


  @override
  String toString() {
    return """FifaMatch(
      matchId: $matchId,
      matchDate: $matchDate,
      matchType: $matchType,
      matchInfo: $matchInfo,
    )
    """;
  }
}


class FifaMatchInfo {
  String accessId;
  String nickname;
  FifaMatchDetail matchDetail;
  FifaShoot shoot;
  List<FifaShootDetail> shootDetailList;
  FifaPass pass;
  FifaDefence defence;
  List<FifaMatchPlayer> players;


  FifaMatchInfo.fromJson(Map<String, dynamic> json) {
    accessId = json['accessId'];
    nickname = json['nickname'];
    matchDetail = FifaMatchDetail.fromJson(json['matchDetail']);
    shoot = FifaShoot.fromJson(json['shoot']);

    if ( json['shootDetail'] != null) {
      shootDetailList = List<FifaShootDetail>();
      json['shootDetail'].forEach((v) {
        shootDetailList.add(FifaShootDetail.fromJson(v));
      });
    }

    pass = FifaPass.fromJson(json['pass']);
    defence = FifaDefence.fromJson(json['defence']);
    
    if ( json['player'] != null ) {
      players = List<FifaMatchPlayer>();
      json['player'].forEach((v) {
        players.add(FifaMatchPlayer.fromJson(v));
      });
    }
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accessId'] = accessId;
    data['nickname'] = nickname;
    data['player'] = players.map((v) => v.toJson()).toList();

    return data;
  }

  @override
  String toString() {
    return """FifaMatchInfo(
      accessId: $accessId,
      nickname: $nickname,
      players: $players,
    )
    """;
  }
}

class FifaMatchDetail {
  int seasonId; // 시즌 ID 
  String matchResult; // 매치 결과 (“승”, “무”, “패”) 
  int matchEndType; // 매치종료 타입 (0: 정상종료, 1: 몰수승, 2:몰수패) 
  int systemPause; // 게임 일시정지 수 
  int foul; // 파울 수 
  int injury; // 부상 수 
  int redCards; // 받은 레드카드 수 
  int yellowCards; // 받은 옐로카드 수 
  int dribble; // 드리블 거리(야드) 
  int cornerKick; // 코너킥 수 
  int offsideCount; // 오프사이드 수 
  double averageRating; // 경기 평점 
  String controller; // 사용한 컨트롤러 타입 (keyboard / pad / etc 중 1) 
  int possession; // 점유율 


  FifaMatchDetail.fromJson(Map<String, dynamic> json) {
    seasonId = json['seasonId'];
    matchResult = json['matchResult'];
    matchEndType = json['matchEndType'];
    systemPause = json['systemPause'];
    foul = json['foul'];
    injury = json['injury'];
    redCards = json['redCards'];
    yellowCards = json['yellowCards'];
    dribble = json['dribble'];
    cornerKick = json['cornerKick'];
    offsideCount = json['offsideCount'];
    averageRating = json['averageRating'];
    controller = json['controller'];
    possession = json['possession'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['seasonId'] = seasonId;
    data['matchResult'] = matchResult;
    data['matchEndType'] = matchEndType;
    data['systemPause'] = systemPause;
    data['foul'] = foul;
    data['injury'] = injury;
    data['redCards'] = redCards;
    data['yellowCards'] = yellowCards;
    data['dribble'] = dribble;
    data['cornerKick'] = cornerKick;
    data['offsideCount'] = offsideCount;
    data['averageRating'] = averageRating;
    data['controller'] = controller;
    data['possession'] = possession;

    return data;
  }

}


class FifaMatchPlayer {
  int spId;
  int spPosition;
  int spGrade;
  //FifaMatchPlayerStatus status;

  FifaMatchPlayer.fromJson(Map<String, dynamic> json) {
    spId = json['spId'];
    spPosition = json['spPosition'];
    spGrade = json['spGrade'];
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['spId'] = spId;
    data['spPosition'] = spPosition;
    data['spGrade'] = spGrade;

    return data;
  }

  @override
  String toString() {
    return """FifaMatchPlayer(
      spId: $spId,
      spPosition: $spPosition,
      spGrade: $spGrade,
    )
    """;
  }
}