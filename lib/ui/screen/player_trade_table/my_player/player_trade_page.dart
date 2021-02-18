import 'package:fifa_on4_bank/ui/screen/player_trade_calculator/player_trade_calculator_screen.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_table/player_trade_table_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';


///
/// https://stackoverflow.com/questions/60642631/how-to-merge-scrolls-on-a-tabbarview-inside-a-pageview
/// https://medium.com/flutter-community/combining-multiple-gesturedetectors-in-flutter-26d899d008b2
/// https://medium.com/flutter/slivers-demystified-6ff68ab0296f
///
///
class PlayerTradePage extends StatefulWidget {
  @override
  _PlayerTradePageState createState() => _PlayerTradePageState();
}

class _PlayerTradePageState extends State<PlayerTradePage> 
  with SingleTickerProviderStateMixin {


  final _tabTitle = ["관심선수", "나의기록", "최근경기"];
  TabController _tabController;
  int currentIndex = 0;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }


  @override
  void dispose() {
    super.dispose();
    _tabController?.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
      //--------------------------------
      body : Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          buildSegmentedControl(),
          buildBody(),
        ],
      )
      //--------------------------------
    );
  }


  Widget buildSegmentedControl() {
    return CupertinoSegmentedControl<int>(
      padding: EdgeInsets.all(10), // padding added now.
      unselectedColor: Theme.of(context).scaffoldBackgroundColor,
      selectedColor: Theme.of(context).accentColor,
      children: <int, Widget>{
        0: Text(_tabTitle[0]),
        1: Text(_tabTitle[1]),
        2: Text(_tabTitle[2]),
      },
      onValueChanged: changePage,
      groupValue: currentIndex,
    );
  }


  Widget buildBody() {
    return Expanded(
      child: PlayerTradeTablePage()
    );
  }


  ///
  /// 페이지를 변경한다.
  ///
  void changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }
}