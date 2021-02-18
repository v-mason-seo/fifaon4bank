
class FifaUser {
  String accessId;
  String nickname;
  int level;

  FifaUser({
    this.accessId,
    this.nickname,
    this.level,
  });

  FifaUser.fromJson(Map<String, dynamic> json)
    : accessId = json['accessId'],
      nickname = json['nickname'],
      level = json['level'];

  Map<String, dynamic> toJson() => {
    'accessId': accessId,
    'nickname': nickname,
    'level': level,
  };
}

