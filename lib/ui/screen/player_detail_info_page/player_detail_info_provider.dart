import 'package:fifa_on4_bank/core/api/fifa_on4_bank_api.dart';
import 'package:fifa_on4_bank/core/model/fifa_meta/player.dart';
import 'package:fifa_on4_bank/core/provider/base_model.dart';
import 'package:fifa_on4_bank/core/service_locator/service_locator.dart';
import 'package:fifa_on4_bank/core/util/common_util.dart';
import 'package:fifa_on4_bank/ui/screen/player_detail_info_page/model/max_min_trade_price.dart';
import 'package:fifa_on4_bank/ui/screen/player_detail_info_page/model/purchase_info.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_table/my_player/model/current_price.dart';

class PlayerDetailInfoProvider extends BaseModel {

  final Player player;
  final int playerGrade;
  final int purchaseAmount;
  final FifaOn4BankApi api = serviceLocator.get<FifaOn4BankApi>();
  
  MinMaxTradePrice minMaxTradePrice;
  CurrentPrice currentPrice;
  List<CurrentPrice> currentPriceByGrade;
  

  PlayerDetailInfoProvider({
    this.player,
    this.playerGrade,
    this.purchaseAmount,
    //this.api
  });


  ///
  /// 데이터 불러오기
  ///
  loadData() async {

    setBusy(true);   

    try {
      minMaxTradePrice = await api.getMaxMinTradePrice(player.id, playerGrade);
    } catch(e) {
      minMaxTradePrice = MinMaxTradePrice(
        spid: player.id,
        grade: playerGrade,
        name: player.name,
        purchaseInfo: PurchaseInfo()
      );
    }

    try {
      currentPrice = await api.getCurrentDetailPrice(player.id, playerGrade);
    }catch(e) {
      currentPrice = CurrentPrice();
    }


    try {
      currentPriceByGrade = await loadCurrentPriceByGrade(player.id);
    }catch(e) {
      currentPriceByGrade = [];
    }

    if ( currentPriceByGrade.length > 2) {
      //배수 계산하기
      for(int i=1; i < currentPriceByGrade.length; i++) {
        int prePrice = currentPriceByGrade[i-1].presentPrice;
        int curPrice = currentPriceByGrade[i].presentPrice;

        if ( CommonUtil.isNotEmpty(prePrice) && CommonUtil.isNotEmpty(curPrice)) {
          double amountMultiple = curPrice / prePrice;
          currentPriceByGrade[i].amountMultiple = amountMultiple;
        }
      }
    }
    
    setBusy(false);
  }



  ///
  /// 등급별 현재시세
  ///
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

    } catch(e) {
      currentPriceList = [];
    }

    return currentPriceList;

  }

  
}