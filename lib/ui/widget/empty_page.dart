import 'package:flutter/material.dart';

class EmptyPage extends StatelessWidget {

  final Icon icon;
  final Text text;

  EmptyPage({
    this.icon = const Icon(
      Icons.color_lens_sharp
    ),
    this.text = const Text("Empty page")
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon,
          SizedBox(height: 24,),
          text
        ],
      )
    );
  }
}