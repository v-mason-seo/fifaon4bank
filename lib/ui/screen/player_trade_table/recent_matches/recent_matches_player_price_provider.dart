import 'package:fifa_on4_bank/core/api/fifa_meta_api.dart';
import 'package:fifa_on4_bank/core/api/fifa_on4_bank_api.dart';
import 'package:fifa_on4_bank/core/api/fifa_user_api.dart';
import 'package:fifa_on4_bank/core/api/local_api.dart';
import 'package:fifa_on4_bank/core/model/fifa_meta/fifa_match.dart';
import 'package:fifa_on4_bank/core/model/fifa_meta/fifa_match_type.dart';
import 'package:fifa_on4_bank/core/model/fifa_meta/fifa_user.dart';
import 'package:fifa_on4_bank/core/model/fifa_meta/player.dart';
import 'package:fifa_on4_bank/core/provider/base_model.dart';
import 'package:fifa_on4_bank/core/service_locator/service_locator.dart';
import 'package:fifa_on4_bank/core/util/common_util.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_table/favorite_player/favorite_player_trade.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_table/my_player/model/current_price.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_table/recent_matches/recent_match_player_price.dart';
import 'package:flutter/material.dart';

class RecentMatchesPlayerPriceProvider extends BaseModel {

  final FifaUserApi fifaUserApi = serviceLocator.get<FifaUserApi>();
  final FifaMetaApi fifaMetaApi = serviceLocator.get<FifaMetaApi>();
  final FifaOn4BankApi api = serviceLocator.get<FifaOn4BankApi>();
  final LocalApi localApi = serviceLocator.get<LocalApi>();
  FifaUser user;
  String nickName = "";
  bool isLoadingLoadMore = false;
  List<String> matchIdList = [];
  List<RecentMatchPlayerPrice> matchList = [];

  List<DropdownMenuItem<FifaMatchType>> matchTypeItems = [];
  FifaMatchType selectedMatchType;
  List<FifaMatchType> matchTypeList;
  Map<int, FifaMatchType> mapMatchTypeList;


  initCode() async {
    matchTypeList?.clear();
    matchTypeList = await fifaMetaApi.getMatchType();

    if ( CommonUtil.isNotEmpty(matchTypeList)) {
      
      mapMatchTypeList = Map.fromIterable(
        matchTypeList,
        key: (item) => item.matchType,
        value: (item) => item,
      );
      selectedMatchType = mapMatchTypeList[50];
    } else {
      selectedMatchType = FifaMatchType(
        matchType: 50,
        desc: "공식경기"
      );
    }
    

    notifyListeners();
  }

  changeSelectedMatchType(FifaMatchType selectedItem) {
    selectedMatchType = selectedItem;
    notifyListeners();
  }


  setNickName(String nickName) async {
    isLoadingLoadMore = false;
    setBusy(true);
    matchList?.clear();
    this.nickName = nickName;

    try {
      //1. 사용자 정보 조회
      user = await fifaUserApi.getUser(nickName);
      //2 매치정보 조회
      int matchTypeCode;
      if ( CommonUtil.isNotEmpty(selectedMatchType)) {
        matchTypeCode = selectedMatchType.matchType;
      }
      matchIdList = await fifaUserApi.getUserMatchHistory(user.accessId, matchTypeCode ?? 50);
      //3. 매치상세정보 조회
      String matchId = matchIdList.first;
      FifaMatch match = await fifaUserApi.getMatchDetailInfo(matchId);
      //4. 최근경기에서 사용한 선수 정보 입력
      await insertRecentMatchPlayerPrice(match);
    } catch(e) {
      //todo - 데이터가 없거나 오류 발생시 안내 페이지 보여주기
    }

    setBusy(false);
  }

  loadMore()  async {

    if ( matchList.length < matchList.length ) {
      return;
    }

    isLoadingLoadMore = true;
    notifyListeners();

    int index = matchList.length;
    String matchId = matchIdList[index];
    //매치상세정보 조회
    FifaMatch match = await fifaUserApi.getMatchDetailInfo(matchId);
    //최근경기에서 사용한 선수 정보 입력
    await insertRecentMatchPlayerPrice(match);

    isLoadingLoadMore = false;
    notifyListeners();
  }


  ///
  /// 매치상세정보를 가공해서 RecentMatchPlayerPrice 객체로 변환하고
  /// 리스트에 객체를 추가한다.
  ///
  insertRecentMatchPlayerPrice(FifaMatch match) async {

    //RecentMatchPlayerPrice 객체 생성
    RecentMatchPlayerPrice newMatch = RecentMatchPlayerPrice.fromFifaMatch(match);
    //매치 상세정보에서 사용한 선수정보 가져오기
    List<FifaMatchPlayer> matchPlayers = newMatch.getMyMatchDetail(nickName)?.players;
    if ( CommonUtil.isEmpty(matchPlayers)) {
      return;
    }
    // 선수 정보 가져오기
    Map<int, Player> mapPlayers = await loadPlayerInfo(matchPlayers);
    //현재시세 가져오기
    Map<String, CurrentPrice> mapPriceList = await loadCurrentPrice(matchPlayers);

    matchPlayers.forEach((element) {
      FavoritePlayerTrade newItem = FavoritePlayerTrade();
      newItem.playerGrade = element.spGrade;
      newItem.player = mapPlayers[element.spId];
      newItem.currentPrice = mapPriceList["${element.spId}|${element.spGrade}"];
      newItem.isExpanded = false;

      newMatch.players.add(newItem);
    });

    matchList.add(newMatch);
  }


  ///
  /// 선수 기본 정보를 조회하고 Map 타입으로 리턴한다.
  ///
  Future<Map<int, Player>> loadPlayerInfo(List<FifaMatchPlayer> matchPlayers) async {

    List<int> playerIdList = [];
    matchPlayers.forEach((element) {
      playerIdList.add(element.spId);
    });

    // 선수 정보 가져오기
    List<Player> players = await api.getPlayersByIdList(playerIdList);
    Map<int, Player> mapPlayers = Map.fromIterable(
      players,
      key: (v) => v.id,
      value: (v) => v
    );

    return mapPlayers;
  }


  ///
  /// 선수 현재 시세정보를 조회하고 Map 타입으로 리턴한다.
  ///
  Future<Map<String, CurrentPrice>> loadCurrentPrice(List<FifaMatchPlayer> matchPlayers) async {

    List<int> playerIdList = [];
    List<int> playerGradeList = [];
    matchPlayers.forEach((element) {
      playerIdList.add(element.spId);
      playerGradeList.add(element.spGrade);
    });

    //현재시세 가져오기
    List<CurrentPrice> currentPriceList = await api.getCurrentPriceList(playerIdList, playerGradeList);
    Map<String, CurrentPrice> mapPriceList 
        = Map.fromIterable(
            currentPriceList, 
            key: (v) => "${v.spid}|${v.grade}", value: (v) => v 
          );

    return mapPriceList;
  }


  changeExpanded(int index, int playerIndex) {

    bool isExpaned = matchList[index].players[playerIndex].isExpanded;
    matchList[index].players[playerIndex].isExpanded = !isExpaned;
    notifyListeners();
  }


  getLoadMoreButtonName() {
    return "다음 매치 불러오기\n${matchList.length} / ${matchIdList.length}";
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