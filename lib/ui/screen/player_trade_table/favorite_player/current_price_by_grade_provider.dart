import 'package:fifa_on4_bank/core/api/fifa_on4_bank_api.dart';
import 'package:fifa_on4_bank/core/provider/base_model.dart';
import 'package:fifa_on4_bank/core/service_locator/service_locator.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_table/my_player/model/current_price.dart';

class CurrentPriceByGradeProvider extends BaseModel {
  final int playerId;
  final FifaOn4BankApi serverApi = serviceLocator.get<FifaOn4BankApi>();
  List<CurrentPrice> currentPriceList = [];

  CurrentPriceByGradeProvider({
    this.playerId
  });


  loadCurrentPriceByGrade() async {

    setBusy(true);

    //Future.delayed(Duration(seconds: 3));
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

    setBusy(false);

  }
}