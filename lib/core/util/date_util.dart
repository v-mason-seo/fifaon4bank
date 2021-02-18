import 'package:intl/intl.dart';

class DateUtils {


  ///
  /// 년도, 월, 일을 제외한 값을 제거한다.
  ///
  static DateTime trunc(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }


  ///
  /// 년도, 월을 제외한 값을 제거한다.
  ///
  static DateTime truncDay(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }


  ///
  /// 월의 마지막 일자를 반환한다.
  ///
  static getLastDay(DateTime date) {
    DateTime d = DateTime(date.year, date.month+1, 0);
    return d.day;
  }


  ///
  /// DateTime 데이터를 날짜 포맷 문자열로 변환한다.
  ///
  static String getDateString(DateTime date, String format) {
    var formatter = DateFormat(format);
    return formatter.format(date);
  }


  static String getDateStringFromString(String date, {String format = "yyyy-MM-dd"}) {

    try {
      DateTime dt = DateTime.parse(date);
      return getDateString(dt, format);
    } catch(e) {
      return "-";
    }
    
  }

}