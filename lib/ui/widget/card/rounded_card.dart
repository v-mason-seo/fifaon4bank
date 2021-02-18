import 'package:flutter/material.dart';

class RoundedCard extends StatelessWidget {

  final Widget childWidget;
  final double corderRadius;
  final EdgeInsetsGeometry bodyPadding;
  final backgroundColor;

  RoundedCard({
    this.childWidget,
    this.corderRadius = 16.0,
    this.bodyPadding = const EdgeInsets.all(12.0),
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(corderRadius),
      ),
      color: backgroundColor,
      child: Padding(
        padding: bodyPadding,
        child: childWidget,
      ),
    );
  }
}