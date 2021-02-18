

import 'season.dart';

class Player {
  int id;
  String name;
  Season season;

  Player({
    this.id,
    this.name,
    this.season,
  });


  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is Player &&
    runtimeType == other.runtimeType &&
    id == other.id &&
    name == other.name;


  @override
  int get hashCode => id.hashCode ^ name.hashCode;


  Player.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      name = json['name'],
      season = json['season'] != null ? Season.fromJson(json['season']) : Season()
      ;


  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    'season': season,
  };
}