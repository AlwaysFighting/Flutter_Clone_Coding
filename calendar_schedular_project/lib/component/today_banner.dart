import 'package:calendar_schedular_project/const/colors.dart';
import 'package:flutter/material.dart';

class TodayBanner extends StatelessWidget {
  final DateTime selectedDay;
  final int scheduleCount;

  const TodayBanner(
      {Key? key,
        required this.selectedDay,
        required this.scheduleCount}
      ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontWeight: FontWeight.w700,
      color: Colors.white
    );

    return Container(
      color: PRIMARY_COLOR,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                style: textStyle,
                '${selectedDay.year}년 ${selectedDay.month}월 ${selectedDay.day}일'
            ),
            Text(
              '$scheduleCount개',
              style: textStyle,
            )
          ],
        ),
      ),
    );
  }
}
