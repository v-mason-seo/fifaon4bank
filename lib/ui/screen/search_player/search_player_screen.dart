import 'package:fifa_on4_bank/core/api/fifa_on4_bank_api.dart';
import 'package:fifa_on4_bank/core/model/fifa_meta/player.dart';
import 'package:fifa_on4_bank/core/service_locator/service_locator.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/material.dart';

import 'search_player_list_tile.dart';


class SearchPlayerScreen extends StatelessWidget {

  //final FifaMetaApi api;
  final FifaOn4BankApi api = serviceLocator.get<FifaOn4BankApi>();

  // SearchPlayerScreen({
  //   @required this.api,
  // });


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // todo - 선수 검색 조건 추가해야 함.
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: null, 
      //   label: Row(
      //     children: <Widget>[
      //       Icon(Icons.filter_list),
      //       SizedBox(width: 8.0,),
      //       Text('필터')
      //     ],
      //   )
      // ),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '선수 검색', 
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      //-----------------------------------------
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SearchBar(
            //searchBarController: ,
            //onSearch: api.searchLocalPlayer,
            textStyle: TextStyle(
              color: Theme.of(context).textTheme.caption.color
            ),
            onSearch: api.getPlayerByName,
            onItemFound: (Player player, int index) {
              return SearchPlayerListTile(player: player);
            },
            emptyWidget: Center(
              child: Text("데이터를 찾지 못했습니다.!!!"),
            ),
            onError: (error) {
              return Center(
                child: Text("데이터를 찾지 못했습니다."),
              );
            },
            searchBarStyle: SearchBarStyle(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              borderRadius: BorderRadius.circular(16.0)
            ),
            minimumChars: 2,
          ),
        ),
      ),
    );
  }

}


