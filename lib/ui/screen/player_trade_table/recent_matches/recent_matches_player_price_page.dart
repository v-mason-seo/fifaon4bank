import 'dart:ui';

import 'package:fifa_on4_bank/core/model/fifa_meta/fifa_match_type.dart';
import 'package:fifa_on4_bank/core/util/common_util.dart';
import 'package:fifa_on4_bank/core/util/date_util.dart';
import 'package:fifa_on4_bank/ui/screen/match_detail/match_detail_screen.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_table/favorite_player/favorite_player_trade.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_table/favorite_player/favorite_player_trade_listview.dart';
import 'package:fifa_on4_bank/ui/widget/empty_page.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_table/recent_matches/recent_match_player_price.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_table/recent_matches/recent_matches_player_price_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class RecentMatchesPlayerPricePage extends StatefulWidget {
  @override
  _RecentMatchesPlayerPricePageState createState() => _RecentMatchesPlayerPricePageState();
}

class _RecentMatchesPlayerPricePageState extends State<RecentMatchesPlayerPricePage> {

  String nickName = "-";
  final SuggestionsBoxController _suggestionBoxController = SuggestionsBoxController();
  final TextEditingController userNickNameController = TextEditingController();


  List<DropdownMenuItem<FifaMatchType>> matchTypeItems = [];
  FifaMatchType selectedMatchType;


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    userNickNameController?.clear();
    _suggestionBoxController?.close();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<RecentMatchesPlayerPriceProvider>(
      builder: (context, model, child) {

        return Stack(
          children: [
            Center(
              child: Visibility(
                visible: model.matchIdList.length == 0/* && !_keyboardIsVisible()*/,
                child: buildEmptyPage(context),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //-------------------------------------------
                buildSearchBar(),
                //-------------------------------------------
                model.busy 
                ? Expanded(child: Center(child: CircularProgressIndicator(),))
                : Expanded(
                  child: /*model.matchIdList.length == 0
                  ? buildEmptyPage(context)
                  : */ListView.builder(
                    itemCount: model.matchList.length == 0 
                                  ? 0 
                                  : model.matchList.length + 1,
                    itemBuilder: (context, index) {

                      if ( index > 0 && index == model.matchList.length) {
                        return buildLoadMoreButton();
                      }

                      RecentMatchPlayerPrice match = model.matchList[index];
                      List<FavoritePlayerTrade> players = match.players;
                      return ExpansionTile(
                        initiallyExpanded: true,
                        title: buileExpansionTitle(match, model.nickName),
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.only(left: 32, right: 16),
                            title: Text("매치 상세 정보"),
                            trailing: Icon(Icons.chevron_right),
                            onTap: () {
                              Navigator.push(
                                  context, 
                                  MaterialPageRoute(builder: (context) => MatchDetailScreen(
                                    matchId: model.matchIdList[index],
                                  ))
                                );
                            },
                          ),
                          FavoritePlayerTradeListView(
                            items: players,
                            expansionCallback: (int playerIndex, bool isExpanded) {
                              model.changeExpanded(index, playerIndex);
                            }
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }


  Widget buildEmptyPage(BuildContext context) {

    Color accentColor = Theme.of(context).accentColor;

    return EmptyPage(
      icon: Icon(
        MdiIcons.soccer,
        size: 98,
        color: Colors.white.withOpacity(0.2),
      ),
      //-------------------------
      text: Text.rich(
        TextSpan(
          text: "경기 결과를 조회해보세요\n\n",
          children: [
            TextSpan(text: "최근 경기에서 사용한 \n"),
            TextSpan(text: "선수", style: TextStyle(color: accentColor)),
            TextSpan(text: "들의 현재가 및 현재가 기준으로\n"),
            TextSpan(text: " 손익분기점 금액을 확인할 수 있습니다.\n\n"),
            TextSpan(text: "또한, \n"),
            TextSpan(text: "매치 상세 정보", style: TextStyle(color: accentColor)),
            TextSpan(text: "도 확인할 수 있습니다."),
          ]
        ),
        style: TextStyle(
          fontSize: 17,
          color: Colors.white.withOpacity(0.8),
          height: 1.3,
        ),
        textAlign: TextAlign.center,
        overflow: TextOverflow.fade,
      ),
    );
  }


  





  Widget buildSearchBar() {
    return Consumer<RecentMatchesPlayerPriceProvider>(
      builder: (context, model, child) {
        return Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            buildMatchType(),
            Expanded(
              child: buildSuggestionSearchBar()
            ),
          ],
        );
      }
    );
  }


  Widget buildMatchType() {
    return Consumer<RecentMatchesPlayerPriceProvider>(
      builder: (context, model, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Theme.of(context).backgroundColor,
            // border: Border.all()
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          margin: const EdgeInsets.only(left: 12.0),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              dropdownColor: Theme.of(context).bottomAppBarColor,
              style: TextStyle(fontSize: 12.0),
              value: model.selectedMatchType,
              //items: model.matchTypeItems,
              items: model.matchTypeList == null 
                ? null 
                : model.matchTypeList.map((e) 
                    => DropdownMenuItem<FifaMatchType>(
                      value: e,
                      child: Text(
                        e.desc
                      ),
                    )
                  ).toList(),
              hint: Text("매치 종류"),
              onChanged: (matchType) {
                model.changeSelectedMatchType(matchType);
              },
            ),
          ),
        );
      }
    );
  }


  Widget buildSuggestionSearchBar() {

    return Consumer<RecentMatchesPlayerPriceProvider>(
      builder: (context, model, child) {
        return Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 8, right: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                //color: Colors.grey.shade300
                color: Theme.of(context).backgroundColor,
              ),
              child: TypeAheadField(
                suggestionsBoxController: _suggestionBoxController,
                suggestionsBoxDecoration: SuggestionsBoxDecoration(
                  color: Theme.of(context).bottomAppBarColor,
                  borderRadius: BorderRadius.circular(12.0),
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
                    _handleSubmitted(model, userNickNameController.text);
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
                  _handleSubmitted(model, suggestion);
                },
              ),
            ),
            Positioned(
              right: 24,
              child: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  _handleSubmitted(model, userNickNameController.text);
                },
              ),
            )
          ]
        );

      },
    );    
  }


  _handleSubmitted(RecentMatchesPlayerPriceProvider model, String inputText) async {

    if ( CommonUtil.isNotEmpty(inputText)) {
      String nickName = inputText;
      model.setNickName(nickName);
    }
  }


  ///
  /// 하단 loadMore 버튼 위젯
  ///
  Widget buildLoadMoreButton() {
    return Consumer<RecentMatchesPlayerPriceProvider>(

      builder: (context, model, child) {

        if ( model.isLoadingLoadMore) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return FlatButton(
          child: Text(
            model.getLoadMoreButtonName(),
            textAlign: TextAlign.center,
          ),
          onPressed: (){
            model.loadMore();
          }, 
        );
      },
    );
  }

  Widget buileExpansionTitle(RecentMatchPlayerPrice match, String nickName) {
    
    return ListTile(
      title: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: "(${match.getFirstResult()})  ",
              style: TextStyle(fontSize: 14)
            ),
            TextSpan(
              text: match.getFirstNickName()
            ),
            TextSpan(
              text: "   VS   ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)
            ),
            TextSpan(
              text: "(${match.getSecondResult()})  ",
              style: TextStyle(fontSize: 14)
            ),
            TextSpan(
              text: match.getSecondNickName()
            ),
          ]
        )
      ),
      subtitle: Text(
         DateUtils.getDateStringFromString("${match.matchDate}", format: "yyyy년 MM월 dd일 HH시 mm분"), 
         style: TextStyle(
           color: Colors.grey
         ),
      ),
    );
  }
}