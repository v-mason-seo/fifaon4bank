import 'package:fifa_on4_bank/ui/base_widget/base_widget.dart';
import 'package:fifa_on4_bank/ui/screen/match_detail/match_detail_page.dart';
import 'package:fifa_on4_bank/ui/screen/match_detail/match_detail_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MatchDetailScreen extends StatelessWidget {

  final String matchId;

  MatchDetailScreen({
    @required this.matchId,
  });

  @override
  Widget build(BuildContext context) {

    //print("[MatchDetailScreen] matchId : $matchId");
    return Scaffold(
      appBar: AppBar(
        title: Text("매치 상세 기록 조회"),
      ),
      body: BaseWidget<MatchDetailProvider>(
        model: MatchDetailProvider(
          matchId: matchId,
        ),
        onModelReady: (model) => model.loadData(),
        builder: (context, model, child) {
          return MatchDetailPage();
        },
      ),
    );
  }
}