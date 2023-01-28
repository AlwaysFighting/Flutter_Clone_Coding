import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:dusty_dust_project/Model/statAndStatus_model.dart';
import 'package:dusty_dust_project/Model/stat_model.dart';
import 'package:dusty_dust_project/container/category_card.dart';
import 'package:dusty_dust_project/component/main_app_bar.dart';
import 'package:dusty_dust_project/component/main_drawer.dart';
import 'package:dusty_dust_project/repository/stat_repository.dart';
import 'package:dusty_dust_project/utils/data_utils.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../container/hourly_card.dart';
import '../const/regions.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String region = regions[0];
  bool isExpanded = true;
  ScrollController scrollController = ScrollController();

  @override
  initState() {
    super.initState();
    scrollController.addListener(scrollListener);
    fetchData();
  }

  @override
  dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    try {
      final now = DateTime.now();
      // 실제 데이터를 가져와야할 시간
      final fetchTime = DateTime(now.year, now.month, now.day, now.hour);

      final box = Hive.box<StatModel>(ItemCode.PM10.name);

      // box.values 가 NULL 인 경우를 살펴봐야 한다.
      if (box.values.isNotEmpty &&
          (box.values.last as StatModel).dataTime.isAtSameMomentAs(fetchTime)) {
        return;
      }

      List<Future> futures = [];

      for (ItemCode itemCode in ItemCode.values) {
        futures.add(StatRepository.fetchData(
          itemCode: itemCode,
        ));
      }

      final results = await Future.wait(futures);

      // Hive 에 데이터 넣기
      for (int i = 0; i < results.length; i++) {
        // ItemCode
        final key = ItemCode.values[i];
        // List<StatModel>
        final value = results[i];

        // box 열기
        final box = Hive.box<StatModel>(key.name);

        for (StatModel stat in value) {
          box.put(stat.dataTime.toString(), stat);
        }

        final allKeys = box.keys.toList();

        if (allKeys.length > 24) {
          // start - 시작 인덱스 <-> end
          final deleteKeys = allKeys.sublist(0, allKeys.length - 24);

          box.deleteAll(deleteKeys);
        }
      }
    } on DioError catch (e) {
      // DioError => 지금 실행 요청이 제대로 안 됐을 때 (인터넷 요청)
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("인터넷 연결이 원할하지 않습니다.")));
    }
  }

  scrollListener() {
    bool isExpanded = scrollController.offset < 500 - kToolbarHeight;

    if (isExpanded != this.isExpanded) {
      setState(() {
        this.isExpanded = isExpanded;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box>(
      valueListenable: Hive.box<StatModel>(ItemCode.PM10.name).listenable(),
      builder: (context, box, widget) {
        if(box.values.isEmpty) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // 현재 박스는 PM10 - 미세먼지가 전달받고 있다.
        // box.value.toList().last

        final recentStat = box.values.toList().last as StatModel;

        // 미세먼지 최근 데이터의 현재 상태
        final status = DataUtils.getStatusFromItemCodeAndValue(
          value: recentStat.getLevelFromRegion(region),
          itemCode: ItemCode.PM10,
        );

        return Scaffold(
          drawer: MainDrawer(
            onRegionTap: (String region) {
              setState(() {
                this.region = region;
              });
              Navigator.of(context).pop();
            },
            selectedRegion: region,
            darkColor: status.darkColor,
            lightColor: status.lightColor,
          ),
          body: Container(
            color: status.primaryColor,
            child: RefreshIndicator(
              onRefresh: () async {
                await fetchData();
              },
              child: CustomScrollView(
                controller: scrollController,
                slivers: [
                  MainAppBar(
                    isExpanded: isExpanded,
                    stat: recentStat,
                    status: status,
                    region: region,
                    dateTime: recentStat.dataTime,
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CategoryCard(
                          region: region,
                          darkColor: status.darkColor,
                          lightColor: status.lightColor,
                        ),
                        const SizedBox(height: 16.0),
                        ...ItemCode.values.map((itemCode) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: HourlyCard(
                              darkColor: status.darkColor,
                              lightColor: status.lightColor,
                              region: region,
                              itemCode: itemCode,
                            ),
                          );
                        }).toList(),
                        const SizedBox(height: 16.0),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
