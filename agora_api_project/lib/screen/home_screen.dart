import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: Column(
        children: [
          Expanded(child: _Logo(),
          ),
          Expanded(child: _Image()
          ),
          Expanded(child: _Button()
          ),
        ],
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.videocam,
          color: Colors.white,
          size: 40.0,
        ),
        SizedBox(width: 12.0,),
        Text(
          'Live',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30.0,
            //letterSpacing:
          ),
        )
      ],
    );
  }
}

class _Image extends StatelessWidget {
  const _Image({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class _Button extends StatelessWidget {
  const _Button({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

