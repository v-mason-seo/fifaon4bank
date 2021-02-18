import 'package:fifa_on4_bank/core/model/fifa_meta/fifa_match.dart';
import 'package:fifa_on4_bank/ui/widget/card/rounded_card.dart';
import 'package:fifa_on4_bank/ui/widget/card/two_text_card_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MatchInfoCard extends StatelessWidget{

  final FifaMatchDetail leftMatchDetail;
  final FifaMatchDetail rightMatchDetail;

  MatchInfoCard({
    @required this.leftMatchDetail,
    @required this.rightMatchDetail,
  });

  @override
  Widget build(BuildContext context) {
    return RoundedCard(
      childWidget: Column(
        children: [
          TwoTextCardRow(leftText: "${leftMatchDetail.matchResult}", title: "매치 결과", rightText: "${rightMatchDetail.matchResult}"),
          TwoTextCardRow(leftText: "${leftMatchDetail.matchEndType}", title: "매치종료 타입", rightText: "${rightMatchDetail.matchEndType}"),
          TwoTextCardRow(leftText: "${leftMatchDetail.systemPause}", title: "게임 일시정지 수", rightText:  "${rightMatchDetail.systemPause}"),
          TwoTextCardRow(leftText: "${leftMatchDetail.foul}", title: "파울 수", rightText: "${rightMatchDetail.foul}"),
          TwoTextCardRow(leftText: "${leftMatchDetail.injury}", title: "부상 수", rightText: "${rightMatchDetail.injury}"),
          TwoTextCardRow(leftText: "${leftMatchDetail.redCards}", title: "레드카드", rightText: "${rightMatchDetail.redCards}"),
          TwoTextCardRow(leftText: "${leftMatchDetail.yellowCards}", title: "옐로우카드", rightText: "${rightMatchDetail.yellowCards}"),
          TwoTextCardRow(leftText: "${leftMatchDetail.dribble}", title: "드리블 거리\n(야드)", rightText: "${rightMatchDetail.dribble}"),
          TwoTextCardRow(leftText: "${leftMatchDetail.cornerKick}", title: "코너킥 수", rightText: "${rightMatchDetail.cornerKick}"),
          TwoTextCardRow(leftText: "${leftMatchDetail.possession}", title: "어프사이드 수", rightText: "${rightMatchDetail.possession}"),
          TwoTextCardRow(leftText: "${leftMatchDetail.averageRating}", title: "경기 평점", rightText: "${rightMatchDetail.averageRating}"),
          TwoTextCardRow(leftText: "${leftMatchDetail.controller}", title: "컨트롤러", rightText: "${rightMatchDetail.controller}"),
          TwoTextCardRow(leftText: "${leftMatchDetail.possession}", title: "점유율", rightText: "${rightMatchDetail.possession}"),
        ],
      ),
    );
  }
}