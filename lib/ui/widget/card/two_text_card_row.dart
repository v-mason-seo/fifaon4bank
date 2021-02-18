import 'package:flutter/material.dart';

class TwoTextCardRow extends StatelessWidget {

  final String title;
  final String leftText;
  final String rightText;

  TwoTextCardRow({
    this.title,
    this.leftText,
    this.rightText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(leftText)
          ),
          Expanded(child: Text(title, textAlign: TextAlign.center,)),
          Expanded(
            child: Text(rightText, textAlign: TextAlign.right,)
          ),
        ],      
      ),
    );
  }
}