import 'package:fifa_on4_bank/core/api/fifa_user_api.dart';
import 'package:fifa_on4_bank/core/model/fifa_meta/fifa_match.dart';
import 'package:fifa_on4_bank/core/provider/base_model.dart';
import 'package:fifa_on4_bank/core/service_locator/service_locator.dart';

class MatchDetailProvider extends BaseModel {

  final FifaUserApi fifaUserApi = serviceLocator.get<FifaUserApi>(); 
  String matchId;
  FifaMatch matchDetail;

  MatchDetailProvider({
    this.matchId,
  });

  loadData() async {
    setBusy(true);

    matchDetail = await fifaUserApi.getMatchDetailInfo(matchId);

    setBusy(false);
  }
}