import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

@immutable
// ignore: must_be_immutable
class InputPlayerTradeGrade extends StatelessWidget {

  int playerGrade;
  final ValueChanged<int> onChanged;

  InputPlayerTradeGrade({
    this.playerGrade = 1,
    @required this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 4.0, bottom: 4.0),
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        //border: Border.all(width: 1),
        borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child: Row(
        children: [
          Icon(Icons.grade, size: 32.0),
          SizedBox(width: 12.0,),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                value: playerGrade,
                isExpanded: true,
                hint: Text("강화등급을 선택하세요"),
                items: List.generate(10, (index) => DropdownMenuItem(
                  value: index+1,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text('${index+1}'),
                  ),
                )),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}