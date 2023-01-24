import 'dart:io';

import 'package:calendar_schedular_project/model/schedule_with_color.dart';
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

  // 하나의 값만 받아온다.
  Future<Schedule> getScheduleByID(int id) =>
      (select(schedules)..where((tbl) => tbl.id.equals(id))).getSingle();

  // Query 받아오기
  Future<int> createSchedule(SchedulesCompanion data) =>
      into(schedules).insert(data);

  Future<int> createCategoryColor(CategoryColorsCompanion data) =>
      into(categoryColors).insert(data);

  // CategoryColor 를 리스트로 데이터 불러오기
  Future<List<CategoryColor>> getCategoryColors() =>
      select(categoryColors).get();

  // 모든 Row 들이 삭제
  //removeSchedule() => delete(schedules).go();

  Future<int> removeSchedule(int id) =>
      (delete(schedules)..where((tbl) => tbl.id.equals(id))).go();

  // 데이터를 변경해주겠다.
  Future<int> updateScheduleById(int id, SchedulesCompanion data) =>
      (update(schedules)..where((tbl) => tbl.id.equals(id))).write(data);

  // 업데이트된 값들을 계속해서 받을 수 있다.
  Stream<List<ScheduleWithColor>> watchSchedules(DateTime date) {
    final query = select(schedules).join([
      innerJoin(categoryColors, categoryColors.id.equalsExp(schedules.colorId))
    ]);

    query.where(schedules.date.equals(date));
    query.orderBy([
      // asc <-> desc
      OrderingTerm.asc(schedules.startTime),
    ]);

    // 필터링이 된 모든 값들
    return query.watch().map((rows) => rows
        .map((row) => ScheduleWithColor(
            schedule: row.readTable(schedules),
            categoryColor: row.readTable(categoryColors)))
        .toList());
    // final query = select(schedules);
    // query.where((tbl) => tbl.date.equals(date));
    // return query.watch();

    // 같은 코드 (위에랑)

    // return (select(schedules)..where((tbl) => tbl.date.equals(date))).watch();
  }

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