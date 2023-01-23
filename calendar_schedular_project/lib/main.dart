import 'package:calendar_schedular_project/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  // 초기화가 모두 되었는지 확인하는 문장
  WidgetsFlutterBinding.ensureInitialized();

  // 날짜 관련 패키지 모두 사용가능
  await initializeDateFormatting();

  runApp(MaterialApp(
    theme: ThemeData(
      fontFamily: 'NotoSans'
    ),
    debugShowCheckedModeBanner: false,
    home: HomeScreen()
  ));
}

