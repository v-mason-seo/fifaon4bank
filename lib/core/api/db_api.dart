
import 'package:fifa_on4_bank/core/db/db_helper.dart';
import 'package:fifa_on4_bank/core/db/table_model/trade_record.dart';
import 'package:fifa_on4_bank/core/util/common_util.dart';


class DBApi /*with ChangeNotifier*/ {

  ///
  /// 선수 거래 내역을 저장한다. (단건)
  ///
  createTradeRecord(TradeRecord record) async {
    final db = await DBHelper().database;
    var res = await db.insert(DBHelper.tradeRecordTableName, record.toMap());
    return res;
  }


  ///
  /// 선수 거래 내역을 저장한다. (다건)
  ///
  createTradeRecordList(List<TradeRecord> recordList) async {
    final db = await DBHelper().database;
    var batch = db.batch();

    recordList.forEach(
      (element) { 
        batch.insert(DBHelper.tradeRecordTableName, element.toMap());
      }
    );

    var res = batch.commit();    

    return res;
  }


  ///
  /// 선수 아이디로 선수 거래 내역을 불러온다.
  ///
  getTradeRecord(int id) async {
    final db = await DBHelper().database;
    
    var res = await db.query(
      DBHelper.tradeRecordTableName,
      where: "id = ?",
      whereArgs: [id]
    );

    return res.isNotEmpty ? TradeRecord.fromMap(res.first) : Null;
  }


  ///
  /// 선수 거래 내역 아이디 최대값 조회
  ///
  getMaxIdTradeRecord() async {
    final db = await DBHelper().database;

    var res = await db.rawQuery("select MAX(id) max_id from ${DBHelper.tradeRecordTableName}");
    return res.isNotEmpty ? res.first["max_id"] : 1;
  }


  Future<int> getTradeRecordCount() async {
    final db = await DBHelper().database;

    var res = await db.rawQuery("select COUNT(*) count from ${DBHelper.tradeRecordTableName}");
    return res.isNotEmpty ? res.first["count"] as int : 0;
  }


  ///
  /// 가장 최근에 구매한 금액을 조회한다.
  ///
  Future<int> getRecentPurchaseAmount(int playerId, int playerGrade) async {
    final db = await DBHelper().database;
    var res = await db.rawQuery(
      """
      select a.purchase_amount 
      from   ${DBHelper.tradeRecordTableName} a
      where  1=1
      and    a.player_id = ?
      and    a.player_grade = ?
      and    a.trade_date = ( select MAX(b.trade_date)
                              from   ${DBHelper.tradeRecordTableName} b
                              where  1=1
                              and    b.player_id = a.player_id
                              and    b.player_grade = a.player_grade
                           )
      """,
      [playerId, playerGrade]
    );

    return res.isNotEmpty ? res.first["purchase_amount"] as int : 0;
  }


  ///
  /// 모든 선수 거래 내역을 조회한다.
  ///
  getAllTradeRecord() async {
    final db = await DBHelper().database;
    var res = await db.query(DBHelper.tradeRecordTableName, orderBy: "id desc");
    List<TradeRecord> list = res.isNotEmpty
      ? res.map((e) => TradeRecord.fromMap(e)).toList()
      : [];

    return list;
  }


  ///
  /// 선수 거래 내역을 조회한다. ( 페이징 처리 )
  ///
  getTradeRecordList(int offset, {int limit = 20}) async {
    final db = await DBHelper().database;
    var res = await db.query(
      DBHelper.tradeRecordTableName, 
      orderBy: "id desc",
      offset: offset,
      limit: limit
    );

    List<TradeRecord> list = res.isNotEmpty
      ? res.map((e) => TradeRecord.fromMap(e)).toList()
      : [];

    return list;
  }


  ///
  /// 선수 거래 내역을 수정한다.
  ///
  updateTradeRecord(TradeRecord record) async {
    final db = await DBHelper().database;
    var res = await db.update(
      DBHelper.tradeRecordTableName, 
      record.toMap(),
      where: "id = ?",
      whereArgs: [record.id]
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
      UPDATE ${DBHelper.tradeRecordTableName} 
      SET 
      additional_discount = ?
      """,
      [discount]
    );

    return count;
  }


  ///
  /// 선수 거래 내역을 삭제한다.
  ///
  deleteTradeRecord(int id) async {
    final db = await DBHelper().database;
    var res = await db.delete(
      DBHelper.tradeRecordTableName,
      where: "id = ?",
      whereArgs: [id]
    );

    return res;
  }


  ///
  /// 선수 거래 내역을 삭제한다.(다건)
  ///
  deleteTradeRecordList(List<int> idList) async {

    if ( CommonUtil.isEmpty(idList)) {
      return;
    }

    final db = await DBHelper().database;

    var batch = db.batch();    

    idList.forEach((element) {
      batch.delete(
        DBHelper.tradeRecordTableName,
        where: "id = ?",
        whereArgs: [element]
      );
    });

    var res = await batch.commit(noResult: false);
    return res;
  }


  ///
  /// 모든 선수 거래 내역을 삭제한다.
  ///
  deleteAllTradeRecord() async {
    final db = await DBHelper().database;
    var res = await db.delete(DBHelper.tradeRecordTableName);

    return res;
  }
}