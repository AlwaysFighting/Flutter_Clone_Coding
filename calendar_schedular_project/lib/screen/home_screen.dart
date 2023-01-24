import 'package:calendar_schedular_project/component/calendar.dart';
import 'package:calendar_schedular_project/component/schedule_card.dart';
import 'package:calendar_schedular_project/component/today_banner.dart';
import 'package:calendar_schedular_project/const/colors.dart';
import 'package:flutter/material.dart';

import '../component/schedule_bottom_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: renderFloatingActionButton(),
      body: SafeArea(
        child: Column(
          children: [
            Calendar(
              selectedDay: selectedDay,
              focusedDay: focusedDay,
              onDaySelected: onDaySelected,
            ),
            SizedBox(height: 8.0),
            TodayBanner(selectedDay: selectedDay, scheduleCount: 3),
            SizedBox(height: 8.0),
            _SchedultList(),
          ],
        ),
      ),
    );
  }

  FloatingActionButton renderFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(context: context,
            isScrollControlled: true,
            builder: (_) {
          return ScheduleBottomSheet(selectedDate: selectedDay,);
        });
      },
      backgroundColor: PRIMARY_COLOR,
      child: Icon(Icons.add),
    );
  }

  onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      this.selectedDay = selectedDay;
      this.focusedDay = selectedDay;
    });
  }
}

class _SchedultList extends StatelessWidget {
  const _SchedultList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView.separated(
          itemCount: 8,
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(height: 8.0);
          },
          itemBuilder: (context, index) {
            return ScheduleCard(
                startTime: 8,
                endTime: 9,
                content: '프로그래밍 공부하기 $index',
                color: Colors.red);
          },
        ),
      ),
    );
  }
}
