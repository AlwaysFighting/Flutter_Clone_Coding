import 'package:flutter/material.dart';

import '../const/colors.dart';

class CardTitle extends StatelessWidget {
  final Color backgorundColor;
  final String title;

  const CardTitle({
    Key? key,
    required this.title,
    required this.backgorundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: backgorundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
            )),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        )
    );
  }
}
