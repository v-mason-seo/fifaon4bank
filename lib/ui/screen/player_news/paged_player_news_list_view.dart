import 'package:fifa_on4_bank/core/api/fifa_on4_bank_api.dart';
import 'package:fifa_on4_bank/core/service_locator/service_locator.dart';
import 'package:fifa_on4_bank/core/util/date_util.dart';
import 'package:fifa_on4_bank/core/util/value_util.dart';
import 'package:fifa_on4_bank/ui/screen/player_news/model/player_news.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class PagedPlayerNewsListView extends StatefulWidget {

  final int playerId;
  final Function(PlayerNews news) onTapItem;

  PagedPlayerNewsListView({
    @required this.playerId,
    this.onTapItem
  });

  @override
  _PagedPlayerNewsListViewState createState() => _PagedPlayerNewsListViewState();
}

class _PagedPlayerNewsListViewState extends State<PagedPlayerNewsListView> {

  static const _pageSize = 20;

  final FifaOn4BankApi api = serviceLocator.get<FifaOn4BankApi>(); 
  final _pagingController = PagingController<int, PlayerNews>(
    firstPageKey: 1,
  );

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });

    super.initState();
  }

  @override dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      int pid = ValueUtil.getPid(widget.playerId);
      final newItems = await api.getPlayerNews(pid, offset: pageKey, limit: _pageSize);
      final isLastPage = newItems.length < _pageSize;
      if ( isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  
  @override
  Widget build(BuildContext context) {

    return RefreshIndicator(
      onRefresh: () => Future.sync(() => _pagingController.refresh()),
      child: PagedListView.separated(
        pagingController: _pagingController, 
        // padding: const EdgeInsets.only(left: 12, right: 12, top: 16, bottom: 12),
        separatorBuilder: (context, index) => Divider(),
        builderDelegate: PagedChildBuilderDelegate<PlayerNews>(
          itemBuilder: (context, news, index) {
            return ListTile(
              leading: Text(
                DateUtils.getDateStringFromString(news.created, format: "MM.dd"),
                style: TextStyle(
                  color: Colors.white54
                ),
              ),
              title: Text(news.title),
              onTap: () {
                return widget.onTapItem(news);
              },
              trailing: Icon(Icons.chevron_right),
            );
          },
          firstPageErrorIndicatorBuilder: (context) {
            return Center(child: Text("error"),);
          },
          noItemsFoundIndicatorBuilder: (context) {
            return emptyWidget();
          }
        ), 
      ), 
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
            "등록된 뉴스가 없습니다.",
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
}