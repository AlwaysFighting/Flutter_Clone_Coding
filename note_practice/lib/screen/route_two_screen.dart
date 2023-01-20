import 'package:flutter/material.dart';
import 'package:note_practice/Layout/main_layout.dart';
import 'package:note_practice/main.dart';
import 'package:note_practice/screen/route_three_screen.dart';

class RouteTwoScreen extends StatelessWidget {

  const RouteTwoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments;

    return MainLayout(title: "RouteTwoScreen", children: [
      Text('arguments : ${arguments}', textAlign: TextAlign.center,),
      ElevatedButton(onPressed: (){
        Navigator.of(context).pop(100);
       }, child: Text("POP")),
      ElevatedButton(onPressed: (){
        Navigator.of(context).pushNamed(THREE_ROUTE, arguments: 999);
      },
          child: Text("Push Named")),
      ElevatedButton(onPressed: (){
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => RouteThreeScreen()),
        );
      }, child: Text("pushReplacement")),
      ElevatedButton(onPressed: (){
        Navigator.of(context).pushReplacementNamed(
            THREE_ROUTE,
        );
      }, child: Text("pushReplacementNamed")),
      ElevatedButton(onPressed: (){
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => RouteThreeScreen()),
          // 특정 라우터를 삭제한다.
          // route.settings.name 은
              (route) => route.settings.name == HOME_ROUTE,);
      }, child: Text("Push And RemoveUntil")),
      ElevatedButton(onPressed: (){
        Navigator.of(context).pushNamedAndRemoveUntil(
              THREE_ROUTE,
              (route) => route.settings.name == HOME_ROUTE,);
      }, child: Text("Push And NamedRemoveUntil")),
    ]);
  }
}