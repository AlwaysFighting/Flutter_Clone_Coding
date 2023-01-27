import 'package:dusty_dust_project/const/colors.dart';
import 'package:flutter/material.dart';

const regions = [
  '서울','경기','대구','인천','대구','대전','세종''강원','경북','경남','부산','울산',
  '제주','전남','전북','광주'
];

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: DARK_COLOR,
      child: ListView(
        children: [
          // Drawer 의 헤더
          DrawerHeader(
            child: Text(
              "지역 선택",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0
              )
            ),
          ),
          ...regions.map((e) => ListTile(
              tileColor: Colors.white,
              // 선택이 된 상태에서의 타일 색상
              selectedTileColor: LIGHT_COLOR,
              // 선택이 된 상태에서의 글자 색상
              selectedColor: Colors.black,
              // 선택된 상태 조절 (선택된 색상 변경 유무)
              selected: e == '서울',
              onTap: (){

              },
              title: Text(
                e
              )
          )
          ).toList(),
        ],
      ),
    );
  }
}
