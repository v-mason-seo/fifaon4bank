import 'package:fifa_on4_bank/core/constant/player_grade_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlayerGradeBadge extends StatelessWidget {

  final String text;
  final Color background;
  final Color fontColor;
  final GestureTapCallback onTap;

  String grade() {
    return text.replaceAll("+", "");
  }
  PlayerGradeBadge({
    @required this.text,
    this.background = PlayerGradeColor.grade1,
    this.fontColor = PlayerGradeColor.grade1,
    this.onTap,
  });


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          //---------------------------------------------
          Container(
            padding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
            decoration: new BoxDecoration(
              shape: BoxShape.rectangle,// You can use like this way or like the below line
              color: background,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 12,
                  height: 12,
                  child: Center(
                    child: Text(
                      grade(),
                      style: TextStyle(fontSize: 10.0, color:fontColor, fontWeight: FontWeight.bold),
                    ),
                  )
                ),
                if ( onTap != null)
                SizedBox(
                  width: 16,
                  height: 18,
                  child: Center(child: Icon(Icons.arrow_drop_down, size: 18.0, color: fontColor,)),
                )
              ],
            )
          ),
          //---------------------------------------------
        ],
      ),
    );
  }
}