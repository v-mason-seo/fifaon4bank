import 'package:fifa_on4_bank/core/constant/table_data_type.dart';
import 'package:flutter/material.dart';

class TableCellProperty {
  String bindId;
  TableDataType dataType;
  bool isChecked;
  Color foreColor;
  Color backgrounColor;
  double fontSize;
  double width;
  double height;
  List<String> title;
  bool isCurrency;
  bool isVisible;
  bool deleteColumnButton;
  String value;

  TableCellProperty(
    {
      this.title,
      this.bindId,
      this.dataType = TableDataType.text,
      this.isChecked = false,
      this.foreColor = Colors.white,
      this.backgrounColor = Colors.blueGrey,
      this.width = 110,
      this.height = 58,
      this.isCurrency = false,
      this.isVisible = true,
      this.deleteColumnButton = false,
      this.value = "",
    }
  );
}