class FifaMatchType {
  int matchType;
  String desc;

  FifaMatchType({
    this.matchType,
    this.desc,
  });

  FifaMatchType.fromJson(Map<String, dynamic> json)
    : matchType = json['matchtype'],
      desc = json['desc'];

  Map<String, dynamic> toJson() => {
    'matchType': matchType,
    'desc': desc,
  };
}