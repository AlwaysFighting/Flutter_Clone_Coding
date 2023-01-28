import 'package:dusty_dust_project/main.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TextScreen"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ValueListenableBuilder<Box>(
              // 불러오고 싶은 box
              // box 값들이 변경될 때 마다 업데이트해라
              valueListenable: Hive.box(testBox).listenable(),
              builder: (context, box, widget) {

                return Column(
                  children:
                    box.values.map((e) =>
                      Text(e.toString()),
                    ).toList(),
                );
              }),
          ElevatedButton(
              onPressed: () {
                final box = Hive.box(testBox);
                print('keys : ${box.keys.toList()}');
                print('values : ${box.values.toList()}');
              },
              child: Text("박스 프린트하기")),
          ElevatedButton(
              onPressed: () {
                final box = Hive.box(testBox);
                // box.add('Test1');

                // 데이터를 생성하거나 업데이트할 때
                //box.put(100, 'Test4');

                box.put(1000, "새로운 데이터!!");
              },
              child: Text("데이터 넣기")),
          ElevatedButton(
              onPressed: () {
                final box = Hive.box(testBox);
                print(box.get(100)); // 어떤 value을 가지고 올 것인지
                print(box.getAt(3)); // 어떤 index 가지고 올 것인지
              },
              child: Text("특정값 가져오기")),
          ElevatedButton(
              onPressed: () {
                final box = Hive.box(testBox);
                //box.delete(2); // 어떤 value을 가지고 올 것인지
                box.deleteAt(3); // 어떤 index 가지고 올 것인지
              },
              child: Text("특정값 삭제하기"))
        ],
      ),
    );
  }
}
