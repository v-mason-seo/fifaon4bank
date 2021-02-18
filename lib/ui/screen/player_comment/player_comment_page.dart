import 'package:fifa_on4_bank/core/model/fifa_meta/player.dart';
import 'package:fifa_on4_bank/core/util/common_util.dart';
import 'package:fifa_on4_bank/ui/base_widget/base_widget.dart';
import 'package:fifa_on4_bank/ui/screen/player_comment/player_comment.dart';
import 'package:fifa_on4_bank/ui/screen/player_comment/player_comment_provider.dart';
import 'package:fifa_on4_bank/ui/screen/player_comment/widget/input_player_comment_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class PlayerCommentPage extends StatefulWidget {

  final Player player;

  PlayerCommentPage({
    this.player
  });

  @override
  _PlayerCommentPageState createState() => _PlayerCommentPageState();
}

class _PlayerCommentPageState extends State<PlayerCommentPage> {

  BuildContext ctx;

  @override
  Widget build(BuildContext context) {
    return BaseWidget<PlayerCommentProvider>(
      model: PlayerCommentProvider(
        playerId: widget.player.id
      ),
      onModelReady: (model) => model.loadData(),
      builder: (context, model, child) {

        ctx = context;
        return RefreshIndicator(
          onRefresh: () async {
            model.clearData();
            await Future.delayed(Duration(seconds: 1));
            return await model.loadData();
          },
          child: Stack(
            children: [
              buildBody(),
              Positioned(
                bottom: 24,
                right: 16,
                child: AnimatedOpacity(
                  opacity: model.isVisibleFloatingActionButton() ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 500),
                  child: FloatingActionButton.extended(
                    onPressed: () => _showInputPlsyerCommentDialog(), 
                    label: Text("글쓰기"),
                    icon: Icon(Icons.create),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget buildBody() {
    return Consumer<PlayerCommentProvider>(
      builder: (context, model, _) {

        if ( model.isError) {
          String erroeMessage = model.errorMessage;
          model.setError(false, erroeMessage);
          return Center(
            child: Text(model.errorMessage),
          );
        } else if ( model.busy) {
          return Center(child: CircularProgressIndicator(),);
        } else if ( CommonUtil.isEmpty(model.playerComments)) {
          return emptyWidget();
        }
        else {
          return buildCommentListView(model.playerComments);
        }

      },
    );
  }

  Widget emptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.info_outline,
            size: 64,
            color: Colors.white38,
          ),
          SizedBox(height: 24,),
          Text(
            "등록된 코멘트가 없습니다.",
            style: TextStyle(
              color: Colors.white38,
              fontSize: 14
            ),
          ),
          SizedBox(height: 48,),
        ],
      ),
    );
  }


  Widget buildCommentListView(List<PlayerComment> items) {

    return ListView.separated(
      separatorBuilder: (_, index) => Divider(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        PlayerComment item = items[index];
        return _buildPlayerCommentTile(item);        
      }
    );
  }


  Widget _buildPlayerCommentTile(PlayerComment comment) {

    DateTime created = DateTime.parse(comment.created);

    //todo - 신고된 코멘트 처리하기
    if ( comment.reportCount > 15 ) {

      PlayerCommentProvider model = ctx.read<PlayerCommentProvider>();

      return ListTile(
          contentPadding: const EdgeInsets.only(
            left: 16.0, right: 8.0,
            top: 0, bottom: 0
          ),
          leading: IconButton(
            icon: Icon(Icons.lock),
            onPressed: () {
              model.forceUpdateReportCount(comment);
            },
          ),
          title: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              "${comment.reportCount}건 신고 된 내용입니다.\n그래도 보실려면 자물쇠 버튼을 눌러주세요",
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
                decoration: TextDecoration.lineThrough,
                decorationThickness: 4
              ),
            ),
          ),
          subtitle: Row(
            children: [
              Text(
                comment.writerName,
                style: TextStyle(
                  color: Colors.tealAccent.shade100
                ),
              ),
              Spacer(),
              Text(
                timeago.format(created),
                style: TextStyle(
                  fontSize: 11
                ),
              ),
            ],
          ),
        );

    }

    return ListTile(
          contentPadding: const EdgeInsets.only(
            left: 16.0, right: 8.0,
            top: 0, bottom: 0
          ),
          title: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text("${comment.comment}"),
          ),
          //subtitle: Text(item.writerName),
          subtitle: Row(
            children: [
              Text(
                comment.writerName,
                style: TextStyle(
                  color: Colors.tealAccent.shade100
                ),
              ),
              Spacer(),
              Text(
                timeago.format(created),
                style: TextStyle(
                  fontSize: 11
                ),
              ),
            ],
          ),
          trailing: _showReportPopupMenu(comment),
        );
  }

  _showInputPlsyerCommentDialog() async {

    PlayerCommentProvider model = ctx.read<PlayerCommentProvider>();
    model.setVisibleFloatingActionButton(false);

    var playerComment = await showDialog(
      context: ctx,
      builder: (BuildContext context) {
        return InputPlayerCommentDialog(
          player: widget.player,
          writerName: model.writerName,
        );
      },
    );

    model.setVisibleFloatingActionButton(true);

    if ( playerComment != null ) {
      model.insertPlayerComment(playerComment);
    }
  }


  ///
  /// 더보기 메뉴 팝업
  ///
  Widget _showReportPopupMenu(PlayerComment comment)  {

    return PopupMenuButton<int>(
      onSelected: (value) async {

        //신고하기
        if ( value == 1) {
          PlayerCommentProvider model = ctx.read<PlayerCommentProvider>();
            
          if ( await model.isAvailableReport(comment.id) ) {
            await model.reportComment(comment);
            Fluttertoast.showToast(
              msg: "신고되었습니다.",
              gravity: ToastGravity.TOP
            );
          } else {
            Fluttertoast.showToast(
              msg: "이미 신고한 건입니다.",
              gravity: ToastGravity.TOP
            );
          }
        } 
        // 기타
        else {

        }

    },
    itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Row(
            children: [
              Icon(
                MdiIcons.cards, 
                size: 18,
                color: Colors.yellow.shade200,
              ),
              SizedBox(width: 8,),
              Text("신고하기"),
            ],
          )
        ),
      ],
    );
  }
}