import 'package:fifa_on4_bank/core/api/fifa_on4_bank_api.dart';
import 'package:fifa_on4_bank/core/constant/player_grade_color.dart';
import 'package:fifa_on4_bank/core/model/fifa_meta/player.dart';
import 'package:fifa_on4_bank/core/service_locator/service_locator.dart';
import 'package:fifa_on4_bank/core/util/calc_util.dart';
import 'package:fifa_on4_bank/core/util/common_util.dart';
import 'package:fifa_on4_bank/core/util/value_util.dart';
import 'package:fifa_on4_bank/ui/screen/player_detail_screen/player_detail_screen.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_table/favorite_player/favorite_player_trade.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_table/my_player/model/current_price.dart';
import 'package:fifa_on4_bank/ui/widget/player_avatar.dart';
import 'package:fifa_on4_bank/ui/widget/player_grade_badge.dart';
import 'package:fifa_on4_bank/ui/widget/rounded_corner_container.dart';
import 'package:fifa_on4_bank/ui/widget/season_badge.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritePlayerTradeListView extends StatelessWidget {

  final List<FavoritePlayerTrade> items;
  final ExpansionPanelCallback expansionCallback;

  FavoritePlayerTradeListView({
    this.items,
    this.expansionCallback,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expandedHeaderPadding: const EdgeInsets.all(0),
      elevation: 12,
      expansionCallback: expansionCallback,
      //------------------------------------------
      children: items.map<ExpansionPanel>( (FavoritePlayerTrade item) {
        return ExpansionPanel(
          canTapOnHeader: true,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return _buildHeader(context, item);
          },
          //------------------------------------------
          body: FutureProvider<List<CurrentPrice>>(
            create: (_) async => loadCurrentPriceByGrade(item.player.id),
            child: Container(
              child: Consumer<List<CurrentPrice>>(
                builder: (context, data, child) {
                  if ( data == null)  {
                    return Container(
                      height: 64,
                      child: Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator()
                        ),
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    child: Column(
                        children: List.generate(data.length + 1, (index) {

                          if ( index == 0) {
                            return Column(
                              children: [
                                Divider(),
                                Center(
                                  child: Text(
                                    "등급별 현재가",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }

                          CurrentPrice price = data[index-1];
                          return _buildCurrentPrice(
                            price.grade, 
                            "${ValueUtil.getCurrencyFormatFromInt(price.presentPrice)}  BP",
                            price.amountMultiple
                          );
                        } 
                      ),
                    ),
                  );
                },
              ),
            )
          ),
          /*
          body: BaseWidget<CurrentPriceByGradeProvider>(
            model: CurrentPriceByGradeProvider(playerId: item.player.id,),
            onModelReady: (model) => model.loadCurrentPriceByGrade(),
            builder: (context, priceModel, child) {
              if ( priceModel.busy) {
                return Container(
                  height: 48,
                  child: CircularProgressIndicator(),
                );
              }

              return Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: Column(
                    children: List.generate(priceModel.currentPriceList.length + 1, (index) {

                      if ( index == 0) {
                        return Center(
                          child: Text(
                            "등급별 현재가",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }

                      CurrentPrice price = priceModel.currentPriceList[index-1];
                      return _buildCurrentPrice(
                        price.grade, 
                        "${ValueUtil.getCurrencyFormatFromInt(price.presentPrice)}  BP"
                      );
                    } 
                  ),
                ),
              );
            },
          ),
          */
          //------------------------------------------
          isExpanded: item.isExpanded
          //------------------------------------------
          );
        }
      ).toList()
    );    
  }

  Widget _buildHeader(BuildContext context, FavoritePlayerTrade item) {
    return ListTile(
      leading: GestureDetector(
        child: PlayerAvatar(
          size: 38,
          url: ValueUtil.getPlayerImageUrl(item.player.id),
        ),
        onTap: () {
          handleClickPlayerCell(context, item.player, item.playerGrade);
        },
      ),
      title: _buildTitle(item),
      subtitle: Column(
        children: [
          SizedBox(height: 8,),
          _buildRow(
            "현재가", 
            "${item.getCurrentPrice()} BP",
            null
          ),
          _buildRow(
            "TOP", 
            "${getCalcValue("TOP", item.currentPrice?.presentPrice)} BP",
            Colors.lime[300]            
          ),
          _buildRow(
            "PC방", 
            "${getCalcValue("PC", item.currentPrice?.presentPrice)} BP",
            Colors.deepPurple[200]
          ),
          _buildRow(
            "TOP+PC방", 
            "${getCalcValue("TOP_PC", item.currentPrice?.presentPrice)} BP",
            Colors.cyan[400]
          ),
        ],
      ),
    );
  }

  String getCalcValue(String type, int amount) {

    if ( amount == null || amount == 0)
      return "-";

    if ( type == "TOP") {
      int calValue = CalcUtil.calcMinSalesAmountOfTop(amount);
      return ValueUtil.getCurrencyFormatFromInt(calValue);
    } else if (type == "PC") {
      int calValue = CalcUtil.calcMinSalesAmountOfPcRoom(amount);
      return ValueUtil.getCurrencyFormatFromInt(calValue);
    } else if (type == "TOP_PC") {
      int calValue = CalcUtil.calcMinSalesAmountOfTopAndPcRoom(amount);
      return ValueUtil.getCurrencyFormatFromInt(calValue);
    }

    return "-";

  }

  handleClickPlayerCell(BuildContext context, Player player, int playerGrade) {
    return Navigator.push(
        context, 
        MaterialPageRoute(builder: (context) 
          => PlayerDetailScreen(
            player: player,
            playerGrade: playerGrade,
          )
      )
    );
  }


  Widget _buildRow(String title, String value, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Text(title, style: TextStyle(color: textColor),),
          Spacer(),
          Text(value, style: TextStyle(color: textColor),)
        ],
      ),
    );
  }


  Widget _buildTitle(FavoritePlayerTrade item) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SeasonBadgeImage(
              size: 20,
              url: item.player.season.seasonImg,
            ),
            SizedBox(width: 12.0,),
            PlayerGradeBadge(
              text: "+${item.playerGrade}",
              background: PlayerGradeColor.getColor(item.playerGrade),
              fontColor : PlayerGradeColor.getFontColor(item.playerGrade)
            ),
            SizedBox(width: 12.0,),
            Text(item.player.name)
          ],                  
        ),
      ],
    );
  }

  Widget _buildCurrentPrice(int grade, String price, double multiple) {
    return Padding(
      padding: const EdgeInsets.only(left: 1.0, right: 1.0, top: 1.0, bottom: 1.0),
      child: Row(
          children: [
            //-----------------------------------
            PlayerGradeBadge(
              text: "$grade",
              background: PlayerGradeColor.getColor(grade),
              fontColor : PlayerGradeColor.getFontColor(grade)
            ),
            //-----------------------------------
            if ( multiple != null )
            RoundedCornerContainer(
              text: "X ${multiple.toStringAsFixed(2)}",
              backgroundColor: Colors.blueGrey,
              foreColor: Colors.white,
            ),
            //-----------------------------------
            Spacer(),
            //-----------------------------------
            Text(
              price,
              style: TextStyle(
                //color: Theme.of(context).textTheme.caption.color,
                color: grade == 1 
                  ? Colors.grey
                  : PlayerGradeColor.getColor(grade)
              ),
            ),
            //-----------------------------------
          ],
        ),
    );
  }


  Future<List<CurrentPrice>> loadCurrentPriceByGrade(int playerId) async {


    final FifaOn4BankApi serverApi = serviceLocator.get<FifaOn4BankApi>();
    List<CurrentPrice> currentPriceList = [];
    
    try {

      List<int> idList = [];
      List<int> gradeList = [];

      List.generate(10, (index) {
        idList.add(playerId);
        gradeList.add(index+1);
      });

      List<CurrentPrice> responseList = await serverApi.getCurrentPriceList(idList, gradeList);
      Map<int, CurrentPrice> mapPriceList = Map.fromIterable(
        responseList,
        key: (v) => v.grade,
        value: (v) => v
      );

      List.generate(10, (index) {
        int grade = index + 1;
        if ( mapPriceList.containsKey(grade) ) {
          currentPriceList.add(mapPriceList[grade]);
        } else {
          currentPriceList.add(CurrentPrice(
            spid: playerId,
            grade: grade,
            presentPrice: null,
          ));
        }
      });


      //배수 계산하기
      for(int i=1; i < currentPriceList.length; i++) {
        int prePrice = currentPriceList[i-1].presentPrice;
        int curPrice = currentPriceList[i].presentPrice;

        if ( CommonUtil.isNotEmpty(prePrice) && CommonUtil.isNotEmpty(curPrice)) {
          double amountMultiple = curPrice / prePrice;
          currentPriceList[i].amountMultiple = amountMultiple;
        }
      }

    } catch(e) {
      currentPriceList = [];
    }

    return currentPriceList;

  }
}