import 'package:fifa_on4_bank/core/constant/player_grade_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CircleIcon extends StatelessWidget {

  final IconData icon;
  final int size;
  final Color background;

  CircleIcon({
    @required this.icon,
    this.size = 16,
    this.background = PlayerGradeColor.grade1
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2.0),
      decoration: new BoxDecoration(
        shape: BoxShape.circle,// You can use like this way or like the below line
        color: background,
      ),
      child: Icon(
        icon,
        size: size.toDouble(),
      ),
    );
    // return ClipOval(
    //   child: Material(
    //     color: Colors.orange,
    //     child: Text('+1'),
    //   ),
    // );
  }
}