import 'package:flutter/material.dart';
import '../const/regions.dart';

typedef onRegiontap = void Function(String region);

class MainDrawer extends StatelessWidget {
  final onRegiontap onRegionTap;
  final String selectedRegion;
  final Color darkColor;
  final Color lightColor;

  const MainDrawer({
    Key? key,
    required this.onRegionTap,
    required this.selectedRegion,
    required this.darkColor,
    required this.lightColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: darkColor,
      child: ListView(
        children: [
          // Drawer 의 헤더
          DrawerHeader(
            child: Text("지역 선택",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                )),
          ),
          ...regions
              .map((e) => ListTile(
                  tileColor: lightColor,
                  // 선택이 된 상태에서의 타일 색상
                  selectedTileColor: darkColor,
                  // 선택이 된 상태에서의 글자 색상
                  selectedColor: Colors.black,
                  // 선택된 상태 조절 (선택된 색상 변경 유무)
                  selected: e == selectedRegion,
                  onTap: () {
                    onRegionTap(e);
                  },
                  title: Text(e)))
              .toList(),
        ],
      ),
    );
  }
}
