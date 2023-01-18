import 'dart:math';

import 'package:flutter/material.dart';
import 'package:random_number_generator/Constant/color.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<int> randomNumber =  [
    123,
    456,
    789,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(),
              _Body(
                randomNumber: randomNumber,
              ),
              _Footer(onPressed: onRandomNumberGenerate),
            ],
          ),
        ),
      )
    );
  }

  void onRandomNumberGenerate() {
      final rand = Random();
      final Set<int> newNumbers = {};

      // Set 에 3개의 숫자가 들어있을 때까지 반복하겠다는 의미.
      while(newNumbers.length != 3) {
        final number = rand.nextInt(1000);
        newNumbers.add(number);
      }
      // 새로 생성한 값을 기존 리스트 배열에 저장한다.
      setState(() {
        randomNumber = newNumbers.toList();
      });
  }
}

class _Header extends StatelessWidget {
  const _Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "랜덤 숫자 생성기",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        IconButton(onPressed: () {

        }, icon: Icon(
          Icons.settings,
          color: RED_COLOR,
        )
        )
      ],
    );
  }
}

class _Body extends StatelessWidget {
  final List<int> randomNumber;

  const _Body({required this.randomNumber, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:randomNumber.asMap().entries
              .map((x) => Padding(
            padding: EdgeInsets.only(bottom: x.key == 2 ? 0 : 16),
            child: Row(
              children:
              x.value.toString()
                  .split('')
                  .map((y) => Image.asset('asset/img/$y.png',
                height: 70,
                width: 50,)
              ).toList(),
            ),
          ),).toList(),
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  final VoidCallback onPressed;

  const _Footer({required this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: RED_COLOR,
        ),
        onPressed: onPressed
        , child: Text("생성하기"),
      ),
    );
  }
}
