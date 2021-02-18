import 'package:auto_size_text/auto_size_text.dart';
import 'package:fifa_on4_bank/core/util/calc_util.dart';
import 'package:fifa_on4_bank/core/util/value_util.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_table/my_player/model/minSalesAmount.dart';
import 'package:flutter/material.dart';

class PlayerTradeFeeDetailResult extends StatelessWidget {

  final MinSalesAmount inputData;


  PlayerTradeFeeDetailResult({
    this.inputData,
  });

  @override
  Widget build(BuildContext context) {
    //inputData.addDiscountRate = 100;
    return Material(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey[300]),
          borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: Colors.blueGrey,
              height: 52,
              width: double.infinity,
              child: Center(
                child: Text(
                  '수수료 상세 계산 내역',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.0,),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text("",),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      "TOP\n(20%)",
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.end,
                      maxLines: 2,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "PC방\n(30%)",
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.end,
                      maxLines: 2,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "TOP+PC방\n(50%)",
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.end,
                      maxLines: 2,
                    ),
                  ),
                ),
              ],
            ),
            //-----------------------------------------------------
            Divider(),
            //-----------------------------------------------------
            _buildRow(
              "① 판매금액",
              ValueUtil.getCurrencyFormatFromInt(inputData.minSalesAmountOfTop),
              ValueUtil.getCurrencyFormatFromInt(inputData.minSalesAmountOfPcRoom),
              ValueUtil.getCurrencyFormatFromInt(inputData.minSalesAmountOfTopAndPcRoom),
            ),
            //-----------------------------------------------------
            Divider(),
            //-----------------------------------------------------
            _buildRow(
              "② 기본수수료(40%)", 
              ValueUtil.getCurrencyFormatFromInt(CalcUtil.calcBasicFeeAmount(inputData.minSalesAmountOfTop)), 
              ValueUtil.getCurrencyFormatFromInt(CalcUtil.calcBasicFeeAmount(inputData.minSalesAmountOfPcRoom)), 
              ValueUtil.getCurrencyFormatFromInt(CalcUtil.calcBasicFeeAmount(inputData.minSalesAmountOfTopAndPcRoom)),
            ),
            //-----------------------------------------------------
            Divider(),
            //-----------------------------------------------------
            _buildRow(
              "③ 수수료할인",
              ValueUtil.getCurrencyFormatFromInt(
                CalcUtil.calcFeeDiscountAmount(
                  inputData.minSalesAmountOfTop, 
                  CalcUtil.topDiscountPer)
              ),
              ValueUtil.getCurrencyFormatFromInt(
                CalcUtil.calcFeeDiscountAmount(
                  inputData.minSalesAmountOfPcRoom, 
                  CalcUtil.pcRoomDiscountPer)
              ),
              ValueUtil.getCurrencyFormatFromInt(
                CalcUtil.calcFeeDiscountAmount(
                  inputData.minSalesAmountOfTopAndPcRoom, 
                  CalcUtil.topAndPcRoomDiscountPer)
              ),
            ),
            //-----------------------------------------------------
            Divider(),
            //-----------------------------------------------------
            _buildRow(
              "④ 추가할인\n(${inputData.addDiscountRate}%)",
              ValueUtil.getCurrencyFormatFromInt(
                CalcUtil.calcFeeAdditionalDiscountAmount(
                  inputData.minSalesAmountOfTop, 
                  CalcUtil.topDiscountPer,
                  inputData.addDiscountRate)
              ),
              ValueUtil.getCurrencyFormatFromInt(
                CalcUtil.calcFeeAdditionalDiscountAmount(
                  inputData.minSalesAmountOfPcRoom, 
                  CalcUtil.pcRoomDiscountPer,
                  inputData.addDiscountRate)
              ),
              ValueUtil.getCurrencyFormatFromInt(
                CalcUtil.calcFeeAdditionalDiscountAmount(
                  inputData.minSalesAmountOfTopAndPcRoom, 
                  CalcUtil.topAndPcRoomDiscountPer,
                  inputData.addDiscountRate)
              ),
            ),
            //-----------------------------------------------------
            Divider(),
            //-----------------------------------------------------
            _buildRow(
              "⑤ 최종수수료\n(②-③-④)",
              ValueUtil.getCurrencyFormatFromInt(
                CalcUtil.calcFinalFeeAmount(
                  inputData.minSalesAmountOfTop, 
                  CalcUtil.topDiscountPer,
                  inputData.addDiscountRate)
              ),
              ValueUtil.getCurrencyFormatFromInt(
                CalcUtil.calcFinalFeeAmount(
                  inputData.minSalesAmountOfPcRoom, 
                  CalcUtil.pcRoomDiscountPer,
                  inputData.addDiscountRate)
              ),
              ValueUtil.getCurrencyFormatFromInt(
                CalcUtil.calcFinalFeeAmount(
                  inputData.minSalesAmountOfTopAndPcRoom, 
                  CalcUtil.topAndPcRoomDiscountPer,
                  inputData.addDiscountRate)
              ),
            ),            
            Divider(color: Colors.black,),
            _buildRow(
              "최종받는금액\n(①-⑤)",
              ValueUtil.getCurrencyFormatFromInt(
                CalcUtil.finalReceivedAmount(
                  inputData.minSalesAmountOfTop, 
                  CalcUtil.topDiscountPer,
                  inputData.addDiscountRate)
              ),
              ValueUtil.getCurrencyFormatFromInt(
                CalcUtil.finalReceivedAmount(
                  inputData.minSalesAmountOfPcRoom, 
                  CalcUtil.pcRoomDiscountPer,
                  inputData.addDiscountRate)
              ),
              ValueUtil.getCurrencyFormatFromInt(
                CalcUtil.finalReceivedAmount(
                  inputData.minSalesAmountOfTopAndPcRoom, 
                  CalcUtil.topAndPcRoomDiscountPer,
                  inputData.addDiscountRate)
              ),
            ),       
            //-----------------------------------------------------
            SizedBox(height: 16.0,)
          ],
        )
      ),
    );
  }


  Widget _buildRow(String title, String text1, String text2, String text3) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: AutoSizeText(
              title,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              maxLines: 2,
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AutoSizeText(
                text1,
                maxLines: 1,
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: Colors.white70
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AutoSizeText(
                text2,
                maxLines: 1,
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: Colors.white70
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AutoSizeText(
                text3,
                maxLines: 1,
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: Colors.white70
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


}