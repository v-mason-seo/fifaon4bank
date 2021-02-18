import 'package:fifa_on4_bank/core/api/fifa_on4_bank_api.dart';
import 'package:fifa_on4_bank/core/api/local_api.dart';
import 'package:fifa_on4_bank/core/api/db_api.dart';
import 'package:fifa_on4_bank/core/db/table_model/trade_record.dart';
import 'package:fifa_on4_bank/core/provider/base_model.dart';
import 'package:fifa_on4_bank/core/service_locator/service_locator.dart';
import 'package:fifa_on4_bank/core/util/calc_util.dart';
import 'package:fifa_on4_bank/core/util/common_util.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_table/my_player/model/player_trade_table_content.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_table/my_player/model/current_price.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_table/my_player/model/minSalesAmount.dart';
import 'package:fifa_on4_bank/ui/screen/search_player_trade_record/model/search_player_trade_record.dart';


class PlayerTradeTableProvider extends BaseModel {
  
  final LocalApi localApi = serviceLocator.get<LocalApi>();
  final DBApi dbApi = serviceLocator.get<DBApi>();
  final FifaOn4BankApi serverApi = serviceLocator.get<FifaOn4BankApi>();
  

  List<PlayerTradeTableContent> data;
  List<PlayerTradeTableContent> pagingData = [];
  bool visibleCheckbox = false;
  int fixedColumnLength = 0;
  bool _isPerformingLoadMore = false;
  bool _isEndData = false;
  int _totalCount;

  // PlayerTradeTableProvider({
  //   // this.localApi,
  //   // this.dbApi,
  //   // this.serverApi,
  // });


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
    List<TradeRecord> tradeRecordList = await dbApi.getTradeRecordList(0);
    tradeRecordList.forEach((element) { 
      PlayerTradeTableContent tableContent = PlayerTradeTableContent.fromTradeRecord(element);
      tableData.add(tableContent);
    });
    
     await loadCurrentPriceNBinding(tableData);
    _totalCount = await loadTotalDBDataCount();

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
    List<TradeRecord> tradeRecordList = await dbApi.getTradeRecordList(offset);

    if ( CommonUtil.isNotEmpty(tradeRecordList)) {
      tradeRecordList.forEach((element) { 
        PlayerTradeTableContent tableContent = PlayerTradeTableContent.fromTradeRecord(element);
        tableData.add(tableContent);
      });

      // 현재시세 가져와서 바인딩
      await loadCurrentPriceNBinding(tableData);
      _totalCount = await loadTotalDBDataCount();

      calculatePriceFromList(tableData);   
      data.addAll(tableData);
    } else {
      _isEndData = true;
    }
    
    setPerformingLoadMore(false);
  }


  ///
  /// 현재시세를 가져와서 데이터를 바인딩한다.
  ///
  loadCurrentPriceNBinding(List<PlayerTradeTableContent> tableData) async {

    if ( CommonUtil.isNotEmpty(tableData)) {
      _isEndData = false;

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
          element.currentPrice = mapPriceList["${element.player.id}|${element.grade}"];
        });

      } catch(e) {
      }
    } else {
      _isEndData = true;
    }
  }

  
  setFixedColumnLength(int len) {
    fixedColumnLength = len;
  }


  int getAdditionalDiscountInsertPosition() {
    return fixedColumnLength - 1;
  }


  ///
  /// rowIndex의 데이터를 반환한다.
  ///
  PlayerTradeTableContent getRowItem(int rowIndex) {
    return data[rowIndex];
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

    int totalCount = await dbApi.getTradeRecordCount();
    return totalCount;
  }


  ///
  /// 체크된 로우 건수를 반환한다.
  ///
  getCheckedRowLength() {
    return data == null 
      ? 0 
      : data.where((element) => element.isRowChecked == true).toList().length;
  }


  ///
  /// 로우 체크 상태를 변경한다.
  ///
  changeRowCheckState(PlayerTradeTableContent row, bool checked) {
    row.isRowChecked = checked;
    notifyListeners();
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
  /// 편집모드 전환 또는 복구
  ///
  changeTalbeEditMode() {
    visibleCheckbox = !visibleCheckbox;
    notifyListeners();
  }


  ///
  /// 현재 편집 모드인지 반환
  ///
  bool isTableEditMode() {
    return visibleCheckbox;
  }


  ///
  /// rowIndex의 데이터를 변경한다.
  ///
  updateTableData(int rowIndex, int id, PlayerTradeTableContent item) async {

    item.id = id;
    data[rowIndex] = item;
    calculatePrice(item);
    var updateItem = TradeRecord.fromPlayerTradeTableContent(item);
    
    List<int> discountList = data.first.getDynamicDiscountList();
    updateItem.additionalDiscount = discountList.join(",");

    await dbApi.updateTradeRecord(updateItem);
    notifyListeners();

  }

  
  ///
  /// 감독명으로 선수 거래 기록을 추가한다.
  /// (자동입력)
  ///
  addAllTableData(List<SearchPlayerTradeRecord> selectedList) async {

    if ( CommonUtil.isEmpty(selectedList)) {
      return;
    }

    List<PlayerTradeTableContent> newItems
        = selectedList.map(
            (e) => PlayerTradeTableContent.fromSearchPlayerTradeRecord(e)
          ).toList();


    List<TradeRecord> recordList = [];
    for(var item in newItems) {
      if ( CommonUtil.isNotEmpty(data)) {
        List<MinSalesAmount> discountList = data[0].minAmountFromAddDiscount;
        if ( CommonUtil.isNotEmpty(discountList)) {
          discountList.forEach((element) {
            int discountRate = element.addDiscountRate ?? 0;
            item.minAmountFromAddDiscount.add(MinSalesAmount(addDiscountRate: discountRate));          
          });
        }      
      }
      recordList.add(TradeRecord.fromPlayerTradeTableContent(item));
    }
    
    // 디비 데이터 입력
    await dbApi.createTradeRecordList(recordList.reversed.toList());
    data = await loadTableContentFromDB();
    calculatePriceFromList(data);
    notifyListeners();
  }


  ///
  /// 선수 거래 기록을 추가한다.
  /// (수동입력)
  ///
  addTableData(PlayerTradeTableContent item) async {
    
    if ( item == null) return;

    if ( CommonUtil.isNotEmpty(data)) {
      List<MinSalesAmount> discountList = data[0].minAmountFromAddDiscount;
      if ( CommonUtil.isNotEmpty(discountList)) {
        discountList.forEach((element) {
          int discountRate = element.addDiscountRate ?? 0;
          item.minAmountFromAddDiscount.add(MinSalesAmount(addDiscountRate: discountRate));          
        });
      }      
    }
      
    calculatePrice(item);
    TradeRecord insertRecord = TradeRecord.fromPlayerTradeTableContent(item);
    // 디비 데이터 입력
    var res = await dbApi.createTradeRecord(insertRecord);
    // id 맵핑
    item.id = res;
    // 데이터 입력
    data.insert(0, item);
    _totalCount = await loadTotalDBDataCount();
    notifyListeners();
  }

   
  ///
  /// 체크된 로우를 삭제한다.
  ///
  deleteCheckedRows() async {
    List<int> deleteIdList = [];
    data.forEach((element) {
      if ( element.isRowChecked ) {
        deleteIdList.add(element.id);
      }
    });
    // 디비 데이터 삭제
    dbApi.deleteTradeRecordList(deleteIdList);
    // 데이터 삭제
    data.removeWhere((element) => element.isRowChecked == true);   
    changeTalbeEditMode();

    notifyListeners();

    // 현재 보이는 데이터를 모두 삭제했을 때
    // 화면에 아무것도 보이지 않기 때문에 
    // 데이터를 다시 로드한다.(다음 페이지에 데이터가 있을 수 있기 때문)
    if ( CommonUtil.isEmpty(data)) {
      setBusy(true);
      await refreshData();
      setBusy(false);
    }
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

  
}