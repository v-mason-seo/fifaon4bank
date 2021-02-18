import 'package:fifa_on4_bank/core/util/common_util.dart';
import 'package:fifa_on4_bank/core/util/date_util.dart';
import 'package:fifa_on4_bank/core/util/value_util.dart';
import 'package:fifa_on4_bank/ui/screen/input_player_trade/input_player_trade_record_screen.dart';
import 'package:fifa_on4_bank/ui/screen/player_detail_screen/player_detail_screen.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_calculator/player_trade_fee_detail_result.dart';
import 'package:fifa_on4_bank/ui/widget/empty_page.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_table/my_player/model/player_trade_table_content.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_table/my_player/model/minSalesAmount.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_table/my_player/player_trade_table_provider.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_table/my_player/widget/input_discount_dialog.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_table/my_player/widget/trade_amount_cell.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_table/my_player/widget/trade_header_cell.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_table/my_player/widget/trade_icon_cell.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_table/my_player/widget/trade_player_cell.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_table/my_player/widget/trade_text_cell.dart';
import 'package:fifa_on4_bank/ui/widget/circle_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class PlayerTradeDataTable extends StatelessWidget {

  final double headerCellHeight = 68;
  final double rowCellHeight = 72;
  final double cellWidth = 100;
  final double checkboxWidth = 60;
  final double iconWidth = 80;
  BuildContext _context;

  @override
  Widget build(BuildContext context) {

    _context = context;
    return Consumer<PlayerTradeTableProvider>(
      builder: (context, model, child) {

        if ( model.busy)
          return Center(child: CircularProgressIndicator(),);

        if ( model.data.length == 0 ) {
          return buildEmptyPage(context);
        }


        return RefreshIndicator(
          onRefresh: () async {
            return model.refreshData();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                SingleChildScrollView(
                  primary: true,
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    showCheckboxColumn: model.isTableEditMode(),
                    dataRowHeight: rowCellHeight,
                    headingRowHeight: headerCellHeight,
                    columnSpacing: 0,
                    horizontalMargin: 16.0,
                    columns: getColumns(model.data),
                    //todo - 테스트중 model.data -> model.pagingData
                    rows: getRows(model.data),
                  ),
                ),
                //---------------------------------
                _buildLoadMore(),
                //---------------------------------
                SizedBox(height: 138,)
                //---------------------------------
              ],
            ),
          ),
        );
      }
    );
  }


  Widget buildEmptyPage(BuildContext context) {

    Color accentColor = Theme.of(context).accentColor;

    return EmptyPage(
      icon: Icon(
        MdiIcons.cashUsd,
        size: 98,
        color: Colors.white.withOpacity(0.2),
      ),
      //-------------------------
      text: Text.rich(
        TextSpan(
          text: "선수 거래내역을 추가해보세요\n\n",
          children: [
            TextSpan(text: "나의 선수 거래내역을 조회하고 추가하기 위해서는\n"),
            TextSpan(text: "자동입력 ", style: TextStyle(color: accentColor)),
            TextSpan(text: "버튼을 눌러 감독명을 입력하세요\n\n"),
            TextSpan(text: "직접 입력 하려면\n"),
            TextSpan(text: "수동입력 ", style: TextStyle(color: accentColor)),
            TextSpan(text: "버튼을 눌러 선수를 검색하세요"),
          ]
        ),
        style: TextStyle(
          fontSize: 17,
          color: Colors.white.withOpacity(0.8),
          height: 1.3,
        ),
        textAlign: TextAlign.center,
        overflow: TextOverflow.fade,
      ),
    );
  }


  ///
  /// 다음 데이터 불러오기 위젯
  ///
  Widget _buildLoadMore() {

    PlayerTradeTableProvider model 
      = _context.read<PlayerTradeTableProvider>();

    if ( !model.isPerformingLoadMore ) {
      return MaterialButton(
        minWidth: double.infinity,
        //color: Colors.amber,
        child: !model.isEndData
          ? Text("더 불러오기\n( ${model.getItemLength()} / ${model.getTotalCount()} )")
          : Text("마지막 데이터입니다."),
        onPressed: !model.isEndData 
         ? () {
          model.loadMore();
        } : null,
      );
    } else {
      return Container(
        height: 48, 
        child: Center(
          child: CircularProgressIndicator()
        ),
      );
    }
  }

  ///
  /// 헤더 위젯
  ///
  List<DataColumn> getColumns(List<PlayerTradeTableContent> items) {

    PlayerTradeTableProvider model 
      = _context.read<PlayerTradeTableProvider>();

    List<DataColumn> columns=[];
    //--------------------------------
    columns.add(DataColumn(
      label: TradeHeaderCell(labelList: ["선수"], width: cellWidth,),
    ));
    //--------------------------------
    columns.add(DataColumn(
      label: TradeHeaderCell(labelList: ["구매액","현재가"], width: cellWidth,),
    ));
    //--------------------------------
    columns.add(DataColumn(
      label: TradeHeaderCell(
        labelList: ["TOP","PC방","TOP+PC방"], 
        colorList: [Colors.lime[300], Colors.deepPurple[200], Colors.cyan[400]],
        width: cellWidth,
      ),
    ));
    //--------------------------------
    if ( CommonUtil.isNotEmpty(items) && CommonUtil.isNotEmpty(items[0].minAmountFromAddDiscount) ) {
      items[0].minAmountFromAddDiscount.forEach((element) {
        columns.add(DataColumn(
          label: GestureDetector(
            child: Container(
              width: cellWidth,
              height: headerCellHeight,
              alignment: Alignment.center,
              child: Row(
                children: [
                  Text(
                    "${element.addDiscountRate} %",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                      color: Colors.grey[100]
                    ),
                  ),
                  SizedBox(width: 8.0,),
                  CircleIcon(icon: Icons.clear, size: 16, background: Colors.black,),
                ],
              ),
            ),
            onTap: () => model.deleteAdditionalDiscountColumn(element.addDiscountRate),
          ),
        ));
      });
    }
    //--------------------------------
    columns.add(DataColumn(
      label: TradeHeaderCell(labelList: ["추가할인율"], width: iconWidth,),
    ));
    //--------------------------------
    columns.add(DataColumn(
      label: TradeHeaderCell(labelList: ["거래일자"], width: cellWidth,),
    ));

    model.setFixedColumnLength(columns.length);
    return columns;
  }


  List<DataRow> getRows(List<PlayerTradeTableContent> items) {

    PlayerTradeTableProvider model 
      = _context.read<PlayerTradeTableProvider>();

    if ( CommonUtil.isEmpty(items))
      return [];

   List<DataRow> rows = List.generate(items.length, (index) {
     PlayerTradeTableContent item = items[index];


     return DataRow(
        selected: item.isRowChecked,
        onSelectChanged: (checked) {
          model.changeRowCheckState(item, checked);
        },
        cells: [
          //------------------------------------------
          // 선수
          //------------------------------------------
          DataCell(
            TradePlayerCell(content: item, width: cellWidth,),
            onTap: () => handleClickPlayerCell(item),
          ),
          //------------------------------------------
          // 구매액
          //------------------------------------------
          DataCell(
            TradeTextCell(
              text: ValueUtil.getCurrencyFormatFromInt(item.purchaseAmount),
              text2: "${ValueUtil.getCurrencyFormatFromInt(item.currentPrice?.presentPrice)}",
              text2Color: getCurrentPriceColor(item),
              width: cellWidth,
            ),
            onTap: () => handleClickCell(index, item),
          ),
          //------------------------------------------
          //손익분기점
          //------------------------------------------
          DataCell(
            TradeAmountCell(minSalesAmount: item.minSalesAmount, width: cellWidth, isMultiColor: true,),
            onTap: () => handleClickMinAmount(item.minSalesAmount)
          ),
          //------------------------------------------
          //추가할인률
          //------------------------------------------
          if ( CommonUtil.isNotEmpty(items) && CommonUtil.isNotEmpty(items[0].minAmountFromAddDiscount) )
            ...getRowDiscountCells(item.minAmountFromAddDiscount),
          //------------------------------------------
          //추가할인율 등록 버튼
          //------------------------------------------
          DataCell(
            TradeIconCell(
              icon: MdiIcons.plusCircleOutline, 
              width: iconWidth,
            ),
            onTap: () => _showDiscountDialog(_context)
          ),
          //------------------------------------------
          //거래일자
          //------------------------------------------
          DataCell(
            TradeTextCell(
              text: DateUtils.getDateStringFromString(item.tradeDate, format: "yyyy-MM-dd\nHH:mm"),
              width: cellWidth,
            ),
            onTap: () => handleClickCell(index, item),
          ),
        ]
      );
    }).toList();

    return rows;
  }

  Color getCurrentPriceColor(PlayerTradeTableContent item) {

    int a = item.purchaseAmount ?? 0;
    int b = (item.currentPrice?.presentPrice) ?? a;

    int diff = a.compareTo(b);

    if ( diff == -1 ) {
      return Colors.red[200];
    } else if ( diff == 1) {
      return Colors.blue[300];
    } else {
      return null;
    }

  }

  List<DataCell> getRowDiscountCells(List<MinSalesAmount> amountList) {

    List<DataCell> cells = [];
    amountList.forEach((element) {
      cells.add(DataCell(
          TradeAmountCell(minSalesAmount: element, isMultiColor: true,),
          onTap: () => handleClickMinAmount(element)
        ));
    });

    return cells;
  }


  ///
  /// 셀 클릭
  ///
  handleClickCell(int rowIndex, PlayerTradeTableContent item) async {

    PlayerTradeTableProvider model 
      = _context.read<PlayerTradeTableProvider>();

    if ( item != null) {
      PlayerTradeTableContent updateItem = await Navigator.push(
        _context, 
        MaterialPageRoute(builder: (context) 
          => InputPlayerTradeRecordScreen(inputPlayer: PlayerTradeTableContent.clone(item),))
      );

      if ( updateItem != null) {
        model.updateTableData(rowIndex, item.id, updateItem);
      }
    }
  }

  handleClickPlayerCell(PlayerTradeTableContent item) {
    return Navigator.push(
        _context, 
        MaterialPageRoute(builder: (context) 
          => PlayerDetailScreen(
            player: item.player,
            playerGrade: item.grade,
            purchaseAmount: item.purchaseAmount,
          )
      )
    );
  }

  ///
  /// 손익분기점 셀 클릭
  ///  - 계산 상세 내역을 보여준다.
  ///
  handleClickMinAmount(MinSalesAmount minAmount) {
    showCupertinoModalBottomSheet(
      context: _context, 
      expand: false,
      builder: (context, scrollController) {
        return PlayerTradeFeeDetailResult(
          inputData: minAmount,
        );
      }
    );
  }


  ///
  /// 추가 할인율 입력 다이얼로그
  ///
  _showDiscountDialog(BuildContext context) async {

    PlayerTradeTableProvider model = context.read<PlayerTradeTableProvider>();

    int selectedRate = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return InputDiscountDialog();
      },
    );

    if ( selectedRate != null ) {

      if ( model.isExistAddDicountRate(selectedRate)) {
        Fluttertoast.showToast(
          msg: "$selectedRate(%) 할인율은 이미 등록되어있습니다.",
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.blueGrey
        );
      } else {
        model.addDiscountColumn(selectedRate);
      }
    }
  }
}