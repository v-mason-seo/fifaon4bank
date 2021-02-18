class Season {
  final int seasonId;
  final String className;
  final String seasonImg;

  Season({
    this.seasonId = 0,
    this.className = "",
    this.seasonImg = ""
  });


  Season.fromJson(Map<String, dynamic> json)
    : seasonId = json['seasonId'],
      className = json['className'],
      seasonImg = json['img'] ?? json['seasonImg'];


  Map<String, dynamic> toJson() => {
    'seasonId': seasonId,
    'className': className,
    'img': seasonImg
  };
}