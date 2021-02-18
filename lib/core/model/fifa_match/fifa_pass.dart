class FifaPass {
  int passTry; //	패스 시도 수 
  int passSuccess; //	패스 성공 수 
  int shortPassTry; //	숏 패스 시도 수 
  int shortPassSuccess; //	숏 패스 성공 수 
  int longPassTry; //	롱 패스 시도 수 
  int longPassSuccess; //	롱 패스 성공 수 
  int bouncingLobPassTry; //	바운싱 롭 패스 시도 수 
  int bouncingLobPassSuccess; //	바운싱 롭 패스 성공 수 
  int drivenGroundPassTry; //	드리븐 땅볼 패스 시도 수 
  int drivenGroundPassSuccess; //	드리븐 땅볼 패스 성공 수 
  int throughPassTry; //	스루 패스 시도 수 
  int throughPassSuccess; //	스루 패스 성공 수 
  int lobbedThroughPassTry; //	로빙 스루 패스 시도 수 
  int lobbedThroughPassSuccess; //	로빙 스루 패스 성공 수   

  FifaPass.fromJson(Map<String, dynamic> json) {
    passTry = json['passTry'];
    passSuccess = json['passSuccess'];
    shortPassTry = json['shortPassTry'];
    shortPassSuccess = json['shortPassSuccess'];
    longPassTry = json['longPassTry'];
    longPassSuccess = json['longPassSuccess'];
    bouncingLobPassTry = json['bouncingLobPassTry'];
    bouncingLobPassSuccess = json['bouncingLobPassSuccess'];
    drivenGroundPassTry = json['drivenGroundPassTry'];
    drivenGroundPassSuccess = json['drivenGroundPassSuccess'];
    throughPassTry = json['throughPassTry'];
    throughPassSuccess = json['throughPassSuccess'];
    lobbedThroughPassTry = json['lobbedThroughPassTry'];
    lobbedThroughPassSuccess     = json['lobbedThroughPassSuccess'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['passTry'] = passTry;
    data['passSuccess'] = passSuccess;
    data['shortPassTry'] = shortPassTry;
    data['shortPassSuccess'] = shortPassSuccess;
    data['longPassTry'] = longPassTry;
    data['longPassSuccess'] = longPassSuccess;
    data['bouncingLobPassTry'] = bouncingLobPassTry;
    data['bouncingLobPassSuccess'] = bouncingLobPassSuccess;
    data['drivenGroundPassTry'] = drivenGroundPassTry;
    data['drivenGroundPassSuccess'] = drivenGroundPassSuccess;
    data['throughPassTry'] = throughPassTry;
    data['throughPassSuccess'] = throughPassSuccess;
    data['lobbedThroughPassTry'] = lobbedThroughPassTry;
    data['lobbedThroughPassSuccess    '] = lobbedThroughPassSuccess;

    return data;
  }
}