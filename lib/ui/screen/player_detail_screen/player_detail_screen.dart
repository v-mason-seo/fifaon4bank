import 'package:fifa_on4_bank/core/constant/player_grade_color.dart';
import 'package:fifa_on4_bank/core/model/fifa_meta/player.dart';
import 'package:fifa_on4_bank/core/util/value_util.dart';
import 'package:fifa_on4_bank/ui/base_widget/base_widget.dart';
import 'package:fifa_on4_bank/ui/screen/player_comment/player_comment_page.dart';
import 'package:fifa_on4_bank/ui/screen/player_detail_info_page/player_detail_info_page.dart';
import 'package:fifa_on4_bank/ui/screen/player_detail_screen/player_detail_provider.dart';
import 'package:fifa_on4_bank/ui/screen/player_news/player_news_page.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_table/favorite_player/favorite_player_trade_provider.dart';
import 'package:fifa_on4_bank/ui/screen/search_player_trade_record/widget/search_player_trade_record_filter.dart';
import 'package:fifa_on4_bank/ui/widget/player_avatar.dart';
import 'package:fifa_on4_bank/ui/widget/player_grade_badge.dart';
import 'package:fifa_on4_bank/ui/widget/season_badge.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class PlayerDetailScreen extends StatefulWidget {

  final Player player;
  // final로 선언하지 않은 이유는 사용자가 직접 playerGrade를 변경할 수 있기 때문이다.
  int playerGrade;
  final int purchaseAmount;

  PlayerDetailScreen({
    this.player,
    this.playerGrade,
    this.purchaseAmount
  });

  @override
  _PlayerDetailScreenState createState() => _PlayerDetailScreenState();
}

class _PlayerDetailScreenState extends State<PlayerDetailScreen> with SingleTickerProviderStateMixin {

  final List<String> _tabs = ["시세", "News", "코멘트"];
  TabController tabController;
  ScrollController _scrollViewController;

  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: 3, vsync: this);
    _scrollViewController = ScrollController(initialScrollOffset: 0.0);
  }

  @override
  void dispose() {
    tabController?.dispose();
    _scrollViewController?.dispose();
    super.dispose();
  }


  Widget build(BuildContext context) {
    Player player = widget.player;
    int playerGrade = widget.playerGrade;

    return Consumer<FavoritePlayerTradeProvider>(
      builder: (context, favoriteModel, child) {
        return BaseWidget<PlayerDetailProvider>(
          model: PlayerDetailProvider(
            player: widget.player,
            playerGrade: widget.playerGrade,
            purchaseAmount: widget.purchaseAmount,
          ),
          onModelReady: (model) => model.loadData(),
          builder: (context, model, child) {

            if ( model.busy) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return Scaffold(
              body: NestedScrollView(
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverOverlapAbsorber(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                      sliver: SliverAppBar(
                        actions: [
                          IconButton(
                            icon: model.isFavorited
                              ? Icon(Icons.star, color: Colors.amber,)
                              : Icon(Icons.star_border),
                            onPressed: () {
                              model.isFavorited
                                ? favoriteModel.deleteFavoritePlayerById(player.id, playerGrade)
                                : favoriteModel.addFavoritePlayer(player, playerGrade);
                              
                              model.changeFavoritePlayer();
                            },
                          )
                        ],
                        flexibleSpace: FlexibleSpaceBar(
                          titlePadding: const EdgeInsets.all(24),
                          centerTitle: true,
                          title: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  //--------------------------
                                  SeasonBadgeImage(
                                    url: player.season.seasonImg,
                                    size: 20,
                                  ),
                                  //--------------------------
                                  SizedBox(width: 8.0,),
                                  //--------------------------
                                  PlayerGradeBadge(
                                    text: "$playerGrade",
                                    background: PlayerGradeColor.getColor(playerGrade),
                                    fontColor : PlayerGradeColor.getFontColor(playerGrade),
                                    onTap: () {
                                      _showFilterBottomSheet(context, model);
                                    },
                                  ),
                                  //--------------------------
                                  SizedBox(width: 12.0,),
                                  //--------------------------
                                  Text(player.name),
                                  //--------------------------
                                ],
                            ),
                          ),
                          background: Container(
                            child: Center(
                              child: PlayerAvatar(
                                url: ValueUtil.getPlayerImageUrl(player.id),
                                size: 78,
                              ),
                            ),
                          ),
                        ),
                        stretch: true,
                        floating: false,
                        pinned: true,
                        expandedHeight: 200.0,
                        forceElevated: innerBoxIsScrolled,
                      ),
                    ),
                    SliverPersistentHeader(
                      delegate: _SliverAppBarDelegate(
                        TabBar(
                          controller: tabController,
                          tabs: _tabs.map((e) => Tab(text: e)).toList(),
                        ),
                      ),
                      pinned: true,
                    ),
                  ];
                },
                body: Container(
                  margin: const EdgeInsets.only(top: 68),
                  child: TabBarView(
                    controller: tabController,
                    children:[
                      PlayerDetailInfoPage(
                        key: ValueKey("${player.id}-${widget.playerGrade}"),
                        player: player,
                        playerGrade: widget.playerGrade,
                        myPurchaseAmout: model.purchaseAmount,
                        //todo
                        //myPurchaseAmout: widget.playerTradeTableContent.purchaseAmount,
                      ),
                      PlayerNewsPage(
                        player: player,
                      ),
                      //-----------------------------------
                      //선수 코멘트
                      //-----------------------------------
                      PlayerCommentPage(
                        player: player,
                      ),
                    ]
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }


  _showFilterBottomSheet(BuildContext context, PlayerDetailProvider model) async {

    // var model = context.read<SearchPlayerTradeRecordProvider>();
    // List<String> gradeFilter = model.getCloneFilter();

    List<String> selectedGrade = await showCupertinoModalBottomSheet(
      context: context,
      expand: false,
      builder: (context, scrollController) {
        return SearchPlayerTradeRecordFilter(
          isMeultiSelect: false,
          selectedList: [widget.playerGrade.toString()],
        );
      }
    );

    if ( selectedGrade != null ) {
      setState(() {
        widget.playerGrade = int.tryParse(selectedGrade.first) ?? widget.playerGrade;
      });
      model.playerGrade = int.tryParse(selectedGrade.first) ?? widget.playerGrade;
      model.loadData();
    }
  }
}


class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}