import 'package:fifa_on4_bank/core/model/fifa_match/fifa_pass.dart';
import 'package:fifa_on4_bank/ui/widget/card/rounded_card.dart';
import 'package:fifa_on4_bank/ui/widget/card/two_text_card_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PassInfoCard extends StatelessWidget{

  final FifaPass leftPass;
  final FifaPass rightPass;

  PassInfoCard({
    @required this.leftPass,
    @required this.rightPass,
  });

  @override
  Widget build(BuildContext context) {
    return RoundedCard(
      childWidget: Column(
        children: [
          //-------------------------------------------
          TwoTextCardRow(
            leftText: "${leftPass.passTry}",
            rightText: "${rightPass.passTry}",
            title: "패스 시도 수",
          ),
          //-------------------------------------------
          TwoTextCardRow(
            leftText: "${leftPass.passSuccess}",
            rightText: "${rightPass.passSuccess}",
            title: "패스 성공 수",
          ),
          //-------------------------------------------
          TwoTextCardRow(
            leftText: "${leftPass.shortPassTry	}",
            rightText: "${rightPass.shortPassTry	}",
            title: "숏 패스 시도 수",
          ),
          //-------------------------------------------
          TwoTextCardRow(
            leftText: "${leftPass.shortPassSuccess}",
            rightText: "${rightPass.shortPassSuccess}",
            title: "숏 패스 성공 수",
          ),
          //-------------------------------------------
          TwoTextCardRow(
            leftText: "${leftPass.longPassTry}",
            rightText: "${rightPass.longPassTry}",
            title: "롱 패스 시도 수",
          ),
          //-------------------------------------------
          TwoTextCardRow(
            leftText: "${leftPass.longPassSuccess}",
            rightText: "${rightPass.longPassSuccess}",
            title: "롱 패스 성공 수",
          ),
          //-------------------------------------------
          TwoTextCardRow(
            leftText: "${leftPass.bouncingLobPassTry}",
            rightText: "${rightPass.bouncingLobPassTry}",
            title: "바운싱 롭\n패스 시도 수",
          ),
          //-------------------------------------------
          TwoTextCardRow(
            leftText: "${leftPass.bouncingLobPassSuccess}",
            rightText: "${rightPass.bouncingLobPassSuccess}",
            title: "바운싱 롭\n패스 성공 수",
          ),
          //-------------------------------------------
          TwoTextCardRow(
            leftText: "${leftPass.drivenGroundPassTry}",
            rightText: "${rightPass.drivenGroundPassTry}",
            title: "드리븐 땅\n 패스 시도 수",
          ),
          //-------------------------------------------
          TwoTextCardRow(
            leftText: "${leftPass.drivenGroundPassSuccess}",
            rightText: "${rightPass.drivenGroundPassSuccess}",
            title: "드리븐 땅볼\n패스 성공 수",
          ),
          //-------------------------------------------
          TwoTextCardRow(
            leftText: "${leftPass.throughPassTry}",
            rightText: "${rightPass.throughPassTry}",
            title: "스루 패스\n시도 수",
          ),
          //-------------------------------------------
          TwoTextCardRow(
            leftText: "${leftPass.throughPassSuccess	}",
            rightText: "${rightPass.throughPassSuccess	}",
            title: "스루 패스\n성공 수",
          ),
          //-------------------------------------------
          TwoTextCardRow(
            leftText: "${leftPass.lobbedThroughPassTry}",
            rightText: "${rightPass.lobbedThroughPassTry}",
            title: "로빙 스루\n패스 시도 수",
          ),
          //-------------------------------------------
          TwoTextCardRow(
            leftText: "${leftPass.lobbedThroughPassSuccess}",
            rightText: "${rightPass.lobbedThroughPassSuccess}",
            title: "로빙 스루\n패스 성공 수",
          ),
          //-------------------------------------------
        ],
      ),
    );
  }
}