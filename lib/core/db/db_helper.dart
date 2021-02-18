import 'package:fifa_on4_bank/core/api/fifa_meta_api.dart';
import 'package:fifa_on4_bank/core/api/local_api.dart';
import 'package:fifa_on4_bank/core/db/table_model/trade_record.dart';
import 'package:fifa_on4_bank/core/model/fifa_meta/season.dart';
import 'package:fifa_on4_bank/core/service_locator/service_locator.dart';
import 'package:fifa_on4_bank/core/util/value_util.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_table/my_player/model/player_trade_table_content.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

///
/// https://noxasch.tech/blog/flutter-using-sqflite-with-provider/
/// https://alexband.tistory.com/55
/// https://stackoverflow.com/questions/60553061/fluttermake-model-to-save-json-into-sqlite-and-return-data-as-a-object
///
class DBHelper {
  static final tradeRecordTableName = "trade_record";
  static final favoritePlayer = "favorite_player";
  static final dynamicDiscount = "dynamic_discount";
  
  //DBHelper._(); 
  static final DBHelper _databaseHelper = DBHelper._createInstance();
  DBHelper._createInstance();

  factory DBHelper() {
    return _databaseHelper;
  }

  final Future<Database> database = initDatabase();

  static Future<Database> initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'fifa_on4_bank.db'),
      version: 2,
      onUpgrade: (db, oldVersion, newVersion) async {
        // print("[onUpgrade] oldVersion: $oldVersion, newVersion: $newVersion");

        if ( oldVersion == 1 && newVersion == 2) {
          await db.execute(
            """
            CREATE TABLE IF NOT EXISTS $favoritePlayer (
              player_id INTEGER NOT NULL,
              player_name TEXT,
              player_grade INTEGER NOT NULL,
              season_id INTEGER,
              class_name TEXT,
              season_img TEXT,
              additional_discount TEXT,
              updated DATETIME DEFAULT (datetime('now','localtime')),
              created DATETIME DEFAULT (datetime('now','localtime')),
              PRIMARY KEY (player_id, player_grade)
            )
            """
          );
        }

        
      },
      onCreate: (db, version) async {

        // print("[onCreate], version: $version");

        //--------------------------------
        // 테이블 생성
        //--------------------------------
        await db.execute(
          """
          CREATE TABLE IF NOT EXISTS $tradeRecordTableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            player_id INTEGER,
            player_name TEXT,
            player_grade INTEGER,
            season_id INTEGER,
            class_name TEXT,
            season_img TEXT,
            purchase_amount INTEGER,
            additional_discount TEXT,
            trade_date TEXT,
            created DATETIME DEFAULT (datetime('now','localtime'))
          )
          """
        );

        await db.execute(
          """
          CREATE TABLE IF NOT EXISTS $favoritePlayer (
            player_id INTEGER NOT NULL,
            player_name TEXT,
            player_grade INTEGER NOT NULL,
            season_id INTEGER,
            class_name TEXT,
            season_img TEXT,
            additional_discount TEXT,
            updated DATETIME DEFAULT (datetime('now','localtime')),
            created DATETIME DEFAULT (datetime('now','localtime')),
            PRIMARY KEY (player_id, player_grade)
          )
          """
        );

        //--------------------------------
        // localJson => sqlite 컨버전
        //--------------------------------
        try {
          LocalApi localApi = serviceLocator.get<LocalApi>();
          FifaMetaApi metaApi = FifaMetaApi();
          //시즌 데이터를 불러온다.
          List<Season> seasonList = await metaApi.getSeasonList();
          //sharedPreference에 저장된 데이터를 불러온다.
          List<PlayerTradeTableContent> localData = await localApi.loadPlayerTradeTableData();
          List<TradeRecord> recordList = [];
          localData.forEach((element) {
            if ( element.player?.season == null
                  || element.player?.season?.seasonId == 0 ) {
              int seasonId = ValueUtil.getSeasonIdFromPlayerId(element.player.id);
              Season findSeason = seasonList.firstWhere((element) => element.seasonId == seasonId);
              if ( findSeason != null) {
                element.player.season = Season(
                  seasonId:  findSeason.seasonId,
                  className: findSeason.className,
                  seasonImg: findSeason.seasonImg
                );
              } else {
                element.player.season = Season();
              }
            }
            //리시트에 데이터를 추가한다.
            recordList.add(TradeRecord.fromPlayerTradeTableContent(element));          
          });        

          //local db에 데이터를 입력한다.
          var batch = db.batch();
          recordList.forEach(
            (element) { 
              batch.insert(tradeRecordTableName, element.toMap());
            }
          );
          await batch.commit();  

          // SharedPreference에 저장된 데이터를 삭제한다.
          await localApi.deletePlayerTradeTableDataList();
        } catch(e) {
        }
      }
    );
  }
}