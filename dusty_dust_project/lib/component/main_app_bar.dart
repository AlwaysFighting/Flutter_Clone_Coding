import 'package:dusty_dust_project/Model/status_model.dart';
import 'package:dusty_dust_project/Model/stat_model.dart';
import 'package:flutter/material.dart';
import '../const/colors.dart';
import '../utils/data_utils.dart';

class MainAppBar extends StatelessWidget {
  final String region;
  final StatusModel status;
  final StatModel stat;
  final DateTime dateTime;
  final bool isExpanded;

  const MainAppBar({
    Key? key,
    required this.status,
    required this.stat,
    required this.region,
    required this.dateTime,
    required this.isExpanded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ts = TextStyle(color: Colors.white, fontSize: 30.0);

    return SliverAppBar(
      backgroundColor: status.primaryColor,
      pinned: true,
      title: isExpanded
          ? null
          : Text(
              '$region ${DataUtils.getTimeFromDateTime(dateTime: dateTime)}'),
      centerTitle: true,
      expandedHeight: 500,
      flexibleSpace: FlexibleSpaceBar(
        background: SafeArea(
          child: Container(
            margin: EdgeInsets.only(top: kToolbarHeight),
            child: Column(
              children: [
                Text(
                  region,
                  style: ts.copyWith(
                    fontSize: 40.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  DataUtils.getTimeFromDateTime(dateTime: stat.dataTime),
                  style: ts.copyWith(
                    fontSize: 20.0,
                  ),
                ),
                SizedBox(height: 20.0,),
                Image.asset(
                  status.imagePath,
                  width: MediaQuery.of(context).size.width / 2,
                ),
                SizedBox(height: 20.0,),
                Text(
                  status.label,
                  style:
                      ts.copyWith(fontSize: 40.0, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 8.0,),
                Text(
                  "나쁘지 않네요!",
                  style:
                      ts.copyWith(fontSize: 20.0, fontWeight: FontWeight.w700),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }


}
