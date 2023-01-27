import 'package:dusty_dust_project/Model/step_model.dart';
import 'package:dusty_dust_project/component/category_card.dart';
import 'package:dusty_dust_project/component/main_app_bar.dart';
import 'package:dusty_dust_project/component/main_drawer.dart';
import 'package:dusty_dust_project/const/colors.dart';
import 'package:dusty_dust_project/repository/stat_repository.dart';
import 'package:dusty_dust_project/utils/data_utils.dart';
import 'package:flutter/material.dart';
import '../component/hourly_card.dart';
import '../const/regions.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String region = regions[0];

  Future<List<StatModel>> fetchData() async {
    final statModels = await StatRepository.fetchData();
    return statModels;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      drawer: MainDrawer(
        onRegionTap: (String region) {
          setState(() {
            this.region = region;
          });
          Navigator.of(context).pop();
        },
        selectedRegion: region,
      ),
      body: FutureBuilder<List<StatModel>>(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("에러가 있습니다."),
              );
            }

            if (!snapshot.hasData) {
              // 로딩 상태
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            // 리스트가 무조건 있음
            List<StatModel> stats = snapshot.data!;
            StatModel recentStat = stats[0];

            final status = DataUtils.getStatusFromItemCodeAndValue(
                value: recentStat.seoul, itemCode: ItemCode.PM10);

            return CustomScrollView(
              slivers: [
                MainAppBar(
                  stat: recentStat,
                  status: status,
                  region: region,
                ),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CategoryCard(),
                      const SizedBox(height: 16.0),
                      HourlyCard(),
                    ],
                  ),
                )
              ],
            );
          }
      ),
    );
  }
}
