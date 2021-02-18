import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundedCornerContainer extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color foreColor;
  final double cornerRadius;
  final double fontSize;
  final EdgeInsetsGeometry padding;

  RoundedCornerContainer({
    @required this.text,
    this.backgroundColor = Colors.blueGrey,
    this.foreColor = Colors.white,
    this.cornerRadius = 12.0,
    this.fontSize = 9,
    this.padding = const EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(cornerRadius)
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: foreColor,
            fontSize: fontSize
          ),
        ),
      ),
    );
  }

}