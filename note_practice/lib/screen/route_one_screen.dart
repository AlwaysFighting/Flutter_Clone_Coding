import 'package:flutter/material.dart';
import 'package:note_practice/Layout/main_layout.dart';
import 'package:note_practice/screen/route_two_screen.dart';

class RouteOneScreen extends StatelessWidget {
  final int? number;

  const RouteOneScreen({Key? key,
    this.number
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainLayout(title: "RouteOneScreen", children: [
      Text(
        number.toString(),
        textAlign: TextAlign.center,
      ),
      ElevatedButton(onPressed: (){
        Navigator.of(context).pop(456);
      }, child: Text("POP")),
      ElevatedButton(onPressed: (){
         Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => RouteTwoScreen(),
            settings: RouteSettings(
              arguments: 789,
            ),
         ),
         );}, child: Text("Push")),
    ]);
  }
}
