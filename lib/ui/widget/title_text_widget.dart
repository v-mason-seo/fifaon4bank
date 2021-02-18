import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


///
/// 타이틀 위젯
///  - add_user_page.dart에서 사용함.
///
class TitleText extends StatelessWidget {

  final String title;
  final String subTitle;

  TitleText({
    this.title,
    this.subTitle = "",
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 4.0),
      child: RichText(
        text: TextSpan(
          children: [
            //-----------------------------
            TextSpan(
              text: title,
              style: TextStyle(
                //color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 14.0
              ),
            ),
            //-----------------------------
            WidgetSpan(
              child: SizedBox(width: 12.0,)
            ),
            //-----------------------------
            TextSpan(
              text: subTitle,
              style: TextStyle(
                color: Colors.grey[400].withOpacity(0.8),
                fontWeight: FontWeight.bold,
                fontSize: 13.0
              ),
            ),
            //-----------------------------
          ]
        ),
      ),
    );
  }
}