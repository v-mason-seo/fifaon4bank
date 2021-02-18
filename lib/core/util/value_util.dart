import 'package:intl/intl.dart';

class ValueUtil {


  ///
  /// 3자리 + 6자리
  /// season id + player id
  /// 선수의 고유 아이디 리턴
  ///
  static int getPid(int fullId) {

    String pid = fullId.toString();
    return pid.length == 9
      ?  int.parse( pid.substring(3, pid.length))
      : 0;
  }


  static int getSeasonIdFromPlayerId(int playerId) {
    String pid = playerId.toString();
    if ( pid.length != 9) {
      return 0;
    }

    return int.parse(pid.substring(0, 3));
  }

  static String getPlayerImageUrl(int playerId, {bool isFullId = true}) {
    
    int pid;
    if ( isFullId) {
      pid = getPid(playerId);
    } else {
      pid = playerId;
    }

    return "https://fo4.dn.nexoncdn.co.kr/live/externalAssets/common/players/p$pid.png";
  }

  static String getSeasonSimpleName(String className) {
    try {
      List<String> splitName = className.split("(");
      return splitName[0].trimRight();
    } catch(e) {
      return className;
    }
  }

  static String getSeasonLongName(String className) {
    try {
      List<String> splitName = className.split("(");
      return splitName[1]
                .replaceAll("(", "")
                .replaceAll(")", "")
                .trim();
    } catch(e) {
      return className;
    }
  }

  static String getCurrencyFormatFromInt(int value) {
    if (value == null)
      return "-";
      
    var formatter = new NumberFormat("#,###");
    return formatter.format(value);
  }


  static int compare(int a, int b) {

    if ( a == null )
      a = 0;

    if ( b == null )
      b = 0;
      
    return a.compareTo(b);
  }
}