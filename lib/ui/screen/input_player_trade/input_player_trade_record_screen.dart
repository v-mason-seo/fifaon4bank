import 'package:fifa_on4_bank/core/util/common_util.dart';
import 'package:fifa_on4_bank/ui/base_widget/base_widget.dart';
import 'package:fifa_on4_bank/ui/widget/input_player_trade_amount.dart';
import 'package:fifa_on4_bank/ui/widget/input_player_trade_grade.dart';
import 'package:fifa_on4_bank/ui/widget/select_player_trade.dart';
import 'package:fifa_on4_bank/ui/widget/title_text_widget.dart';
import 'package:fifa_on4_bank/ui/screen/input_player_trade/input_player_trade_record_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../player_trade_table/my_player/model/player_trade_table_content.dart';

// ignore: must_be_immutable
class InputPlayerTradeRecordScreen extends StatelessWidget {

  PlayerTradeTableContent inputPlayer;
  bool isNewData = false;

  InputPlayerTradeRecordScreen({
    this.inputPlayer
  }){
    if ( this.inputPlayer == null ) {
      this.inputPlayer =PlayerTradeTableContent();
      this.isNewData = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      model: InputPlayerTradeRecordProvider(player: inputPlayer),
      builder: (context, model, child) {
        return Scaffold(
          //--------------------------------------
          //backgroundColor: Colors.grey[300],
          //--------------------------------------
          body: Consumer<InputPlayerTradeRecordProvider>(
            builder: (context, model, child) {
              return _buildBody(context);
            },
          ),
        );
      },
    );    
  }


  Widget _buildBody(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(left: 12.0, right: 12.0, top: 42.0, bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          //------------------------------
          _buildCardHeader(context),
          //------------------------------
          Expanded(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: _buildCardContent(),
            ),
          ),
          //------------------------------
          _buildCardBottom(context),
          //------------------------------
        ],
      )
    );
  }


  ///
  /// 헤더 위젯
  ///
  Widget _buildCardHeader(BuildContext context) {
    return Container(
      height: 48.0,
      width: double.infinity,
      //--------------------------------
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(14.0), 
            topRight: Radius.circular(14.0)
          )
        ),
        color: Theme.of(context).primaryColor
      ),
      //--------------------------------
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "선수 구매 기록 입력",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0
              ),
            ),
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
      //--------------------------------
    );
  }



  Widget _buildCardContent() {
    return Consumer<InputPlayerTradeRecordProvider>(
      builder: (context, model, child) {
        return ListView(
          shrinkWrap: true,
          children: <Widget>[
            //--------------------------------
            TitleText(
              title: "선수",
              subTitle: "(필수)",
            ),
            SelectPlayerTrade(
              player: model.player.player,
              onSelected: (player) {
                FocusScope.of(context).requestFocus(new FocusNode());
                model.setPlayer(player);
              },
            ),
            //--------------------------------
            TitleText(
              title: "구입 금액(BP)",
              subTitle: "(필수)",
            ),
            InputPlayerTradeAmount(
              //playerTradeTableData: model.player,
              saleAmount: model.player.purchaseAmount,
              onChanged: (inputText) {
                int salesAmount = 0;
                if (!CommonUtil.isEmpty(inputText)) {
                  salesAmount = int.parse(inputText.replaceAll(",", ""));  
                }
                model.setPurchaseAmount(salesAmount);
              },
            ),
            //--------------------------------
            TitleText(
              title: "강화등급",
              subTitle: "(선택)",
            ),
            InputPlayerTradeGrade(
              playerGrade: model.player.grade,
              onChanged: (grade) {
                FocusScope.of(context).requestFocus(new FocusNode());
                model.setGrade(grade);
              },
            ),
            //--------------------------------
            // TitleText(
            //   title: "추가할인",
            //   subTitle: "(선택)",
            // ),
            // InputPlayerTradeAddDiscount(
            //   playerTradeTableData: model.player,
            //   onAddDiscountChanged: (rate) => model.setAddDiscountRate(rate.toInt()),
            //   onAddDiscounntChangeEnd: (rate) {},
            // ),
            //--------------------------------
          ]
        );
      }      
    );
  }



  Widget _buildCardBottom(BuildContext context) {
    return Consumer<InputPlayerTradeRecordProvider>(
      builder: (context, model, child) {
        return MaterialButton(
          height: 48.0,
          onPressed: () => _handleSubmit(context),
          color: Theme.of(context).accentColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8.0), 
              bottomRight: Radius.circular(8.0),
            ),
          ),
          child: Center(
            child: Text(
              this.isNewData ?'등록하기' : '수정하기',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
                color: Colors.white
              ),
            ),
          ),
        );
      },
    );
    
  }



  void _handleSubmit(BuildContext context) async {
    if ( CommonUtil.isEmpty(inputPlayer.player)) {
      showMessage(context, "입력오류", "선수를 입력해주세요");
      return;
    }

    if ( CommonUtil.isEmpty(inputPlayer.purchaseAmount) || inputPlayer.purchaseAmount == 0) {
      showMessage(context, "입력오류", "구입 금액(BP)를 입력해주세요");
      return;
    }

    Navigator.pop(context, inputPlayer);
  }


  void showMessage(BuildContext context, String title, String body) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
              content: ListTile(
              title: Text(title),
              subtitle: Text(body),
              ),
              actions: <Widget>[
              FlatButton(
                  child: Text('Ok'),
                  onPressed: () => Navigator.of(context).pop(),
              ),
          ],
      ),
    );
  }




}




