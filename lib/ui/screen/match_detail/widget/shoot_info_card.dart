import 'package:fifa_on4_bank/core/model/fifa_match/fifa_shoot.dart';
import 'package:fifa_on4_bank/ui/widget/card/rounded_card.dart';
import 'package:fifa_on4_bank/ui/widget/card/two_text_card_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShootInfoCard extends StatelessWidget{

  final FifaShoot leftShoot;
  final FifaShoot rightShoot;

  ShootInfoCard({
    @required this.leftShoot,
    @required this.rightShoot,
  });

  @override
  Widget build(BuildContext context) {
    return RoundedCard(
      childWidget: Column(
        children: [
          //-------------------------------------------
          TwoTextCardRow(
            leftText: "${leftShoot.shootTotal}",
            rightText: "${rightShoot.shootTotal}",
            title: "총 슛 수",
          ),
          //-------------------------------------------
          TwoTextCardRow(
            leftText: "${leftShoot.effectiveShootTotal}",
            rightText: "${rightShoot.effectiveShootTotal}",
            title: "총 유효슛 수",
          ),
          //-------------------------------------------
          TwoTextCardRow(
            leftText: "${leftShoot.shootOutScore}",
            rightText: "${rightShoot.shootOutScore}",
            title: "승부차기 슛 수",
          ),
          //-------------------------------------------
          TwoTextCardRow(
            leftText: "${leftShoot.goalTotal}",
            rightText: "${rightShoot.goalTotal}",
            title: "총 골 수\n(실제 골 수)",
          ),
          //-------------------------------------------
          TwoTextCardRow(
            leftText: "${leftShoot.goalTotalDisplay}",
            rightText: "${rightShoot.goalTotalDisplay}",
            title: "몰수승",
          ),
          //-------------------------------------------
          TwoTextCardRow(
            leftText: "${leftShoot.ownGoal}",
            rightText: "${rightShoot.ownGoal}",
            title: "자책 골 수",
          ),
          //-------------------------------------------
          TwoTextCardRow(
            leftText: "${leftShoot.shootHeading}",
            rightText: "${rightShoot.shootHeading}",
            title: "헤딩 슛 수",
          ),
          //-------------------------------------------
          TwoTextCardRow(
            leftText: "${leftShoot.goalHeading}",
            rightText: "${rightShoot.goalHeading}",
            title: "헤딩 골 수",
          ),
          //-------------------------------------------
          TwoTextCardRow(
            leftText: "${leftShoot.shootFreekick}",
            rightText: "${rightShoot.shootFreekick}",
            title: "프리킥 슛 수",
          ),
          //-------------------------------------------
          TwoTextCardRow(
            leftText: "${leftShoot.goalFreekick}",
            rightText: "${rightShoot.goalFreekick}",
            title: "프리킥 골 수",
          ),
          //-------------------------------------------
          TwoTextCardRow(
            leftText: "${leftShoot.shootInPenalty}",
            rightText: "${rightShoot.shootInPenalty}",
            title: "인패널티 슛 수",
          ),
          //-------------------------------------------
          TwoTextCardRow(
            leftText: "${leftShoot.goalInPenalty}",
            rightText: "${rightShoot.goalInPenalty}",
            title: "인패널티 골 수",
          ),
          //-------------------------------------------
          TwoTextCardRow(
            leftText: "${leftShoot.shootOutPenalty}",
            rightText: "${rightShoot.shootOutPenalty}",
            title: "아웃패널티 슛 수",
          ),
          //-------------------------------------------
          TwoTextCardRow(
            leftText: "${leftShoot.goalOutPenalty}",
            rightText: "${rightShoot.goalOutPenalty}",
            title: "아웃패널티 골 수",
          ),
          //-------------------------------------------
          TwoTextCardRow(
            leftText: "${leftShoot.shootPenaltyKick}",
            rightText: "${rightShoot.shootPenaltyKick}",
            title: "패널티킥 슛 수",
          ),
          //-------------------------------------------
          TwoTextCardRow(
            leftText: "${leftShoot.goalPenaltyKick}",
            rightText: "${rightShoot.goalPenaltyKick}",
            title: "패널티킥 골 수",
          ),
          //-------------------------------------------
        ],
      ),
    );
  }
}