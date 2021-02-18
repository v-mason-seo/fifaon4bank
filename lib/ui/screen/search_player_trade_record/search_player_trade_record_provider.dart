import 'package:fifa_on4_bank/core/api/fifa_on4_bank_api.dart';
import 'package:fifa_on4_bank/core/api/fifa_user_api.dart';
import 'package:fifa_on4_bank/core/api/local_api.dart';
import 'package:fifa_on4_bank/core/constant/trade_type.dart';
import 'package:fifa_on4_bank/core/model/fifa_meta/fifa_user.dart';
import 'package:fifa_on4_bank/core/model/fifa_meta/player.dart';
import 'package:fifa_on4_bank/core/model/fifa_meta/player_trade_record.dart';
import 'package:fifa_on4_bank/core/provider/base_model.dart';
import 'package:fifa_on4_bank/core/service_locator/service_locator.dart';
import 'package:fifa_on4_bank/core/util/common_util.dart';
import 'package:fifa_on4_bank/ui/screen/search_player_trade_record/model/search_player_trade_record.dart';
import 'package:flutter/foundation.dart';

import '../../../core/util/common_util.dart';

class SearchPlayerTradeRecordProvider extends BaseModel {
  FifaUserApi api = serviceLocator.get<FifaUserApi>();
  FifaOn4BankApi fifaOn4BankApi = serviceLocator.get<FifaOn4BankApi>();
  LocalApi localApi = serviceLocator.get<LocalApi>();
  bool isAllCheckedItem = false;
  bool isLoadMoreData = true;

  List<SearchPlayerTradeRecord> searchPlayerTradeRecordList=[];
  List<SearchPlayerTradeRecord> filteredList = [];
  List<String> filter = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"];

  bool isExistsData() {

    if ( filteredList == null || filteredList.length == 0 )
      return false;
    else
      return true;
  }


  List<String> getCloneFilter() {
    List<String> cloneFilter = List<String>.from(filter).toList();
    return cloneFilter;
  }


  bool isEnableLoadMoreButton() {
    return isLoadMoreData;
  }

  String getLoadMoreButtonName() {
    return isLoadMoreData ? "더 불러오기" : "더이상 데이터가 없습니다.";
  }

  changedItem(SearchPlayerTradeRecord item, bool selected) {
     item.isSelected = selected;
    notifyListeners();
  }


  ///
  /// 전체 선택 또는 전체 선택 취소
  ///
  changedAllItems() {
    if ( CommonUtil.isNotEmpty(filteredList)) {
      for(SearchPlayerTradeRecord item in filteredList) {
        item.isSelected = !isAllCheckedItem;
      }

      isAllCheckedItem = !isAllCheckedItem;
      notifyListeners();
    }
  }


  getCheckButtonTitle() {
    if ( isAllCheckedItem ) {
      return "취소";
    } else {
      return "전체선택";
    }
  }


  ///
  /// 사용자가 선택한 목록을 반환한다.
  ///
  List<SearchPlayerTradeRecord> getCheckedList() {
    return filteredList.where((element) 
              => element.isSelected == true).toList();
  }


  ///
  /// 검색한 감독명을 서버로 전송
  ///
  insertManager(String nickName) async {
    await fifaOn4BankApi.insertManager(nickName);
  }


  ///
  /// 사용자가 선택한 구매목록을 서버에 전송
  ///
  insertPurchaseList() async {
    List purchaseList = [];
    filteredList.forEach((element) {
      if ( element.isSelected) {
        var toMap = element.toPurchaseJson();
        purchaseList.add(toMap);
      }      
    });

    try {
      fifaOn4BankApi.insertPurchaseList(purchaseList);
    } catch(e) {
      
    }
    
  }

  int getCheckedRowCount() {
    
    if ( CommonUtil.isEmpty(filteredList)) {
      return 0;
    }

    return getCheckedList().length;
  }

 
  ///
  /// 감독명 검색
  ///
  searchPlayerTradeRecord(String nickName) async {
    
    setBusy(true);

    searchPlayerTradeRecordList?.clear();
    filteredList?.clear();

    try {
      await fetchData(nickName, 0);     
    } catch(e) {
      setBusy(false);
    }

    setBusy(false);
  }


  ///
  /// 더 가져오기 버튼 클릭
  ///
  loadMorePlayerTradeRecord(String nickName, int offset) async {

    if ( searchPlayerTradeRecordList == null) {
      searchPlayerTradeRecordList = [];
    }

    try {
      await fetchData(nickName, offset);
      notifyListeners();
    } catch(e) {
      notifyListeners();
    }
  } 

  int getRealDataOffset() {
    return searchPlayerTradeRecordList != null
      ? searchPlayerTradeRecordList.length
      : 0;
  }


  ///
  /// 서버에서 감독 거래내역 조회
  ///
  fetchData(String nickName, int offset) async {

    try {

      //닉네임으로 유저 ID 조회
      FifaUser user = await api.getUser(nickName);
      //선수거래 기록 조회
      List<PlayerTradeRecord> playerTradeRecordList
          = await api.getUserPlyaerTradeList(user.accessId, describeEnum(TradeType.buy), offset: offset);

      if ( CommonUtil.isEmpty(playerTradeRecordList)) {
        isLoadMoreData = false;
        return;
      }

      //선수정보를 조회하기 위해 아이디만 뽑아냄
      List<int> playerIdList = [];
      playerTradeRecordList.forEach((element) {
        playerIdList.add(element.spid);
      });

      List<Player> players = await fifaOn4BankApi.getPlayersByIdList(playerIdList);
      List<SearchPlayerTradeRecord> newTradeRecordList = [];
      //선수정보 바인딩
      for(var r in playerTradeRecordList) {
        SearchPlayerTradeRecord newItem = SearchPlayerTradeRecord.fromPlayerTradeRecord(r);
        Player findPlayer = players.firstWhere(
          (element) => element.id == r.spid, orElse: () => null);
        if ( findPlayer != null ) {
          newItem.player = findPlayer;
          newItem.nickname = nickName;
          //searchPlayerTradeRecordList.add(newItem);
          newTradeRecordList.add(newItem);
        }
      }

      searchPlayerTradeRecordList.addAll(newTradeRecordList);

      //필터링 데이터 입력
      List<SearchPlayerTradeRecord> newFilteredTradeRecordList 
        = newTradeRecordList.where((element) {
            if ( filter.contains(element.grade.toString())) {
              return true;
            } else {
              element.isSelected = false;
              return false;
            }
          }).toList();
      filteredList.addAll(newFilteredTradeRecordList);     
    } catch(e) {
      throw e;
    }
  }


  ///
  /// 필터 조건을 적용한다.
  ///
  finteringList(List<String> selectedGrade) {
    filter = selectedGrade;
    filteredList?.clear();

    filteredList = searchPlayerTradeRecordList.where(
      (element) {
        if ( filter.contains(element.grade.toString())) {
          return true;
        } else {
          element.isSelected = false;
          return false;
        }
      }
    ).toList();

    notifyListeners();
  }

  Future<List<String>> getSuggestions(String pattern) async {

    List<String> originalList = await localApi.loadNicknameSuggestions();
    List<String> suggestionList = [];
    
    if ( CommonUtil.isNotEmpty(originalList)) {
      suggestionList = originalList.toSet().toList();
      suggestionList.removeWhere((element) => CommonUtil.isEmpty(element));
    }

    return suggestionList;

  }


  setSuggestions(String nickname) async {
    localApi.saveNicknameSuggestions(nickname);
  }

  deleteSuggestions(String nickname) async {
    localApi.deleteNicknameSuggestions(nickname);
  }

}