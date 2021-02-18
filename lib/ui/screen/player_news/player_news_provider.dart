import 'package:fifa_on4_bank/core/api/fifa_on4_bank_api.dart';
import 'package:fifa_on4_bank/core/api/player_value_count_type.dart';
import 'package:fifa_on4_bank/core/model/fifa_meta/player.dart';
import 'package:fifa_on4_bank/core/provider/base_model.dart';
import 'package:fifa_on4_bank/core/service_locator/service_locator.dart';
import 'package:fifa_on4_bank/core/util/value_util.dart';
import 'package:fifa_on4_bank/ui/screen/player_news/model/player_news.dart';

  const String LoadingIndicatorTitle = '^';

class PlayerNewsProvider extends BaseModel {

 
  static const int ItemRequestThreshold = 5;

  final FifaOn4BankApi api = serviceLocator.get<FifaOn4BankApi>(); 
  final Player player;


 List<PlayerNews> playerNews;

  PlayerNewsProvider({
    this.player,
  });


 clearData() {
    playerNews?.clear();
  }


 loadData() async {
   setBusy(true);

    try {
      int pid = ValueUtil.getPid(player.id);
      playerNews = await api.getPlayerNews(pid);
      
    } catch(e) {
      // print(e);
      playerNews = [];
    }


   setBusy(false);
 }


 ///
  /// 데이터 더 불러오기
  ///
  loadMoreData() async {
    List<PlayerNews> moreNews;
    int pid = ValueUtil.getPid(player.id);
    moreNews = await api.getPlayerNews(pid);
    if ( moreNews == null )
      moreNews = [];

    playerNews.addAll(moreNews);
    notifyListeners();
  }

  updateNewsValuable() {
    api.updateHit(player.id, PlayerValueCountType.newsValuable);
  }

  int _currentPage = 0;
  bool isPerformingMoreData = false;

  Future handleItemCreated(int index) async {
    var itemPosition = index + 1;
    var requestMoreData =
        itemPosition % ItemRequestThreshold == 0 && itemPosition != 0;
    var pageToRequest = itemPosition ~/ ItemRequestThreshold;

    if (requestMoreData && pageToRequest > _currentPage) {
      print('handleItemCreated | pageToRequest: $pageToRequest');
      _currentPage = pageToRequest;
      _showLoadingIndicator();

      // await Future.delayed(Duration(seconds: 5));
      // var newFetchedItems = List<String>.generate(
      //     15, (index) => 'Title page:$_currentPage item: $index');
      // _items.addAll(newFetchedItems);

      List<PlayerNews> moreNews;
      int pid = ValueUtil.getPid(player.id);
      await Future.delayed(Duration(seconds: 1));
      moreNews = await api.getPlayerNews(pid, offset: pageToRequest, limit: 5);
      if ( moreNews == null )
        moreNews = [];

      playerNews.addAll(moreNews);

      _removeLoadingIndicator();
    }
  }

  void _showLoadingIndicator() {
    // playerNews.add(LoadingIndicatorTitle);
    isPerformingMoreData = true;
    notifyListeners();
  }

  void _removeLoadingIndicator() {
    // playerNews.remove(LoadingIndicatorTitle);
    isPerformingMoreData = false;
    notifyListeners();
  }
}