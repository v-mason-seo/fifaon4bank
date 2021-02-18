import 'package:fifa_on4_bank/core/model/fifa_meta/fifa_match.dart';
import 'package:fifa_on4_bank/core/util/common_util.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_table/favorite_player/favorite_player_trade.dart';

class RecentMatchPlayerPrice {
  String matchDate;
  int matchType;
  String matchTypeName;
  bool isExpaned;
  List<FifaMatchInfo> matchInfo;
  List<FavoritePlayerTrade> players;

  RecentMatchPlayerPrice.fromFifaMatch(FifaMatch match) {
    this.matchDate = match.matchDate;
    this.matchType = match.matchType;
    this.matchTypeName = "-";
    this.isExpaned = true;
    this.matchInfo = match.matchInfo;
    this.players = [];
  }

  FifaMatchInfo getMyMatchDetail(String nickName) {

    if ( CommonUtil.isEmpty(matchInfo)) {
      return null;
    }

    FifaMatchInfo findMatchInfo = matchInfo.firstWhere(
      (element) => element.nickname == nickName, orElse: () => null);

    return findMatchInfo;
  }

  String getFirstNickName() {
    try {
      return matchInfo[0].nickname;
    } catch(e) {
      return "-";
    }
  }

  String getSecondNickName() {
    try {
      return matchInfo[1].nickname;
    } catch(e) {
      return "-";
    }
  }

  String getFirstResult() {
    try {
      return matchInfo[0].matchDetail.matchResult;
    } catch(e) {
      return "-";
    }
  }

  String getSecondResult() {
    try {
      return matchInfo[1].matchDetail.matchResult;
    } catch(e) {
      return "-";
    }
  }
}