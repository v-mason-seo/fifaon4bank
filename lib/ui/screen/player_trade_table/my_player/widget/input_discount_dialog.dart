import 'package:fifa_on4_bank/core/constant/fee_discount_rate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputDiscountDialog extends StatefulWidget {
  @override
  _InputDiscountDialog createState() => _InputDiscountDialog();
}


class _InputDiscountDialog extends State<InputDiscountDialog> {

  TextEditingController _discountRateController;

  @override
  void initState() {
    super.initState();
    _discountRateController = TextEditingController();
  }


  @override
  void dispose() {
    _discountRateController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0)
      ),
      elevation: 0.0,
      //backgroundColor: Colors.transparent,
      child: _buildDialogContent(),
    );
  }


  _buildDialogContent() {

    

    return Form(
      autovalidateMode: AutovalidateMode.always,
      child: Container(
        decoration: BoxDecoration(
          //color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: const Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //---------------------------------
            header(),
            //---------------------------------
            SizedBox(height: 16.0,),
            //---------------------------------
            discountRateButton(),
            //---------------------------------
            SizedBox(height: 24.0,),
            //---------------------------------
            Row(
              //mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    margin: const EdgeInsets.only(left: 16.0, right: 8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade600,
                        width: 1
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                      //color: Colors.grey
                    ),
                    child: discountRateField(),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    //padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    margin: const EdgeInsets.only(right: 16.0, left: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: Colors.blueGrey.shade400
                    ),
                    child: FlatButton(
                      child: Text("완료"),
                      onPressed: () {
                        handleSubmitted(_discountRateController.text);
                      },
                    ),
                  ),
                ),
              ],
            ),
            //---------------------------------
            SizedBox(height: 46.0,),
            //---------------------------------
          ]
        ),      
      ),
    );
  }


  Widget header() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade300,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "추가할인율 입력",
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }


  Widget discountRateButton() {
    List rate = FeeDiscountRate.rateList;

    return Material(      
      child: Wrap(
        children: List.generate(rate.length, (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 2.0),
          child: OutlineButton(
            child: Text("${rate[index]} %"),
            onPressed: () => Navigator.pop(context, rate[index])
            ),
          ),
        ),
      ),
    );
  }


  Widget discountRateField() {
    return TextFormField(
      controller: _discountRateController,
      autofocus: false,
      keyboardType: TextInputType.number,
      validator: validateDiscountRate,
      onFieldSubmitted: handleSubmitted,
      decoration: InputDecoration(
        suffixText: "%",
        border: InputBorder.none,
        hintText: "추가할인율을 입력하세요",
        hintStyle: const TextStyle(color: Color.fromRGBO(142, 142, 147, 1))
      ),
    );
  }

  String validateDiscountRate(String value) {
    int rate = int.tryParse(value) ?? 0;
    if ( rate > 100) {
      return '최대 할인율은 100입니다.';
    }

    return null;
  }

  void handleSubmitted(String value) {
    int rate = int.tryParse(value) ?? 777;
    if (rate <= 100) {
      Navigator.pop(context, rate);
    }
  }

}