import 'package:fifa_on4_bank/core/util/date_util.dart';
import 'package:fifa_on4_bank/ui/screen/match_detail/match_detail_provider.dart';
import 'package:fifa_on4_bank/ui/screen/match_detail/widget/defence_info_card.dart';
import 'package:fifa_on4_bank/ui/screen/match_detail/widget/match_info_card.dart';
import 'package:fifa_on4_bank/ui/screen/match_detail/widget/pass_info_card.dart';
import 'package:fifa_on4_bank/ui/screen/match_detail/widget/shoot_info_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MatchDetailPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer<MatchDetailProvider>(
      builder: (context, model, child) {
        if ( model.busy) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            //--------------------------------------------
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                color: Theme.of(context).accentColor
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "(${model.matchDetail.matchInfo[0].matchDetail.matchResult})  ",
                          style: TextStyle(fontSize: 14, color: Colors.black)
                        ),
                        TextSpan(
                          text: model.matchDetail.matchInfo[0].nickname,
                          style: TextStyle(fontSize: 16, color: Colors.black)
                        ),
                        TextSpan(
                          text: "   VS   ",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black)
                        ),
                        TextSpan(
                          text: "(${model.matchDetail.matchInfo[1].matchDetail.matchResult})  ",
                          style: TextStyle(fontSize: 14, color: Colors.black)
                        ),
                        TextSpan(
                          text: model.matchDetail.matchInfo[1].nickname,
                          style: TextStyle(fontSize: 16, color: Colors.black)
                        ),
                      ]
                    )
                  ),
                  //------------------------------------------
                  SizedBox(height: 8,),
                  //------------------------------------------
                  Text(
                    DateUtils.getDateStringFromString("${model.matchDetail.matchDate}", format: "yyyy년 MM월 dd일 HH시 mm분"), 
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.6)
                    ),
                  )
                ],
              )
            ),
            //--------------------------------------------
            _buildTitle("매치정보"),
            MatchInfoCard(
              leftMatchDetail: model.matchDetail.matchInfo[0].matchDetail,
              rightMatchDetail: model.matchDetail.matchInfo[1].matchDetail,
            ),
            _buildTitle("슛"),
            ShootInfoCard(
              leftShoot: model.matchDetail.matchInfo[0].shoot,
              rightShoot: model.matchDetail.matchInfo[1].shoot,
            ),
            _buildTitle("패스"),
            PassInfoCard(
              leftPass: model.matchDetail.matchInfo[0].pass,
              rightPass: model.matchDetail.matchInfo[1].pass,
            ),
            _buildTitle("디펜스"),
            DefenceInfoCard(
              leftDefence: model.matchDetail.matchInfo[0].defence,
              rightDefence: model.matchDetail.matchInfo[1].defence,
            ),
            // _buildTitle("선수"),
            // _buildTitle("스테이터스"),
          ],
        );
      },
    );
  }


  Widget _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 28,
        bottom: 12,
        left: 12,
        right: 12,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold
        )
        ,
      ),
    );
  }
}