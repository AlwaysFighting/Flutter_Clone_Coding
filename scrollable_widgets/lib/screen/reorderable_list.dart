import 'package:flutter/material.dart';
import 'package:scrollable_widgets/Layout/main_layout.dart';
import 'package:scrollable_widgets/const/colors.dart';

class ReorderableListViewScreen extends StatefulWidget {
  const ReorderableListViewScreen({Key? key}) : super(key: key);

  @override
  State<ReorderableListViewScreen> createState() =>
      _ReorderableListViewScreenState();
}

class _ReorderableListViewScreenState extends State<ReorderableListViewScreen> {
  List<int> numbers = List.generate(100, (index) => index);

  @override
  Widget build(BuildContext context) {
    return MainLayout(
        title: "ReorderableListViewScreen",
        body: ReorderableListViewBuilder()
    );
  }

  Widget ReorderableListViewBuilder() {
    return ReorderableListView.builder(
        itemBuilder: (context, index) {
          return renderContainer(
            color: rainbowColors[numbers[index] % rainbowColors.length],
            index: numbers[index],
          );
        },
        itemCount: numbers.length,
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if(oldIndex < newIndex) {
              newIndex -= 1;
            }
            final item = numbers.removeAt(oldIndex);
            numbers.insert(newIndex, item);
          });
        },
    );
  }

  // 화면에서 순서를 바꿔줌 (실제 데이터는 바꾸지 않음)
  // 순서를 바꾸면 실행됨
  Widget ReorderableListViewDefault() {
    return ReorderableListView(
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if(oldIndex < newIndex) {
              newIndex -= 1;
            }
            final item = numbers.removeAt(oldIndex);
            numbers.insert(newIndex, item);
          });
        },
        children:
        numbers.map((e) =>
            renderContainer(
              color: rainbowColors[e % rainbowColors.length],
              index: e,
            )
        ).toList()
    );
  }

  Widget renderContainer({
    required Color color,
    required int? index,
    double? height,
  }) {
    print(index);
    return Container(
        key: Key(index.toString()),
        height: height ?? 300,
        color: color,
        child: Center(
          child: Text(
            index.toString(),
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 30.0),
          ),
        ));
  }
}
