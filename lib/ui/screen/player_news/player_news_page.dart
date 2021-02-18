import 'package:fifa_on4_bank/core/model/fifa_meta/player.dart';
import 'package:fifa_on4_bank/ui/base_widget/base_widget.dart';
import 'package:fifa_on4_bank/ui/screen/player_news/model/player_news.dart';
import 'package:fifa_on4_bank/ui/screen/player_news/paged_player_news_list_view.dart';
import 'package:fifa_on4_bank/ui/screen/player_news/player_news_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PlayerNewsPage extends StatelessWidget {

  final Player player;

  PlayerNewsPage({
    this.player
  });

  @override
  Widget build(BuildContext context) {
    return BaseWidget<PlayerNewsProvider>(
      model: PlayerNewsProvider(player: player),
      // onModelReady: (model) => model.loadData(),
      builder: (context, model, child) {

        return PagedPlayerNewsListView(
          playerId: player.id,
          onTapItem: (PlayerNews news) {
            model.updateNewsValuable();
            _launchURL(news.url);
          },
        );
      }
    );
  }

  _launchURL(String url) async {

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}