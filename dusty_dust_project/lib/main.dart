import 'package:dusty_dust_project/screen/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      fontFamily: 'sunflower',
    ),
    debugShowCheckedModeBanner: false,
    home: HomeScreen(),
  ));
}

