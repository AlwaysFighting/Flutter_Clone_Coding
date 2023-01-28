import 'package:dusty_dust_project/Model/stat_model.dart';
import 'package:dusty_dust_project/screen/home_screen.dart';
import 'package:dusty_dust_project/screen/text_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

const testBox ='text';

void main() async {

  await Hive.initFlutter();

  Hive.registerAdapter<StatModel>(StatModelAdapter());
  Hive.registerAdapter<ItemCode>(ItemCodeAdapter());

  await Hive.openBox(testBox);

  for(ItemCode itemCode in ItemCode.values) {
    await Hive.openBox<StatModel>(itemCode.name);
  }

  runApp(MaterialApp(
    theme: ThemeData(
      fontFamily: 'sunflower',
    ),
    debugShowCheckedModeBanner: false,
    home: HomeScreen(),
  ));
}

