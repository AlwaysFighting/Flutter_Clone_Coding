import 'package:flutter/material.dart';
import 'package:scrollable_widgets/Layout/main_layout.dart';
import 'package:scrollable_widgets/const/colors.dart';

class GridViewScreen extends StatelessWidget {

  List<int> numbers = List.generate(100, (index) => index);

  GridViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainLayout(title: "GridViewScreen",
        body: renderGridViewSliverMax()
    );
  }

  // GridView.builder
  // SliverGridDelegateWithMaxCrossAxisExtent
  Widget renderGridViewSliverMax() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        // gridview 위젯의 최대 길이 정하기
        maxCrossAxisExtent: 50
      ),
      itemBuilder: (context, index) {
        return renderContainer(
            color: rainbowColors[index % rainbowColors.length],
            index: index
        );
      },
      itemCount: 100,
    );
  }

  // GridView.builder
  // SliverGridDelegateWithFixedCrossAxisCount
  Widget renderGridViewBuilder() {
    return GridView.builder(
      gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemBuilder: (context, index) {
        return renderContainer(
            color: rainbowColors[index % rainbowColors.length],
            index: index
        );
      },
    );
  }

  // 한 번에 다 그리기
  Widget renderGridViewCount() {
    return GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        children: numbers.map((e) =>
            renderContainer(
                color: rainbowColors[e % rainbowColors.length], index: e))
            .toList()
    );
  }


  Widget renderContainer({
    required Color color,
    required int? index,
    double? height,
  }) {
    print(index);
    return Container(
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
        )
    );
  }
}