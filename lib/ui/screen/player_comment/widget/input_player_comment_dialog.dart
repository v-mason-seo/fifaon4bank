import 'package:fifa_on4_bank/core/model/fifa_meta/player.dart';
import 'package:fifa_on4_bank/core/util/common_util.dart';
import 'package:fifa_on4_bank/ui/screen/player_comment/player_comment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputPlayerCommentDialog extends StatefulWidget {

  final Player player;
  final String writerName;

  InputPlayerCommentDialog({
    this.player,
    this.writerName,
  });

  @override
  _InputDiscountDialog createState() => _InputDiscountDialog();
}


class _InputDiscountDialog extends State<InputPlayerCommentDialog> {

  TextEditingController _writerNameController;
  TextEditingController _commentController;
  FocusNode _writerNameFocusNode;
  FocusNode _commentFocusNode;
  String _infoMessage;

  @override
  void initState() {
    super.initState();

    _writerNameController = TextEditingController();
    _commentController = TextEditingController();
    _writerNameFocusNode = FocusNode();
    _commentFocusNode = FocusNode();

    _writerNameController.text = widget.writerName ?? "";
    _infoMessage = "";
  }


  @override
  void dispose() {

    _writerNameController?.dispose();
    _commentController?.dispose();
    _writerNameFocusNode?.dispose();
    _commentFocusNode?.dispose();
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
            writerNameField(),
            //---------------------------------
            commentField(),
            //---------------------------------
            SizedBox(height: 12.0,),
            //---------------------------------
            Text(
              _infoMessage,
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.red.shade200
              ),
            ),
            //---------------------------------
            SizedBox(height: 12.0,),
            //---------------------------------
            bottomButton(),
          ]
        ),
      ),
    );
  }


  Widget header() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      height: 48,
      width: double.infinity,
      decoration: BoxDecoration(
        //color: Colors.blueGrey.shade400,
        color: Theme.of(context).accentColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "${widget.player.name} 코멘트 입력",
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }


  Widget bottomButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FlatButton(
          child: Text("취소"),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text("확인"),
          onPressed: (){
            
            _commentFocusNode.unfocus();
            _writerNameFocusNode.unfocus();

            if ( CommonUtil.isEmpty(_writerNameController.text) ) {
              setState(() {
                _infoMessage = "닉네임을 입력하세요";
              });
              return;
            }

            if ( CommonUtil.isEmpty(_commentController.text) ) {
              setState(() {
                _infoMessage = "코멘트(내용)를 입력하세요";
              });
              return;
            }

            PlayerComment playerComment = PlayerComment();
            playerComment.spid = widget.player.id;
            playerComment.writerName = _writerNameController.text;
            playerComment.comment = _commentController.text;
            Navigator.pop(context, playerComment);
            
          },
        ),
      ],
    );
  }


  Widget writerNameField() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextFormField(
        focusNode: _writerNameFocusNode,
        controller: _writerNameController,
        autofocus: false,
        validator: validateDiscountRate,
        maxLines: 1,
        textInputAction: TextInputAction.next,
        onChanged: (text) {
          if ( text != null) {
            setState(() {
              _infoMessage = "";
            });
          }
        },
        onFieldSubmitted: (text) {
          FocusScope.of(context).requestFocus(_commentFocusNode);
        },
        decoration: InputDecoration(
          hintText: "닉네임(감독명)을 입력하세요",
          hintStyle: const TextStyle(color: Color.fromRGBO(142, 142, 147, 1))
        ),
      ),
    );
  }


  Widget commentField() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextFormField(
        focusNode: _commentFocusNode,
        controller: _commentController,
        autofocus: false,
        keyboardType: TextInputType.multiline,
        maxLines: 5,
        minLines: 1,
        onChanged: (text) {
          if ( text != null) {
            setState(() {
              _infoMessage = "";
            });
          }
        },
        decoration: InputDecoration(
          hintText: "코멘트(내용)를 입력하세요",
          hintStyle: const TextStyle(color: Color.fromRGBO(142, 142, 147, 1))
        ),
      ),
    );
  }


  Widget discountRateField() {
    return TextFormField(
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