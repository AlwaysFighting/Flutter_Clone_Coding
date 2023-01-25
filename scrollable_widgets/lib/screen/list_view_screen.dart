import 'package:flutter/material.dart';
import 'package:scrollable_widgets/Layout/main_layout.dart';
import 'package:scrollable_widgets/const/colors.dart';

class ListViewScreen extends StatelessWidget {
  final List<int> numbers = List.generate(100, (index) => index);

  ListViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: "ListViewScreen",
      body: renderSeparateBuilder()
    );
  }

  Widget renderSeparateBuilder() {
    return ListView.separated(
      itemCount: 100,
      itemBuilder: (context, index) {
        return renderContainer(
            color: rainbowColors[index % rainbowColors.length], index: index);
      },
      separatorBuilder: (BuildContext context, int index) {
        index +=1 ;
        if(index % 5 == 0) {
          return renderContainer(
              color: Colors.black,
              index: index,
              height: 50
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget renderBuilder() {
    return ListView.builder(
      itemCount: 100,
      itemBuilder: (context, index) {
        return renderContainer(
            color: rainbowColors[index % rainbowColors.length], index: index);
      },
    );
  }

  Widget renderDefault() {
    return ListView(
      children: numbers
          .map((e) =>
          renderContainer(
            color: rainbowColors[e % rainbowColors.length],
            index: e,
          ))
          .toList(),
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
