import 'package:fifa_on4_bank/ui/base_widget/base_widget.dart';
import 'package:fifa_on4_bank/ui/screen/search_player_trade_record/search_player_trade_record_page.dart';
import 'package:fifa_on4_bank/ui/screen/search_player_trade_record/search_player_trade_record_provider.dart';
import 'package:fifa_on4_bank/ui/screen/search_player_trade_record/widget/search_player_trade_record_filter.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class SearchPlayerTradeRecordScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return BaseWidget<SearchPlayerTradeRecordProvider>(
      model: SearchPlayerTradeRecordProvider(),
      builder: (context, model, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text("선수 거래기록 조회"),
            elevation: 0.0,
            centerTitle: true,
            backgroundColor: Colors.transparent,
          ),
          floatingActionButton: Padding(
            padding: model.getCheckedRowCount() == 0 
                      ? const EdgeInsets.all(0)
                      : const EdgeInsets.only(bottom: 52),
            child: FloatingActionButton(
              child: Icon(Icons.filter_list),
              onPressed: () {
                _showFilterBottomSheet(context);
              },
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SearchPlayerTradeRecordPage()
            ),
          ),
        );
      },
    );

    // return Scaffold(
    //   resizeToAvoidBottomInset: false,
    //   appBar: AppBar(
    //     //iconTheme: IconThemeData(color: Colors.black),
    //     title: Text("선수 거래기록 조회"),
    //     elevation: 0.0,
    //     centerTitle: true,
    //     backgroundColor: Colors.transparent,
    //   ),
    //   floatingActionButton: FloatingActionButton(
    //     child: Icon(Icons.filter_list),
    //     onPressed: () {

    //     },
    //   ),
    //   body: SafeArea(
    //     child: Padding(
    //       padding: const EdgeInsets.symmetric(vertical: 8.0),
    //       child: BaseWidget<SearchPlayerTradeRecordProvider>(
    //         model: SearchPlayerTradeRecordProvider(
    //           context: context,
    //           api: Provider.of<FifaUserApi>(context, listen: false),
    //           fifaOn4BankApi: Provider.of<FifaOn4BankApi>(context, listen: false),
    //           localApi: Provider.of<LocalApi>(context, listen: false),
    //         ),
    //         builder: (context, model, child) => SearchPlayerTradeRecordPage(),
    //       )
    //     ),
    //   ),
    // );
  }


  _showFilterBottomSheet(BuildContext context) async {

    var model = context.read<SearchPlayerTradeRecordProvider>();
    List<String> gradeFilter = model.getCloneFilter();

    List<String> selectedGrade = await showCupertinoModalBottomSheet(
      context: context,
      expand: false,
      builder: (context, scrollController) {
        return SearchPlayerTradeRecordFilter(
          selectedList: gradeFilter,
        );
      }
    );

    if ( selectedGrade != null ) {
      model.finteringList(selectedGrade);
    }
  }
}

