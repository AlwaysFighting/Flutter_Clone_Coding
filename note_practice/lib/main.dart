import 'package:flutter/material.dart';
import 'package:note_practice/screen/home_screen.dart';
import 'package:note_practice/screen/route_one_screen.dart';
import 'package:note_practice/screen/route_three_screen.dart';
import 'package:note_practice/screen/route_two_screen.dart';

const HOME_ROUTE = '/';
const ONE_ROUTE = '/two';
const TWO_ROUTE = '/one';
const THREE_ROUTE = '/three';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      //home: HomeScreen(),
      initialRoute: HOME_ROUTE,
      routes: {
        HOME_ROUTE : (context) => HomeScreen(),
        ONE_ROUTE : (context) => RouteOneScreen(),
        TWO_ROUTE : (context) => RouteTwoScreen(),
        THREE_ROUTE : (context) => RouteThreeScreen(),
      },
    )
  );
}

