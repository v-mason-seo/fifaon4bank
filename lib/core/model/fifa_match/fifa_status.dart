class FifaMatchPlayerStatus {
  int shoot; // 슛 수 
  int effectiveShoot; // 유효 슛 수 
  int assist; // 어시스트 수 
  int goal; // 득점 수 
  int dribble; // 드리블 거리(야드) 
  int intercept; // 인터셉트 수 
  int defending; // 디펜딩 수 
  int passTry; // 패스 시도 수 
  int passSuccess; // 패스 성공 수 
  int dribbleTry; // 드리블 시도 수 
  int dribbleSuccess; // 드리블 성공 수 
  int ballPossesionTry; // 볼 소유 시도 수 
  int ballPossesionSuccess; // 볼 소유 성공 수 
  int aerialTry; // 공중볼 경합 시도 수 
  int aerialSuccess; // 공중볼 경합 성공 수 
  int blockTry; // 블락 시도 수 
  int block; // 블락 성공 수 
  int tackleTry; // 태클 시도 수 
  int tackle; // 태클 성공 수 
  int yellowCards; // 옐로카드 수 
  int redCards; // 레드카드 수 
  double spRating; // 선수 평점 


  FifaMatchPlayerStatus.fromJson(Map<String, dynamic> json) {
    shoot = json['shoot'];
    effectiveShoot = json['effectiveShoot'];
    assist = json['assist'];
    goal = json['goal'];
    dribble = json['dribble'];
    intercept = json['intercept'];
    defending = json['defending'];
    passTry = json['passTry'];
    passSuccess = json['passSuccess'];
    dribbleTry = json['dribbleTry'];
    dribbleSuccess = json['dribbleSuccess'];
    ballPossesionTry = json['ballPossesionTry'];
    ballPossesionSuccess = json['ballPossesionSuccess'];
    aerialTry = json['aerialTry'];
    aerialSuccess = json['aerialSuccess'];
    blockTry = json['blockTry'];
    block = json['block'];
    tackleTry = json['tackleTry'];
    tackle = json['tackle'];
    yellowCards = json['yellowCards'];
    redCards = json['redCards'];
    spRating     = json['spRating'];
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shoot'] = shoot;
    data['effectiveShoot'] = effectiveShoot;
    data['assist'] = assist;
    data['goal'] = goal;
    data['dribble'] = dribble;
    data['intercept'] = intercept;
    data['defending'] = defending;
    data['passTry'] = passTry;
    data['passSuccess'] = passSuccess;
    data['dribbleTry'] = dribbleTry;
    data['dribbleSuccess'] = dribbleSuccess;
    data['ballPossesionTry'] = ballPossesionTry;
    data['ballPossesionSuccess'] = ballPossesionSuccess;
    data['aerialTry'] = aerialTry;
    data['aerialSuccess'] = aerialSuccess;
    data['blockTry'] = blockTry;
    data['block'] = block;
    data['tackleTry'] = tackleTry;
    data['tackle'] = tackle;
    data['yellowCards'] = yellowCards;
    data['redCards'] = redCards;
    data['spRating    '] = spRating;

    return data;
  }
}




// 슛 수 
// 유효 슛 수 
// 어시스트 수 
// 득점 수 
// 드리블 거리(야드) 
// 인터셉트 수 
// 디펜딩 수 
// 패스 시도 수 
// 패스 성공 수 
// 드리블 시도 수 
// 드리블 성공 수 
// 볼 소유 시도 수 
// 볼 소유 성공 수 
// 공중볼 경합 시도 수 
// 공중볼 경합 성공 수 
// 블락 시도 수 
// 블락 성공 수 
// 태클 시도 수 
// 태클 성공 수 
// 옐로카드 수 
// 레드카드 수 
// 선수 평점 