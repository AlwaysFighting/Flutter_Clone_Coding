import 'package:flutter/material.dart';
import 'package:note_practice/Layout/main_layout.dart';

class RouteThreeScreen extends StatelessWidget {
  const RouteThreeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final argument = ModalRoute.of(context)!.settings.arguments;

    return MainLayout(title: "RouteThreeScreen", children: [
      Text("argument : ${argument}", textAlign: TextAlign.center),
      ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("POP")),
    ]);
  }
}
