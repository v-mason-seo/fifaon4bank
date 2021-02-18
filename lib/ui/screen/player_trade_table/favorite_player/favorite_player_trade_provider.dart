import 'package:fifa_on4_bank/core/api/favorite_player_db_api.dart';
import 'package:fifa_on4_bank/core/api/fifa_meta_api.dart';
import 'package:fifa_on4_bank/core/api/fifa_on4_bank_api.dart';
import 'package:fifa_on4_bank/core/api/player_value_count_type.dart';
import 'package:fifa_on4_bank/core/db/table_model/favorite_player.dart';
import 'package:fifa_on4_bank/core/model/fifa_meta/player.dart';
import 'package:fifa_on4_bank/core/model/fifa_meta/season.dart';
import 'package:fifa_on4_bank/core/provider/base_model.dart';
import 'package:fifa_on4_bank/core/service_locator/service_locator.dart';
import 'package:fifa_on4_bank/core/util/calc_util.dart';
import 'package:fifa_on4_bank/core/util/common_util.dart';
import 'package:fifa_on4_bank/core/util/value_util.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_table/my_player/model/current_price.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_table/favorite_player/favorite_player_trade.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_table/my_player/model/minSalesAmount.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_table/my_player/model/player_trade_table_content.dart';


class FavoritePlayerTradeProvider extends BaseModel {


  final FavoritePlayerDbApi dbApi = serviceLocator.get<FavoritePlayerDbApi>();
  final FifaOn4BankApi serverApi = serviceLocator.get<FifaOn4BankApi>();
  final FifaMetaApi metaApi = serviceLocator.get<FifaMetaApi>();
  List<FavoritePlayerTrade> items = [];
  bool isLoadingCurrentPriceByGrade = false;

  List<PlayerTradeTableContent> data;
  List<PlayerTradeTableContent> pagingData = [];
  bool _isPerformingLoadMore = false;
  bool _isEndData = false;
  int _totalCount;

  setPerformingLoadMore(bool busy) {
    _isPerformingLoadMore = busy;
    notifyListeners();
  }

  ///
  /// 더 불러오기 작업중인지
  ///
  bool get isPerformingLoadMore => _isPerformingLoadMore;

  ///
  /// 마지막 데이터인지
  ///
  bool get isEndData => _isEndData;


  FavoritePlayerTradeProvider() {
    initTable();
  }


  initTable() async {
    setBusy(true);
    
    data = await loadTableContentFromDB();
    calculatePriceFromList(data);   

    setBusy(false);
  }


  ///
  /// 데이터 새로 불러오기
  ///
  refreshData() async{
    data?.clear();
    _isPerformingLoadMore = false;

    data = await loadTableContentFromDB();
    calculatePriceFromList(data);   

    notifyListeners();
  }


  ///
  /// 1. 로컬디비에서 거래 기록 데이터를 조회한다.
  /// 2. 조회된 데이터를 List<PlayerTradeTableContent> 변환하여 리턴한다.
  ///
  Future<List<PlayerTradeTableContent>> loadTableContentFromDB() async {

    List<PlayerTradeTableContent> tableData = [];
    List<FavoritePlayer> favoritePlayers = await dbApi.getFavoritePlayers();

    favoritePlayers.forEach((element) { 
      PlayerTradeTableContent tableContent = PlayerTradeTableContent.fromFavoritePlayer(element);
      tableData.add(tableContent);
    });
    
    await loadCurrentPriceNBinding(tableData);
    _totalCount = await loadTotalDBDataCount();

    if ( tableData.length == _totalCount ) {
      _isEndData = true;
    }

    return tableData;
  }


  ///
  /// todo - offset, limit 테스트중
  ///
  loadMore() async {

    setPerformingLoadMore(true);

    await Future.delayed(Duration(seconds: 1));
    
    int offset = (data == null) ? 0 : data.length;
    List<PlayerTradeTableContent> tableData = [];
    List<FavoritePlayer> favoritePlayers 
        = await dbApi.getFavoritePlayers(offset: offset);

    favoritePlayers.forEach((element) { 
      PlayerTradeTableContent tableContent = PlayerTradeTableContent.fromFavoritePlayer(element);
      tableData.add(tableContent);
    });
    await loadCurrentPriceNBinding(tableData);
    _totalCount = await loadTotalDBDataCount();

    calculatePriceFromList(tableData);   
    data.addAll(tableData);

    if ( tableData.length == _totalCount ) {
    _isEndData = true;
    }
    
    setPerformingLoadMore(false);
  }


  ///
  /// 현재시세를 가져와서 데이터를 바인딩한다.
  ///
  loadCurrentPriceNBinding(List<PlayerTradeTableContent> tableData) async {

    if ( CommonUtil.isNotEmpty(tableData)) {
      //_isEndData = false;
      try {

        List<int> idList = [];
        List<int> gradeList = [];

        tableData.forEach((element) {
          idList.add(element.player.id);
          gradeList.add(element.grade??1);
        });
        
        List<CurrentPrice> currentPriceList = await serverApi.getCurrentPriceList(idList, gradeList);
        Map<String, CurrentPrice> mapPriceList = Map.fromIterable(currentPriceList, 
          key: (v) => "${v.spid}|${v.grade}", value: (v) => v );

        tableData.forEach((element) {
          element.purchaseAmount = mapPriceList["${element.player.id}|${element.grade}"].presentPrice;
          element.currentPrice = mapPriceList["${element.player.id}|${element.grade}"];
        });

      } catch(e) {
        // print(e);
      }
    }
  }  


  ///
  /// 데이터 총 건수
  ///
  int getItemLength() {
    return data == null ? 0 : data.length;
  }


  int getTotalCount() {
    return _totalCount;
  }


  ///
  /// 로컬 DB에 저장된 데이터 총 건수
  ///
  Future<int> loadTotalDBDataCount() async {

    int totalCount = await dbApi.getFavoritePlayerCount();
    return totalCount;
  }



  //---------------------------------------------------------

  loadData() async {
    
    setBusy(true);

    await getFavoritePlayers();

    setBusy(false);
  }

  getFavoritePlayers() async {

    List<FavoritePlayer> list = await dbApi.getFavoritePlayers();
    //print("[getFavoritePlayers] list : ${list.length}");
    await loadSeasonAndBinding(list);
    await loadCurrentPriceAndBinding(list);

    notifyListeners();
  }

  loadSeasonAndBinding(List<FavoritePlayer> list) async {

    if ( CommonUtil.isEmpty(list)) {
      return;
    }

    try {

      List<Season> seasonList = await metaApi.getSeasonList();
      Map<int, Season> mapSeasonList 
          = Map.fromIterable(seasonList, key: (v) => v.seasonId, value: (v) => v);
      
      list.forEach((element) {
        int seasonId = ValueUtil.getSeasonIdFromPlayerId(element.playerId);

        element.seasonId = mapSeasonList[seasonId].seasonId;
        element.className = mapSeasonList[seasonId].className;
        element.seasonImg = mapSeasonList[seasonId].seasonImg;
      });

    } catch(e) {

    }
  }

  loadCurrentPriceAndBinding(List<FavoritePlayer> list) async {

    if ( CommonUtil.isEmpty(list)) {
      return;
    }

    try {
      List<int> idList = [];
      List<int> gradeList = [];

      list.forEach((element) {
        idList.add(element.playerId);
        gradeList.add(element.playerGrade);
      });

      List<CurrentPrice> currentPriceList = await serverApi.getCurrentPriceList(idList, gradeList);
      Map<String, CurrentPrice> mapPriceList 
        = Map.fromIterable(
            currentPriceList, 
            key: (v) => "${v.spid}|${v.grade}", value: (v) => v 
          );

      list.forEach((element) {
        FavoritePlayerTrade newItem = FavoritePlayerTrade.fromFavoritePlayer(element);
        newItem.currentPrice = mapPriceList["${newItem.player.id}|${newItem.playerGrade}"];
        items.add(newItem);
        //print(newItem);
      });
      
    } catch(e) {
      // print(e);
    }
  }


  ///
  /// 추가하려고 하는 할인율이 이미 등록되어 있는지 확인
  ///
  isExistAddDicountRate(int rate) {
    if ( CommonUtil.isEmpty(data)) {
      return false;
    }

    List<MinSalesAmount> addDiscountList = data.first.minAmountFromAddDiscount ?? [];
    for(var i=0; i < addDiscountList.length; i++) {
      if ( addDiscountList[i].addDiscountRate == rate) {
        return true;
      }
    }

    return false;
  }


  ///
  /// 추가할인률 컬럼 삭제
  ///
  deleteAdditionalDiscountColumn(int rateValue) async {

    if ( CommonUtil.isEmpty(data)) {
      return;
    }

    List<int> discountList = [];

    data.first.minAmountFromAddDiscount.forEach((element) {
      if ( element.addDiscountRate != rateValue) {
        discountList.add(element.addDiscountRate);
      }
    });

    String joinDiscountList = discountList.join(",");
    dbApi.updateAdditionalDiscount(joinDiscountList);
    data = await loadTableContentFromDB();
    calculatePriceFromList(data);
    notifyListeners();
  }


  ///
  /// 추가 할인율 컬럼 추가
  ///
  addDiscountColumn(int discountRate) async {

    List<int> discountList = [];

    data.first.minAmountFromAddDiscount.forEach((element) {
      discountList.add(element.addDiscountRate);
    });

    discountList.add(discountRate);
    String joinDiscountList = discountList.join(",");

    await dbApi.updateAdditionalDiscount(joinDiscountList);
    data = await loadTableContentFromDB();
    calculatePriceFromList(data);
    notifyListeners();
  }


  ///
  /// 관심선수 추가
  ///
  addFavoritePlayer(Player player, int playerGrade) async {

    FavoritePlayer insertData = FavoritePlayer.fromPlayer(player, playerGrade);
    await dbApi.careteFavoritePlayer(insertData);

    PlayerTradeTableContent tableContent 
      = PlayerTradeTableContent.fromFavoritePlayer(insertData);

    List<CurrentPrice> currentPriceList 
      = await serverApi.getCurrentPriceList([player.id], [playerGrade]);
    if (CommonUtil.isNotEmpty(currentPriceList)) {
      tableContent.currentPrice = currentPriceList.first;
      tableContent.purchaseAmount = currentPriceList.first.presentPrice;
    }
    calculatePrice(tableContent);
    data.insert(0, tableContent);

    serverApi.updateHit(player.id, PlayerValueCountType.hit_newsValuable_favoriteCnt);
    
    notifyListeners();
  }


  ///
  /// ID로 관심선수 삭제
  ///
  deleteFavoritePlayerById(int playerId, int playerGrade) async {

    await dbApi.deleteFavoritePlayer(playerId, playerGrade);
    data.removeWhere((element) 
      => element.player.id == playerId && element.grade == playerGrade);

    notifyListeners();
  }


  ///
  /// 관심선수 삭제
  ///
  deleteFavoritePlayer(PlayerTradeTableContent item) async {
    await dbApi.deleteFavoritePlayer(item.player.id, item.grade);
    data.removeWhere((element) => element.id == item.id);
    notifyListeners();
  }



  loadCurrentPriceByGrade(FavoritePlayerTrade selectedItem) async {

    isLoadingCurrentPriceByGrade = true;
    Future.delayed(Duration(seconds: 1));

    try {

      List<int> idList = [];
      List<int> gradeList = [];

      List.generate(10, (index) {
        idList.add(selectedItem.player.id);
        gradeList.add(index+1);
      });

      List<CurrentPrice> currentPriceList = await serverApi.getCurrentPriceList(idList, gradeList);
      selectedItem.currentPriceList = currentPriceList;

    } catch(e) {

    }

    isLoadingCurrentPriceByGrade = false;
    notifyListeners();

  }

  changeExpanded(int index) {
    items[index].isExpanded = !items[index].isExpanded;
    notifyListeners();
  }

  ///
  /// 리스트의 손익분기점을 계산한다.
  ///
  calculatePriceFromList(List<PlayerTradeTableContent> items) {
    for(PlayerTradeTableContent item in items) {
      calculatePrice(item);
    }
  }


  ///
  /// 손익분기점을 계산한다.
  ///
  calculatePrice(PlayerTradeTableContent item) {

    item.minSalesAmount = MinSalesAmount(
      minSalesAmountOfTop: CalcUtil.calcMinSalesAmountOfTop(item.purchaseAmount),
      minSalesAmountOfPcRoom : CalcUtil.calcMinSalesAmountOfPcRoom(item.purchaseAmount),
      minSalesAmountOfTopAndPcRoom : CalcUtil.calcMinSalesAmountOfTopAndPcRoom(item.purchaseAmount)
    );

    for(var minAmount in item.minAmountFromAddDiscount) {
      minAmount.calculateAmount(item.purchaseAmount);
    }
  }

  //--------------------------------------


  
  


}