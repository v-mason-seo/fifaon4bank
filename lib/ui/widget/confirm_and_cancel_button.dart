


import 'package:flutter/material.dart';

class ConfirmAndCancelButton extends StatelessWidget {

  final String confirmLabel;
  final String cancelLabel;
  @required
  final VoidCallback onConfirmPress;
  @required
  final VoidCallback onCancelPress;

  ConfirmAndCancelButton({
    this.confirmLabel = "확인",
    this.cancelLabel = "취소",
    this.onConfirmPress,
    this.onCancelPress,
  });

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [
        //--------------------------------------
        Expanded(
          child: FlatButton(
            child: Text(
              cancelLabel,
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
            onPressed: onCancelPress,
          ),
        ),
        //--------------------------------------
        Text(
          "|",
          style: TextStyle(
            color: Colors.grey[800]
          ),
        ),
        //--------------------------------------
        Expanded(
          child: FlatButton(
            child: Text(
              confirmLabel,
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
            onPressed: onConfirmPress,
          ),
        ),
        //--------------------------------------
      ],
    );

  }
}