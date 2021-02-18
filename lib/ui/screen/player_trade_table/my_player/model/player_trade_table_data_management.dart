// import 'package:fifa_on4_bank/core/constant/table_data_type.dart';
// import 'package:fifa_on4_bank/core/model/table/table_cell_property.dart';
// import 'package:fifa_on4_bank/core/util/calc_util.dart';
// import 'package:fifa_on4_bank/ui/screen/player_trade_table/model/minSalesAmount.dart';
// import 'package:fifa_on4_bank/ui/screen/player_trade_table/model/player_trade_table_content.dart';
// import 'package:flutter/material.dart';

// import '../../../../core/util/calc_util.dart';

// class PlayerTradeTableDataManagement {

//   List<TableCellProperty> headerProperties;
//   List<TableCellProperty> contentProperties;
//   List<PlayerTradeTableContent> data;

//   final double contentCellHeight = 88;

//   PlayerTradeTableDataManagement() {
//     initTable();
//   }

//   initTable() {
//     initHeader();
//     initContent();
//   }

//   initHeader() {
//     Color backColor = Colors.blueGrey.withOpacity(0.7);
//     headerProperties = [];
//     headerProperties.add(TableCellProperty(
//       title: [""], 
//       dataType: TableDataType.checkbox, 
//       width: 48, 
//       isVisible: false,
//       backgrounColor: backColor));
//     headerProperties.add(TableCellProperty(title: ["선수"], backgrounColor: backColor, width: 78));
//     headerProperties.add(TableCellProperty(title: ["구매액"], backgrounColor: backColor));
//     headerProperties.add(TableCellProperty(
//       title: ["TOP", "PC방", "TOP+PC방"], 
//       backgrounColor: backColor ));
//     //------------------------------------------------
//     headerProperties.add(TableCellProperty(
//       bindId: "additionalDiscountButton",
//       title: ["추가할인등록"], 
//       backgrounColor: backColor ));
//     //------------------------------------------------
//   }

//   // List<DataColumn> tempColums;

//   // tempInitColumns() {

//   //   tempColums = [];
//   //   tempColums.add(DataColumn(
//   //     label: 
//   //   ));

//   // }

//   initContent() {
//     contentProperties = [];
//     contentProperties.add(TableCellProperty(bindId: "isRowChecked", dataType: TableDataType.checkbox, backgrounColor: Colors.white, foreColor: Colors.black, height: contentCellHeight));
//     contentProperties.add(TableCellProperty(bindId: "player", backgrounColor: Colors.white, foreColor: Colors.blueGrey.shade700, height: contentCellHeight, width: 78));
//     contentProperties.add(TableCellProperty(bindId: "purchaseAmount", isCurrency: true, backgrounColor: Colors.white, foreColor: Colors.black, height: contentCellHeight));
//     contentProperties.add(TableCellProperty(
//       bindId: "minSalesAmount", 
//       isCurrency: true, 
//       backgrounColor: Colors.white, 
//       foreColor: Colors.black, 
//       height: contentCellHeight));
//     //------------------------------------------------
//     contentProperties.add(TableCellProperty(
//       bindId: "additionalDiscountButton",
//       dataType: TableDataType.addButton,
//       backgrounColor: Colors.white, 
//       foreColor: Colors.black, 
//       height: contentCellHeight));
//     //------------------------------------------------
//   }


//   updateTableData(int rowIndex, PlayerTradeTableContent updateData) {
//     data[rowIndex] = updateData;
//     calculatePrice(data[rowIndex]);
//   }


//   ///
//   /// 체크박스 타입의 헤더가 클릭되었을 때
//   /// 모든 로우의 체크상태 값을 변경한다.
//   ///
//   changeAllCheckState(int columnIndex, bool value) {
//     String cellId = contentProperties[columnIndex].bindId;
//     for(int i=0; i < data.length; i++) {
//       setCellDataByName(i, cellId, value);
//     }
//   }

//   changeHeaderCheckState(int columnIndex, dynamic val) {
//     TableCellProperty header = headerProperties[columnIndex];
//     if ( header.dataType == TableDataType.checkbox) {
//       header.isChecked = val;
//     }
//   }
  

//   changeAllCheckStateWithHeader(int columnIndex, bool value) {
//     changeHeaderCheckState(columnIndex, value);
//     changeAllCheckState(columnIndex, value);
//   }


//   ///
//   /// rowIndex, columnIndex 의 값을 변경한다.
//   ///
//   setCellDataByIndex(int rowIndex, int columnIndex, dynamic val) {
    
//     String cellId = contentProperties[columnIndex].bindId;
//     setCellDataByName(rowIndex, cellId, val);
//   }


//   ///
//   /// rowIndex, columnName 의 값을 변경한다.
//   ///
//   setCellDataByName(int rowIndex, String columnName, dynamic val) {
//     switch(columnName) {
//       case "isRowChecked":
//         data[rowIndex].isRowChecked = val;
//         break;
//       case "player":
//         data[rowIndex].player = val;
//         break;
//       case "purchaseAmount":
//         data[rowIndex].purchaseAmount = val;
//         break;
//       case "sellAmount":
//         data[rowIndex].sellAmount = val;
//         calculatePrice(data[rowIndex]);
//         break;
//       case "minSalesAmount":
//         data[rowIndex].minSalesAmount = val;
//         calculatePrice(data[rowIndex]);
//         break;
//       //--------------------------------------------  
//     }
//   }

//   getCellBindId(int rowIndex, int columnIndex) {

//     return contentProperties[columnIndex].bindId;
//   }

//   getCellDataByIndex(int rowIndex, int columnIndex) {
    
//     String cellId = contentProperties[columnIndex].bindId;
//     return getCellDataByName(rowIndex, columnIndex, cellId);
//   }

//   getCellDataByName(int rowIndex, int colIndex, String columnName) {
//     var cellValue;

//     switch(columnName) {
//       case "isRowChecked":
//         cellValue = data[rowIndex].isRowChecked;
//         break;
//       case "player":
//         cellValue = data[rowIndex].player;
//         break;
//       case "purchaseAmount":
//         cellValue = data[rowIndex].purchaseAmount;
//         break;
//       case "sellAmount":
//         cellValue = data[rowIndex].sellAmount;
//         break;
//       case "minSalesAmount":
//         cellValue = data[rowIndex].minSalesAmount;
//         break;
//       //-------------------------------------
//       case "additionalDiscount":
//         int dynamicIndex = contentProperties.indexWhere(
//                                 (element) => element.bindId == "additionalDiscount");
//         int index = colIndex - dynamicIndex;
//         cellValue = data[rowIndex].minAmountFromAddDiscount[index];
//         break;
//       //----------------------------------------------
//       default:
//         cellValue = "-";
//     }
    
//     return cellValue;
//   }

//   setTableData(List<PlayerTradeTableContent> items) {

//     if ( items != null) {
//       data = items;
//     } else {
//       data = [];
//     }

//     //calculatePriceFromList(items);
//   }


//   calculatePrice(PlayerTradeTableContent item) {

//     item.minSalesAmount = MinSalesAmount(
//       minSalesAmountOfTop: CalcUtil.calcMinSalesAmountOfTop(item.purchaseAmount),
//       minSalesAmountOfPcRoom : CalcUtil.calcMinSalesAmountOfPcRoom(item.purchaseAmount),
//       minSalesAmountOfTopAndPcRoom : CalcUtil.calcMinSalesAmountOfTopAndPcRoom(item.purchaseAmount)
//     );

//     for(var minAmount in item.minAmountFromAddDiscount) {
//       minAmount.calculateAmount(item.purchaseAmount);
//     }
//   }

//   calculatePriceFromList(List<PlayerTradeTableContent> items) {
//     print("-----------------------------");
//     print("(A) ${DateTime.now()}");
//     for(PlayerTradeTableContent item in items) {
//       calculatePrice(item);
//     }
//     print("(B) ${DateTime.now()}");
//     print("-----------------------------");
//   }


//   int getCheckedRowLength() {
//     return data.where((element) => element.isRowChecked == true).toList().length;
//   }


//   List<PlayerTradeTableContent> getCheckedRows() {
//     return data.where((element) => element.isRowChecked).toList();
//   }

//   deleteCheckedRows() {

//     data.removeWhere((element) => element.isRowChecked == true);
//   }

  
// }