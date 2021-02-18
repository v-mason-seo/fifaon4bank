class FifaShoot {

  int shootTotal;
  int effectiveShootTotal;
  int shootOutScore;
  int goalTotal;
  int goalTotalDisplay;
  int ownGoal;
  int shootHeading;
  int goalHeading;
  int shootFreekick;
  int goalFreekick;
  int shootInPenalty;
  int goalInPenalty;
  int shootOutPenalty;
  int goalOutPenalty;
  int shootPenaltyKick;
  int goalPenaltyKick;


  FifaShoot.fromJson(Map<String, dynamic> json) {
    shootTotal = json['shootTotal'];
    effectiveShootTotal = json['effectiveShootTotal'];
    shootOutScore = json['shootOutScore'];
    goalTotal = json['goalTotal'];
    goalTotalDisplay = json['goalTotalDisplay'];
    ownGoal = json['ownGoal'];
    shootHeading = json['shootHeading'];
    goalHeading = json['goalHeading'];
    shootFreekick = json['shootFreekick'];
    goalFreekick = json['goalFreekick'];
    shootInPenalty = json['shootInPenalty'];
    goalInPenalty = json['goalInPenalty'];
    shootOutPenalty = json['shootOutPenalty'];
    goalOutPenalty = json['goalOutPenalty'];
    shootPenaltyKick = json['shootPenaltyKick'];
    goalPenaltyKick = json['goalPenaltyKick'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['shootTotal'] = shootTotal;
    data['effectiveShootTotal'] = effectiveShootTotal;
    data['shootOutScore'] = shootOutScore;
    data['goalTotal'] = goalTotal;
    data['goalTotalDisplay'] = goalTotalDisplay;
    data['ownGoal'] = ownGoal;
    data['shootHeading'] = shootHeading;
    data['goalHeading'] = goalHeading;
    data['shootFreekick'] = shootFreekick;
    data['goalFreekick'] = goalFreekick;
    data['shootInPenalty'] = shootInPenalty;
    data['goalInPenalty'] = goalInPenalty;
    data['shootOutPenalty'] = shootOutPenalty;
    data['goalOutPenalty'] = goalOutPenalty;
    data['shootPenaltyKick'] = shootPenaltyKick;
    data['goalPenaltyKick'] = goalPenaltyKick;

    return data;
  }
}


class FifaShootDetail {

  int goalTime; //	슛 시간 
  double x; //	슛 x좌표 
  double y; //	슛 y좌표 
  int type; //	슛 종류 (1 : normal , 2 : finesse , 3 : header) 
  int result; //	슛 결과 (1 : ontarget , 2 : offtarget , 3 : goal) 
  int spId; //	슈팅 선수 고유 식별자 (/metadata/spid API 참고) 
  int spGrade; //	슈팅 선수 강화 등급 
  int spLevel; //	슈팅 선수 레벨 
  bool spIdType; //	슈팅 선수 임대 여부 (임대선수 : true, 비임대선수 : false) 
  bool assist; //	어시스트 받은 골 여부. (받음 : true, 안받음 : false) 
  int assistSpId; //	어시스트 선수 고유 식별자 (/metadata/spid API 참고) 
  double assistX; //	어시스트 x좌표 
  double assistY; //	어시스트 y좌표 
  bool hitPost; //	골포스트 맞춤 여부. (맞춤 : true, 못 맞춤 : false) 
  bool inPenalty; //	페널티박스 안에서 넣은 슛 여부 (안 : true, 밖 : false) 

  FifaShootDetail.fromJson(Map<String, dynamic> json) {
    goalTime = json['goalTime'];
    x = json['x'];
    y = json['y'];
    type = json['type'];
    result = json['result'];
    spId = json['spId'];
    spGrade = json['spGrade'];
    spLevel = json['spLevel'];
    spIdType = json['spIdType'];
    assist = json['assist'];
    assistSpId = json['assistSpId'];
    assistX = json['assistX'];
    assistY = json['assistY'];
    hitPost = json['hitPost'];
    inPenalty = json['inPenalty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['goalTime'] = goalTime;
    data['x'] = x;
    data['y'] = y;
    data['type'] = type;
    data['result'] = result;
    data['spId'] = spId;
    data['spGrade'] = spGrade;
    data['spLevel'] = spLevel;
    data['spIdType'] = spIdType;
    data['assist'] = assist;
    data['assistSpId'] = assistSpId;
    data['assistX'] = assistX;
    data['assistY'] = assistY;
    data['hitPost'] = hitPost;
    data['inPenalty'] = inPenalty;

    return data;
  }
}