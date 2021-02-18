import 'package:fifa_on4_bank/core/model/fifa_meta/player.dart';

class FavoritePlayer {
  int playerId;
  String playerName;
  int playerGrade;
  int seasonId;
  String className;
  String seasonImg;
  String additionalDiscount;
  String updated;
  String created;


  FavoritePlayer({
    this.playerId,
    this.playerName,
    this.playerGrade,
    this.seasonId=0,
    this.className="",
    this.seasonImg="",
    this.additionalDiscount,
    this.updated,
    this.created
  });

  @override
  String toString() {
    return """FavoritePlayer(
      playerId: $playerId,
      playerName: $playerName,
      playerGrade: $playerGrade,
      seasonId: $seasonId,
      className: $className,
      seasonImg: $seasonImg,
      additionalDiscount: $additionalDiscount,
      updated: $updated,
      created: $created,
    )""";
  }


  FavoritePlayer.fromPlayer(Player player, int grade) {
    playerId = player.id;
    playerName = player.name;
    playerGrade = grade;
    seasonId = player.season != null ? player.season.seasonId : 0;
    className = player.season != null ? player.season.className : "";
    seasonImg = player.season != null ? player.season.seasonImg : "";
  }


  FavoritePlayer.fromMap(Map<String, dynamic> maps) {
    playerId = maps['player_id'];
    playerName = maps['player_name'];
    playerGrade = maps['player_grade'];
    seasonId = maps['season_id'];
    className = maps['class_name'];
    seasonImg = maps['season_img'];
    additionalDiscount = maps['additional_discount'];
    updated = maps['updated'];
    created = maps['created'];
  }


  Map<String, dynamic> toMap() {
    return {
      'player_id': playerId,
      'player_name': playerName,
      'player_grade': playerGrade,
      'season_id': seasonId,
      'class_name': className,
      'season_img': seasonImg,
      'additional_discount': additionalDiscount,
    };
  }
}