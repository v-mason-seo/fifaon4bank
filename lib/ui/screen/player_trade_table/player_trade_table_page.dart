import 'package:fifa_on4_bank/core/model/fifa_meta/player.dart';
import 'package:fifa_on4_bank/core/util/common_util.dart';
import 'package:fifa_on4_bank/ui/screen/input_player_trade/input_player_trade_record_screen.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_calculator/player_trade_calculator_screen.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_table/favorite_player/favorite_player_trade_page.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_table/favorite_player/favorite_player_trade_provider.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_table/favorite_player/select_favorite_player_screen.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_table/my_player/model/player_trade_table_content.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_table/my_player/player_trade_data_table.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_table/my_player/player_trade_table_provider.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_table/recent_matches/recent_matches_player_price_page.dart';
import 'package:fifa_on4_bank/ui/screen/search_player_trade_record/model/search_player_trade_record.dart';
import 'package:fifa_on4_bank/ui/screen/search_player_trade_record/search_player_trade_record_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';



class PlayerTradeTablePage extends StatefulWidget {
  @override
  _PlayerTradeTablePageState createState() => _PlayerTradeTablePageState();
}

class _PlayerTradeTablePageState extends State<PlayerTradeTablePage> {

  final _tabTitle = ["구매선수", "관심선수", "최근경기"];
  List<Widget> bodyWidget = [];
  int currentTabIndex = 0;


  @override
  void initState() {
    super.initState();
    bodyWidget.add(PlayerTradeDataTable());
    bodyWidget.add(FavoritePlayerTradePage());
    bodyWidget.add(RecentMatchesPlayerPricePage());
  }

  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<PlayerTradeTableProvider>(
        builder: (context, model, child) {
          return Scaffold(
            // resizeToAvoidBottomInset: true,
            resizeToAvoidBottomPadding: false,
            //--------------------------------
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                '피온4: 장사의신', 
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              elevation: 0,
              leading: IconButton(
                icon: Icon(MdiIcons.calculatorVariant),
                onPressed: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => PlayerTradeCalculatorScreen())
                  );
                },
              ),
              actions: currentTabIndex != 0 ? null : [
                if ( model.getItemLength() > 0)
                  FlatButton(
                    child: Text(model.isTableEditMode() 
                            ? "완료"
                            : "편집"),
                    onPressed: () {
                      model.changeTalbeEditMode();
                    },
                  ),
              ],
            ),
            //-----------------------------------------
            body: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                buildSegmentedControl(),
                buildBody(),
              ],
            ),
            //-----------------------------------------
            floatingActionButton: buildFloatingActionButton(),
          );
        },
      ),
    );
  }


  ///
  /// 상위 헤더
  ///
  Widget buildSegmentedControl() {
    return Center(
      child: CupertinoSegmentedControl<int>(
        padding: EdgeInsets.all(10), // padding added now.
        unselectedColor: Theme.of(context).scaffoldBackgroundColor,
        selectedColor: Theme.of(context).accentColor,
        children: <int, Widget>{
          0: Padding(
            padding: const EdgeInsets.only(left: 24, right: 28, top: 12, bottom: 12),
            child: Text(_tabTitle[0]),),
          1: Text(_tabTitle[1]),
          2: Text(_tabTitle[2]),
        },
        onValueChanged: changePage,      
        groupValue: currentTabIndex,
      ),
    );
  }


  ///
  /// 바디 위젯
  ///
  Widget buildBody() {
    return Expanded(
      child: bodyWidget[currentTabIndex],
    );
  }


  Widget buildFloatingActionButton() {
    if ( currentTabIndex == 2 )
      return null;

    return Consumer<PlayerTradeTableProvider>(
      builder: (context, model, child) {

        if ( currentTabIndex == 0) {
          return model.getCheckedRowLength() > 0
            ? deleteFloatingActionButton()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                //------------------------------------------
                manualRegisterFloatingActionButton(),
                //----------------------------------------
                SizedBox(height: 12.0,),
                //----------------------------------------
                autoRegisterFloatingActionButton(),
                //----------------------------------------
              ],
            );
        } else if ( currentTabIndex == 1) {
          return addFavoritePlayer();
        }

        return Container();
      }
    );
  }

  Widget addFavoritePlayer() {
    return Consumer<FavoritePlayerTradeProvider>(
      builder: (context, model, child) {
        return FloatingActionButton.extended(
          label: Text("관심선수 추가"),
          heroTag: null,
          onPressed: () async {
            var selectedPlayerAndGrade = await Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => SelectFavoritePlayerScreen())
            );

            if ( CommonUtil.isNotEmpty(selectedPlayerAndGrade)) {
              Player player = selectedPlayerAndGrade[0];
              int playerGrade = selectedPlayerAndGrade[1];
              model.addFavoritePlayer(player, playerGrade);
            }
          }
        );
      },
    );
  }

  Widget deleteFloatingActionButton() {
    return Consumer<PlayerTradeTableProvider>(
      builder: (context, model, child) {
        return FloatingActionButton.extended(
          onPressed: () {
            model.deleteCheckedRows();
          }, 
          label: Text("삭제"),
          heroTag: null,
        );
      },
    );
  }


  ///
  /// 수동입력 버튼
  ///
  Widget manualRegisterFloatingActionButton() {
    return Consumer<PlayerTradeTableProvider>(
      builder: (context, model, child) {
        return FloatingActionButton.extended(
          onPressed: () async {
            //showAsBottomSheet(context);
            PlayerTradeTableContent registerPlayer = await Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => InputPlayerTradeRecordScreen())
            );

            model.addTableData(registerPlayer);
          }, 
          label: Text("수동입력"),
          heroTag: null,
        );
      },
    );
  }


  ///
  /// 자동입력 버튼
  ///
  Widget autoRegisterFloatingActionButton() {
    return Consumer<PlayerTradeTableProvider>(
      builder: (context, model, child) {
         return FloatingActionButton.extended(
          onPressed: () async {
            List<SearchPlayerTradeRecord> selectedList = await Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => SearchPlayerTradeRecordScreen())
            );

            model.addAllTableData(selectedList);                    
          }, 
          label: Text("자동입력"),
          heroTag: null,
        );
      },
    );
  }

  ///
  /// 페이지를 변경한다.
  ///
  void changePage(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }
}