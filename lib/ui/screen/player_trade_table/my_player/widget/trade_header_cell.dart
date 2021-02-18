import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TradeHeaderCell extends StatelessWidget {

  //final String label;
  final List<String> labelList;
  final List<Color> colorList;
  final double width;
  final Alignment alignment;


  TradeHeaderCell({
    this.labelList,
    this.colorList,
    this.width = 100,
    this.alignment = Alignment.centerLeft
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      //alignment: Alignment.centerLeft,
      alignment: alignment,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(labelList.length, (index) {
          return Text(
            labelList[index],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
              color: colorList == null ? Colors.grey[100] : colorList[index]
            ),
          );
        }).toList(),
      ),
      /*
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14.0,
          color: Theme.of(context).accentColor
        ),
      ),
      */
    );
  }
}