import 'package:fifa_on4_bank/core/model/fifa_match/fifa_defence.dart';
import 'package:fifa_on4_bank/ui/widget/card/rounded_card.dart';
import 'package:fifa_on4_bank/ui/widget/card/two_text_card_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DefenceInfoCard extends StatelessWidget{

  final FifaDefence leftDefence;
  final FifaDefence rightDefence;

  DefenceInfoCard({
    @required this.leftDefence,
    @required this.rightDefence,
  });

  @override
  Widget build(BuildContext context) {
    return RoundedCard(
      childWidget: Column(
        children: [
          //-------------------------------------------
          TwoTextCardRow(
            leftText: "${leftDefence.blockTry}",
            rightText: "${rightDefence.blockTry}",
            title: "블락 시도 수",
          ),
          //-------------------------------------------
          TwoTextCardRow(
            leftText: "${leftDefence.blockSuccess	}",
            rightText: "${rightDefence.blockSuccess	}",
            title: "블락 성공 수",
          ),
          //-------------------------------------------
          TwoTextCardRow(
            leftText: "${leftDefence.tackleTry	}",
            rightText: "${rightDefence.tackleTry	}",
            title: "	태클 시도 수",
          ),
          //-------------------------------------------
          TwoTextCardRow(
            leftText: "${leftDefence.tackleSuccess}",
            rightText: "${rightDefence.tackleSuccess}",
            title: "태클 성공 수",
          ),
          //-------------------------------------------
        ],
      ),
    );
  }
}