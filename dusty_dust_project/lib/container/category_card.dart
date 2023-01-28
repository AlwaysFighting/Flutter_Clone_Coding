import 'package:dusty_dust_project/Model/stat_model.dart';
import 'package:dusty_dust_project/component/card_title.dart';
import 'package:dusty_dust_project/component/main_card.dart';
import 'package:dusty_dust_project/utils/data_utils.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../Model/statAndStatus_model.dart';
import '../component/main_stat.dart';

class CategoryCard extends StatelessWidget {
  final String region;
  final Color darkColor;
  final Color lightColor;

  const CategoryCard(
      {Key? key,
      required this.region,
      required this.darkColor,
      required this.lightColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160.0,
      child: MainCard(
        backgroundColor: lightColor,
        child: LayoutBuilder(builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CardTitle(
                title: '종류별 통계',
                backgorundColor: darkColor,
              ),
              Expanded(
                child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: PageScrollPhysics(),
                    children: ItemCode.values
                        .map((ItemCode itemCode) => ValueListenableBuilder<Box>(
                              valueListenable:
                                  Hive.box<StatModel>(itemCode.name)
                                      .listenable(),
                              builder: (context, box, widget) {
                                final stat = (box.values.last as StatModel);
                                final status =
                                    DataUtils.getStatusFromItemCodeAndValue(
                                        value: stat.getLevelFromRegion(region),
                                        itemCode: itemCode);

                                return MainStat(
                                    width: constraints.maxWidth / 3,
                                    caregory: DataUtils.getItemCodeKrString(
                                      itemCode: itemCode,
                                    ),
                                    imgPath: status.imagePath,
                                    level: status.label,
                                    stat: '${stat.getLevelFromRegion(
                                      region,
                                    )}${DataUtils.getUnitFromDataType(
                                      itemCode: itemCode,
                                    )}');
                              },
                            ))
                        .toList()),
              )
            ],
          );
        }),
      ),
    );
  }
}
