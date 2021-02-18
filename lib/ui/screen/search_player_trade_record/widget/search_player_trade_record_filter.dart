import 'package:fifa_on4_bank/core/constant/player_grade_color.dart';
import 'package:fifa_on4_bank/ui/widget/confirm_and_cancel_button.dart';
import 'package:flutter/material.dart';

class SearchPlayerTradeRecordFilter extends StatefulWidget {

  final List<String> selectedList;
  final bool isMeultiSelect;
  // final Function(List<String>) onSelectionChanged;

  SearchPlayerTradeRecordFilter({
    this.selectedList,
    this.isMeultiSelect = true,
    // this.onSelectionChanged,
  });

  @override
  _SearchPlayerTradeRecordFilterState createState() => _SearchPlayerTradeRecordFilterState();
}

class _SearchPlayerTradeRecordFilterState extends State<SearchPlayerTradeRecordFilter> {

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //-------------------------------------
            _buildHeader(),
            //-------------------------------------
            SizedBox(height: 24,),
            //-------------------------------------
            Text(
              "강화등급",
              style: Theme.of(context).textTheme.subtitle1,
            ),
            //-------------------------------------
            SizedBox(height: 12,),
            //-------------------------------------
            Wrap(
              spacing: 12.0,
              runSpacing: 8.0,
              children: [
                buildChoiceChip("1", PlayerGradeColor.getColor(1), PlayerGradeColor.getFontColor(1)),
                buildChoiceChip("2", PlayerGradeColor.getColor(2), PlayerGradeColor.getFontColor(2)),
                buildChoiceChip("3", PlayerGradeColor.getColor(3), PlayerGradeColor.getFontColor(3)),
                buildChoiceChip("4", PlayerGradeColor.getColor(4), PlayerGradeColor.getFontColor(4)),
                buildChoiceChip("5", PlayerGradeColor.getColor(5), PlayerGradeColor.getFontColor(5)),
                buildChoiceChip("6", PlayerGradeColor.getColor(6), PlayerGradeColor.getFontColor(6)),
                buildChoiceChip("7", PlayerGradeColor.getColor(7), PlayerGradeColor.getFontColor(7)),
                buildChoiceChip("8", PlayerGradeColor.getColor(8), PlayerGradeColor.getFontColor(8)),
                buildChoiceChip("9", PlayerGradeColor.getColor(9), PlayerGradeColor.getFontColor(9)),
                buildChoiceChip("10", PlayerGradeColor.getColor(10), PlayerGradeColor.getFontColor(10)),
              ],
            ),
            //-------------------------------------
            Divider(),
            //-------------------------------------
            ConfirmAndCancelButton(
              confirmLabel: "적용",
              onConfirmPress: () => Navigator.pop(context, widget.selectedList),
              cancelLabel: "취소",
              onCancelPress: () => Navigator.pop(context),
            ),
            //-------------------------------------
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Text(
        "검색 조건",
        style: Theme.of(context).textTheme.headline5,
      ),
    );
  }

  Widget buildChoiceChip(String label, Color background, Color foreColor) {

    ChipThemeData chipThemeData = Theme.of(context).chipTheme.copyWith(
      brightness: Brightness.dark,
      padding: const EdgeInsets.all(12.0),
      labelPadding: const EdgeInsets.symmetric(horizontal: 16.0),
    );

    return ChipTheme(
      data: chipThemeData,
      child: ChoiceChip(
        label: Text(label),
        labelStyle: TextStyle(color: foreColor),
        selectedColor: background,
        backgroundColor: Colors.black,
        selected: widget.selectedList.contains(label),
        onSelected: (selected) {

          setState(() {

            if ( widget.isMeultiSelect) {
              widget.selectedList.contains(label)
                ? widget.selectedList.remove(label)
                : widget.selectedList.add(label);
            } else {
              widget.selectedList.clear();
              widget.selectedList.add(label);
            }
          });
        },
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(2))
        ),
      ),
    );
    


  }
}