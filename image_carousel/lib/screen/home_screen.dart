import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? timer;

  PageController pageController = PageController(
    initialPage: 0
  );

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(Duration(seconds: 2), (timer) {
      int currentPage = pageController.page!.toInt();
      int nextPage = currentPage + 1;

      if(nextPage > 4) {
        nextPage = 0;
      }
      // 애니메이션하면서 Page 바꾸기
      pageController.animateToPage(nextPage, duration: Duration(milliseconds: 400), curve: Curves.linear);
    });
  }

  // 생명주기의 마지막 dispose()
  @override
  void dispose() {
    pageController.dispose(); // pageController 메모리 데이터를 삭제하기 ⭐️
    if(timer != null) {
      timer!.cancel();
    }
    super.dispose();
  }

  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return Scaffold(
      body: PageView(
        controller: pageController,
        scrollDirection: Axis.horizontal,
        children: [1, 2, 3, 4, 5].map(
          (e) => Image.asset('assets/img/image_$e.jpeg', fit: BoxFit.cover)
        ).toList(),
      ),
    );
  }
}

