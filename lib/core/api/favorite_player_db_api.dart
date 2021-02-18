import 'package:fifa_on4_bank/core/db/db_helper.dart';
import 'package:fifa_on4_bank/core/db/table_model/favorite_player.dart';

class FavoritePlayerDbApi {

  careteFavoritePlayer(FavoritePlayer player) async {
    final db = await DBHelper().database;
    var res = await db.insert(DBHelper.favoritePlayer, player.toMap());
    return res;
  }


  Future<int> getFavoritePlayerCount() async {
    final db = await DBHelper().database;

    var res = await db.rawQuery("select COUNT(*) count from ${DBHelper.favoritePlayer}");
    return res.isNotEmpty ? res.first["count"] as int : 0;
  }


  getFavoritePlayer(int playerId, int grade) async {
    final db = await DBHelper().database;
    var res = await db.query(
      DBHelper.favoritePlayer,
      where: "player_id = ? and player_grade = ?",
      whereArgs: [playerId, grade]
    );

    return res.isNotEmpty ? FavoritePlayer.fromMap(res.first) : Null;
  }


  Future<List<FavoritePlayer>> getAllFavoritePlayers() async {
    final db = await DBHelper().database;
    var res = await db.query(
      DBHelper.favoritePlayer,
      orderBy: "created desc"
    );
    List<FavoritePlayer> list = res.isNotEmpty
      ? res.map((e) => FavoritePlayer.fromMap(e)).toList()
      : [];

    return list;
  }

  Future<List<FavoritePlayer>> getFavoritePlayers({
    int offset =0, 
    int limit = 20}) async {
    final db = await DBHelper().database;
    var res = await db.query(
      DBHelper.favoritePlayer,
      offset: offset,
      limit: limit,
      orderBy: "created desc"
    );
    List<FavoritePlayer> list = res.isNotEmpty
      ? res.map((e) => FavoritePlayer.fromMap(e)).toList()
      : [];

    return list;
  }


  deleteFavoritePlayer(int playerId, int grade) async {
    final db = await DBHelper().database;
    var res = await db.delete(
      DBHelper.favoritePlayer,
      where: "player_id = ? and player_grade = ?",
      whereArgs: [playerId, grade]
    );
    return res;
  }

  ///
  /// 추가 할인율 입력
  ///
  Future<int> updateAdditionalDiscount(String discount) async {

    final db = await DBHelper().database;
    int count = await db.rawUpdate(
      """
      UPDATE ${DBHelper.favoritePlayer} 
      SET 
      additional_discount = ?
      """,
      [discount]
    );

    return count;
  }

}