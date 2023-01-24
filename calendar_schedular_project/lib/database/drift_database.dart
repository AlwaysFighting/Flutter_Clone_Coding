import 'dart:io';

import 'package:drift/drift.dart';
import '../model/category_color.dart';
import '../model/schedule.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:drift/native.dart';

// import 보다 넓은 기능
// private 값까지 불러올 수 있다.
part 'drift_database.g.dart';

@DriftDatabase(
  // 생성한 데이터베이스를 import 하기
  tables: [
    Schedules,
    CategoryColors,
  ],
)

class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  // Query 받아오기
  Future<int> createSchedule(SchedulesCompanion data) =>
      into(schedules).insert(data);

  Future<int> createCategoryColor(CategoryColorsCompanion data) =>
      into(categoryColors).insert(data);

  // CategoryColor 를 리스트로 데이터 불러오기
 Future<List<CategoryColor>> getCategoryColors() =>
      select(categoryColors).get();

  @override
  // 데이터베이스 버전 (1부터 시작하면 됨)
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    //이 App 전용으로 사용할 수 있는 Folder 위치 리턴
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}