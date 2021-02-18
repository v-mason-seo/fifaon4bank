class Division {
  final int matchType;
  final int division;
  DateTime achievementDate;

  Division({
    this.matchType,
    this.division,
    this.achievementDate
  });

  Division.fromJson(Map<String, dynamic> json)
    : matchType = json['matchType'],
      division = json['division'],
      achievementDate = json['achievementDate'];

  Map<String, dynamic> toJson() => {
    'matchType': matchType,
    'division': division,
    'achievementDate': achievementDate,
  };

}