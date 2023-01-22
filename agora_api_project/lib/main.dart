import 'package:agora_api_project/screen/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      fontFamily: 'NotoSans'
    ),
    home: HomeScreen(),
  ));
}
