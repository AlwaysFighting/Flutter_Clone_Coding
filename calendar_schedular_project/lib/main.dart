import 'package:calendar_schedular_project/database/drift_database.dart';
import 'package:calendar_schedular_project/screen/home_screen.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:calendar_schedular_project/database/drift_database.dart';

const DEFAULT_COLORS = [
  // 빨주노초바람보
  'F44336',
  'FF9800',
  'FFEB3B',
  'FCAF50',
  '2196F3',
  '3F51B5',
  '9C27B0'
];

void main() async {
  // 초기화가 모두 되었는지 확인하는 문장
  WidgetsFlutterBinding.ensureInitialized();

  // 날짜 관련 패키지 모두 사용가능
  await initializeDateFormatting();

  final database = LocalDatabase();

  GetIt.I.registerSingleton<LocalDatabase>(database);

  final colors = await database.getCategoryColors();

  if(colors.isEmpty) {
    for(String hexCode in DEFAULT_COLORS) {
      await database.createCategoryColor (
        CategoryColorsCompanion(
          hexCode: Value(hexCode),
        ),
      );
    }
  }

  runApp(MaterialApp(
    theme: ThemeData(
      fontFamily: 'NotoSans'
    ),
    debugShowCheckedModeBanner: false,
    home: HomeScreen()
  ));
}

