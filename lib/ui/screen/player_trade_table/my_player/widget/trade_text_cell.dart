import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TradeTextCell extends StatelessWidget {

  final String text;
  final String text2;
  final Color text2Color;
  final double width;

  TradeTextCell({
    this.text,
    this.text2,
    this.text2Color,
    this.width,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //----------------------------------------
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.0),
            child: Text(
              text,
              style: TextStyle(
                fontSize: getFontSize(text)
              ),
            ),
          ),
          //----------------------------------------
          if(text2 != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.0),
            child: Text(
              text2,
              style: TextStyle(
                color: text2Color,
                fontSize: getFontSize(text2)
              ),
            ),
          ),
          //----------------------------------------
        ],
      ),
    );
  }

  double getFontSize(String text) {
    if ( text == null )
      return 14.0;
      
    if ( text.replaceAll(",", "").length > 12) {
      return 12.0;
    } else if ( text.length > 11) {
      return 13.0;
    }

    return 14.0;
  }
}