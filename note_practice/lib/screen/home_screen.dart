import 'package:flutter/material.dart';
import 'package:note_practice/Layout/main_layout.dart';
import 'package:note_practice/screen/route_one_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // onWillPop 은 async 를 붙여야 한다 ❗️
      onWillPop: () async {
        // true - pop 가능
        // false - pop 불가능
        final canPop = Navigator.of(context).canPop();
        return canPop;
     },
      child: MainLayout(title: "HomeScreen", children: [
        ElevatedButton(onPressed: (){
          Navigator.of(context).canPop();
        }, child: Text("can pop")),
        ElevatedButton(
            onPressed: (){
              // 더이상 네비게이션을 pop 할 수 없을 때 뒤로가기 버튼을 제한하는 기능
              Navigator.of(context).maybePop();
            },
            child: Text("maybePop")),
        ElevatedButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
            child: Text("POP")),
        ElevatedButton(
            onPressed: () async {
             final result = await Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (BuildContext context) => RouteOneScreen(
                      number: 123,
                    )),
              );
             print(result);
            },
            child: Text("Push!"))
      ]),
    );
  }
}
