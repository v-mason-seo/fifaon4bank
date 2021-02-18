import 'package:fifa_on4_bank/core/util/common_util.dart';
import 'package:fifa_on4_bank/ui/base_widget/base_widget.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_calculator/player_trade_calculator_provider.dart';
import 'package:fifa_on4_bank/ui/widget/input_player_trade_discount.dart';
import 'package:fifa_on4_bank/ui/widget/input_player_trade_amount.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_calculator/widget/player_trade_fee_result.dart';
import 'package:fifa_on4_bank/ui/widget/title_text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayerTradeCalculatorScreen extends StatefulWidget {
  _PlayerTradeCalculatorScreenState createState() 
      => _PlayerTradeCalculatorScreenState();
}

class _PlayerTradeCalculatorScreenState extends State<PlayerTradeCalculatorScreen> {
  //PlayerTradeTableContent player;

  @override
  void initState() {
    super.initState();
    //player = PlayerTradeTableContent();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      model: PlayerTradeCalculatorProvider(),
      builder: (context, model, child) {
        return Scaffold(
          // appBar: AppBar(
          //   //--------------------------------------
          //   iconTheme: IconThemeData(color: Colors.black),
          //   backgroundColor: Colors.white,
          //   title: Text('간편 계산기', style: TextStyle(color: Colors.black),),
          //   elevation: 0.0,
          //   //--------------------------------------
          //   actions: <Widget>[
          //   ],
          // ),
          //--------------------------------------
          //backgroundColor: Colors.grey[300],
          //--------------------------------------
          body: Consumer<PlayerTradeCalculatorProvider>(
            builder: (context, model, child) {
              return _buildBody();
            },
          ),
        );
      },
    );
  }


  Widget _buildBody() {
    return Card(
      margin: const EdgeInsets.only(left: 12.0, right: 12.0, top: 42.0, bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          //------------------------------
          _buildCardHeader(),
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
          //_buildCardBottom(),
          //------------------------------
        ],
      )
    );
  }


  ///
  /// 헤더 위젯
  ///
  Widget _buildCardHeader() {
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
              "수수료 간편 계산기",
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

    return Consumer<PlayerTradeCalculatorProvider>(
      builder: (context, model, child) {
        return ListView(
          shrinkWrap: true,
          children: <Widget>[
            TitleText(
              title: "판매 예정 금액(BP)",
              subTitle: "(필수)",
            ),
            InputPlayerTradeAmount(
              onChanged: (inputText) {
                int saleAmount = 0;
                if (!CommonUtil.isEmpty(inputText)) {
                  saleAmount = int.parse(inputText.replaceAll(",", ""));  
                }
                //print("saleAmount : $saleAmount");
                model.setSellAmount(saleAmount);
              },
            ),
            //--------------------------------
            SizedBox(height: 8,),
            TitleText(
              title: "할인",
              subTitle: "(선택)",
            ),
            //--------------------------------
            InputPlayerTradeDiscount(
              feeResult: model.feeResult,
              onPcRoomChanged: (selected) => model.checkedPcRoom(selected),
              onTopChanged: (selected) => model.checkedTop(selected),
              onAddDiscountChanged: (rate) => model.setAddDiscountRate(rate.toInt()),
            ),
            //--------------------------------
            SizedBox(height: 8,),
            TitleText(
              title: "계산결과",
              subTitle: "",
            ),
            //--------------------------------
            PlayerTradeFeeResult(
              feeResult: model.feeResult,
            ),
            //--------------------------------
            SizedBox(height: 24.0,)
          ]
        );

      },
    );
  }
}