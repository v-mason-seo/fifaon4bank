import 'package:fifa_on4_bank/core/util/common_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {

  final String defaultText;
  final ValueChanged<String> onPressed;

  SearchField({
    this.defaultText = "",
    this.onPressed
  });

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {


  TextEditingController _writerNameController;
  FocusNode _writerNameFocusNode;
  bool isVisibleSuffixIcon = true;


  @override
  void initState() {
    super.initState();
    _writerNameController = TextEditingController(text: widget.defaultText);
    _writerNameFocusNode = FocusNode();
    if ( CommonUtil.isEmpty(_writerNameController.text) ) {
      isVisibleSuffixIcon = false;
    }
  }

  @override
  void dispose() {
    _writerNameController?.dispose();
    _writerNameFocusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: writerNameField()
          ),
          SizedBox(width: 24,),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              _writerNameFocusNode.unfocus();
              widget.onPressed(_writerNameController.text);
            },
          )
        ],
      ),
    );
  }

  Widget writerNameField() {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        //----------------------------------------
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(142, 142, 147, .15),
            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
          ),
          child: TextFormField(
            focusNode: _writerNameFocusNode,
            controller: _writerNameController,
            autofocus: false,
            maxLines: 1,
            textInputAction: TextInputAction.search,
            onFieldSubmitted: (text) => widget.onPressed(text),
            style: TextStyle(
              fontSize: 15.0
            ),
            //----------------------------------------
            onChanged: (text) {
              setState(() {
                CommonUtil.isEmpty(text)
                  ? isVisibleSuffixIcon = false
                  : isVisibleSuffixIcon = true;
              });
            },
            //----------------------------------------
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "닉네임(감독명)을 입력하세요",
              hintStyle: const TextStyle(color: Color.fromRGBO(142, 142, 147, 1))
            ),
          ),
        ),
        //----------------------------------------
        if (isVisibleSuffixIcon)
          IconButton(
            icon: Icon(
              Icons.highlight_remove_rounded,
              color: Colors.grey,
            ),
            onPressed: () {
              _writerNameController.clear();
              _writerNameFocusNode.unfocus();
              setState(() {
                isVisibleSuffixIcon = false;
              });
            },
          ),
        //----------------------------------------
      ],
    );
  }
}