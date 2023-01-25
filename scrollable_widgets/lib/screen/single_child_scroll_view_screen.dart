import 'package:flutter/material.dart';
import 'package:scrollable_widgets/Layout/main_layout.dart';
import 'package:scrollable_widgets/const/colors.dart';

class SingleChildScrollViewScreen extends StatelessWidget {
  final List<int> numbers = List.generate(
    100,
    (index) => index * 2,
  );

  SingleChildScrollViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: "SingleChildScrollViewScreen",
      body: renderPerformance()
    );
  }

  Widget renderPerformance() {
    return SingleChildScrollView(
      child: Column(
        children: numbers
            .map(
              (e) => renderContainer(
            color: rainbowColors[e % rainbowColors.length],
            index : e,
          ),
        )
            .toList(),
      ),
    );
  }

  // 기본 랜더링법
  Widget renderSimple() {
    return SingleChildScrollView(
      //physics: AlwaysScrollableScrollPhysics(),
      child: Column(
        children: rainbowColors.map((e) => renderContainer(color: e)).toList(),
      ),
    );
  }

  Widget renderContainer({
    required Color color,
    int? index,
  }) {
    if(index != null) {
      print(index);
    }
    return Container(
      height: 300,
      color: color,
    );
  }
}
