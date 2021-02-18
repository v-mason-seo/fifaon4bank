import 'package:fifa_on4_bank/core/api/fifa_on4_bank_api.dart';
import 'package:fifa_on4_bank/core/api/local_api.dart';
import 'package:fifa_on4_bank/core/provider/base_model.dart';
import 'package:fifa_on4_bank/core/service_locator/service_locator.dart';
import 'package:fifa_on4_bank/core/util/common_util.dart';
import 'package:fifa_on4_bank/ui/screen/player_comment/player_comment.dart';

class PlayerCommentProvider extends BaseModel {
  final int playerId;
  final FifaOn4BankApi api = serviceLocator.get<FifaOn4BankApi>();
  final LocalApi localApi = serviceLocator.get<LocalApi>();
  List<PlayerComment> playerComments;
  String writerName;
  bool _isVisibleFloatingActionButton = true;

  PlayerCommentProvider({
    this.playerId,
    //this.api,
    // this.localApi,
  });


  
  isVisibleFloatingActionButton() {
    return _isVisibleFloatingActionButton;
  }


  setVisibleFloatingActionButton(bool visible) {
    _isVisibleFloatingActionButton = visible;
    notifyListeners();
  }
  

  clearData() {
    playerComments?.clear();
  }

  ///
  /// 데이터 불러오기
  ///
  loadData() async {
    setBusy(true);

    try {
      writerName = await localApi.loadWriterName();
      playerComments = await api.getPlayerComments(playerId);
      setBusy(false);
    } catch(err) {
      setError(true, err.toString());
    }        
  }


  ///
  /// 데이터 더 불러오기
  ///
  loadMoreData() async {
    List<PlayerComment> morePlayerComments = await api.getPlayerComments(playerId);
    if ( playerComments == null )
      playerComments = [];

    playerComments.addAll(morePlayerComments);
    notifyListeners();
  }


  ///
  /// 선수 코멘트를 입력한다.
  ///
  insertPlayerComment(PlayerComment playerComment) async {
    
    try {
      // 기존에 등록된 작성자명과 다르면 새로운 작성자명을 저장
      if ( writerName != playerComment.writerName) {
        localApi.saveWriterName(playerComment.writerName);
      }
      
      // 서버에 데이터를 저장
      PlayerComment insertedPlayerComment = await api.insertPlayerComment(playerComment);
      
      // 입력한 코멘트를 리스트에 입력
      if ( CommonUtil.isNotEmpty(insertedPlayerComment)) {
        playerComments.insert(0, insertedPlayerComment);
        notifyListeners();
      }
    } catch(e) {
      setError(true, "코멘트 입력중 오류가 발생했습니다.");
    }
    
  }


  ///
  /// 이미 신고한 건인지 확인
  ///
  Future<bool> isAvailableReport(int commentId) async {
    
    String reportedCommentIdList = await localApi.loadReportedCommentIdList();

    if ( CommonUtil.isEmpty(reportedCommentIdList))
      return true;

    return !reportedCommentIdList.contains(commentId.toString());
  }


  ///
  /// 선수 코멘트 신고한건은 아이디를 저장한다.
  ///
  saveReportedCommentId(int commentId) async {
    localApi.saveReportedCommentId(commentId);
  }


  reportComment(PlayerComment playerComment) async {
    
    try {
      playerComment = await api.reportPlayerComment(playerComment.id);
      await saveReportedCommentId(playerComment.id);

      notifyListeners();
      return true;
    } catch(e) {
      return false;
    }
  }

  ///
  /// 신고처리된 건을 강제로 보기
  ///
  forceUpdateReportCount(PlayerComment playerComment) {

    playerComment.reportCount = 0;
    notifyListeners();

  }

}