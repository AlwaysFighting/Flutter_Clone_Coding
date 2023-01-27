import 'package:dusty_dust_project/component/card_title.dart';
import 'package:dusty_dust_project/component/main_card.dart';
import 'package:flutter/material.dart';

import '../const/colors.dart';
import 'main_stat.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160.0,
      child: MainCard(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CardTitle(
                  title: '종류별 통계',
                ),
                Expanded(
                  child: ListView(
                      scrollDirection: Axis.horizontal,
                      physics: PageScrollPhysics(),
                      children: List.generate(
                          20,
                          (index) => MainStat(
                              width: constraints.maxWidth / 3,
                              caregory: '미세먼지',
                              imgPath: 'asset/img/best.png',
                              level: '최고',
                              stat: '0㎍/㎥'))),
                )
              ],
            );
          }
        ),
      ),
    );
  }
}
