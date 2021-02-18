import 'package:flutter/widgets.dart';


class PlayerGradeColor {

  static const Color grade1 = Color.fromARGB(255, 69, 73, 79);
  static const Color gradeFrom2To4 = Color(0xffD28863);
  static const Color gradeFrom5To7 = Color.fromARGB(255, 194, 197, 202);
  static const Color gradeFrom8To10 = Color.fromARGB(255, 232, 195, 55);

  static Color getColor(int grade) {
    if ( grade == null || grade == 1 ) return grade1;
    else if ( grade >=2  && grade <= 4) return gradeFrom2To4;
    else if ( grade >= 5 && grade <= 7) return gradeFrom5To7;
    else if ( grade >= 8) return gradeFrom8To10;
    
    return grade1;
  }

    static Color getFontColor(int grade) {
    if ( grade == null || grade == 1 ) return const Color(0xffBDC7C6);
    else if ( grade >=2  && grade <= 4) return  const Color(0xff5C3020);
    else if ( grade >= 5 && grade <= 7) return  const Color(0xff50545A);
    else if ( grade >= 8) return  const Color(0xff5C4706);
    
    return  const Color(0xffBDC7C6);
  }

}
