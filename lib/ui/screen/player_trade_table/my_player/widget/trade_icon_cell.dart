import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TradeIconCell extends StatelessWidget {

  final IconData icon;
  final double iconSize;
  final double width;

  TradeIconCell({
    this.icon,
    this.iconSize = 36,
    this.width = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      width: width,
      // color: Colors.blueAccent,
      child: Icon(
        icon,
        color: Colors.white.withOpacity(0.7),
        size: iconSize,
      ),
    );
  }
}