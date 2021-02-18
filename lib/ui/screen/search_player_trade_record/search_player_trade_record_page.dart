import 'package:fifa_on4_bank/core/util/common_util.dart';
import 'package:fifa_on4_bank/ui/screen/search_player_trade_record/search_player_trade_record_provider.dart';
import 'package:fifa_on4_bank/ui/screen/search_player_trade_record/widget/player_trade_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

import 'model/search_player_trade_record.dart';

class SearchPlayerTradeRecordPage extends StatefulWidget {

  @override
  _SearchPlayerTradeRecordPageState createState() => _SearchPlayerTradeRecordPageState();
}


class _SearchPlayerTradeRecordPageState extends State<SearchPlayerTradeRecordPage> {

  final TextEditingController userNickNameController = TextEditingController();
  final SuggestionsBoxController _suggestionBoxController = SuggestionsBoxController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    userNickNameController.dispose();
    _suggestionBoxController?.close();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return Consumer<SearchPlayerTradeRecordProvider>(
      builder: (context, model, child) {

        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //-----------------------------
               SizedBox(height: 8,),
               //-----------------------------
               buildSuggestionSearchBar(),
              //-----------------------------
              Expanded(child: _buildBody()),
              //-----------------------------
              _buildBottomButton(),
              //-----------------------------
            ],
          ),
        );
      },
    ); 
  }

  Widget buildSuggestionSearchBar() {
    SearchPlayerTradeRecordProvider model = context.read<SearchPlayerTradeRecordProvider>();

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            //color: Colors.grey.shade300
            color: Theme.of(context).backgroundColor
          ),
          child: TypeAheadField(
            suggestionsBoxController: _suggestionBoxController,
            suggestionsBoxDecoration: SuggestionsBoxDecoration(
              elevation: 1.0,
              borderRadius: BorderRadius.circular(12.0),
              //color: Colors.grey.shade100,
            ),
            noItemsFoundBuilder: (context) {
              return null;
            },
            textFieldConfiguration: TextFieldConfiguration(
              controller: userNickNameController,
              autofocus: false,
              onSubmitted: (value) async {
                model.setSuggestions(value);
              },
              style: DefaultTextStyle.of(context).style.copyWith(
                fontStyle: FontStyle.italic
              ),
              onEditingComplete: () {
                FocusScope.of(context).unfocus();
                _handleSubmitted(userNickNameController.text);
              },
              decoration: InputDecoration(
                  //icon: Icon(Icons.person_outline),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                  border: InputBorder.none,
                  hintText: "감독명을 입력해주세요",
                  //hintStyle: const TextStyle(color: Color.fromRGBO(142, 142, 147, 1))
              )
            ),
            suggestionsCallback: (pattern) async {
              return await model.getSuggestions(pattern);
            },
            itemBuilder: (context, suggestion) {
              return Row(
                children: [
                  SizedBox(width: 16.0,),
                  Text(suggestion),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.close, size: 18.0),
                    onPressed: () {
                      model.deleteSuggestions(suggestion);
                      _suggestionBoxController.close();
                    },
                  )                                    
                ],
              );
            },
            onSuggestionSelected: (suggestion) {
              FocusScope.of(context).unfocus();
              userNickNameController.text = suggestion;
              _handleSubmitted(suggestion);
            },
          ),
        ),
        Positioned(
          right: 24,
          child: IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              FocusScope.of(context).unfocus();
              _handleSubmitted(userNickNameController.text);
            },
          ),
        )
      ]
    );
  }


  _handleSubmitted(String inputText) async {
    SearchPlayerTradeRecordProvider model = context.read<SearchPlayerTradeRecordProvider>();

    if ( CommonUtil.isNotEmpty(inputText)) {
      String nickName = inputText;
      await model.insertManager(nickName);
      model.searchPlayerTradeRecord(nickName);                
    }
  }


  Widget _buildBody() {

    SearchPlayerTradeRecordProvider model = context.read<SearchPlayerTradeRecordProvider>();

    if ( model.busy)
        return Center(child: CircularProgressIndicator(),);
    if (model.isExistsData())
      return _buildTransactionRecordListView();
    else 
      return Center(
        child: Text("데이터가 없습니다."),
      );
  }


  Widget _buildBottomButton() {
    SearchPlayerTradeRecordProvider model 
      = context.read<SearchPlayerTradeRecordProvider>();

    if ( model.getCheckedRowCount() == 0 ) {
      return Container();
    }

    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: MaterialButton(
            height: 48,
            color: Theme.of(context).buttonColor,
            child: Text("취소"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        Expanded(
          flex: 2,
          child: MaterialButton(
            height: 48,
            color: Theme.of(context).accentColor,
            child: Text("선택완료", style: TextStyle(color: Colors.white),),
            onPressed: () async {
              final checkedList = model.getCheckedList();
              model.insertPurchaseList();
              Navigator.pop(context, checkedList);
            },
          ),
        ),
      ],
    );
  }


  Widget _buildTransactionRecordListView() {

    SearchPlayerTradeRecordProvider model 
      = context.read<SearchPlayerTradeRecordProvider>();
    List<SearchPlayerTradeRecord> recordList 
      //= model.searchPlayerTradeRecordList;
      = model.filteredList;

    return ListView.separated(
      separatorBuilder: (context, index) {
        if ( index == 0) 
          return Container();

        return Divider();
      },
      itemCount: CommonUtil.isNotEmpty(recordList) ? recordList.length + 2 : 0,
      itemBuilder: (context, i) {

        if ( i == 0 ) {
          return Align(
            alignment: Alignment.centerRight,
            child: ButtonTheme(
              height: 20.0,
              minWidth: 40.0,
              child: FlatButton(
                color: Colors.transparent,
                child: Text(model.getCheckButtonTitle()),
                onPressed: () => model.changedAllItems(),
              ),
            ),
          );
        }

        if ( i == recordList.length+1) {
          return FlatButton(
            child: Text(
              model.getLoadMoreButtonName(),
              style: TextStyle(
                color: model.isEnableLoadMoreButton()  ? Colors.deepPurple : Colors.grey, 
                fontWeight: FontWeight.bold, 
                fontSize: 14.0),

            ),
            onPressed: model.isEnableLoadMoreButton() 
              ? () {
                  model.loadMorePlayerTradeRecord(userNickNameController.text, model.getRealDataOffset() + 1);
                } 
              : null,
          );
        }

        int index = i-1;
        SearchPlayerTradeRecord record = recordList[index];
        return PlayerTradeListTile(
          tradeRecord: record,
          onChaneged: (checked) {
            model.changedItem(record, checked);
          }
        );
      },
    );
  }
}