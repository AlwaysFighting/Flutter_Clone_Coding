import 'package:flutter/material.dart';
import 'package:random_number_generator/Constant/color.dart';
import 'package:random_number_generator/component/number_row.dart';

class SettingsScreen extends StatefulWidget {
  final int maxNumber;

  const SettingsScreen({Key? key, required this.maxNumber}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double maxNumber = 1000;

  // _SettingsScreenState 이 생성되는 순간 호출한다.
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    maxNumber = widget.maxNumber.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Body(maxNumber: maxNumber),
              _Footer( maxNumber: maxNumber, onSliderChanged: onSliderChannged,
              onButtonPressed: onButtonPressed,)
            ],
          ),
        ),
      ),
    );
  }
    void onButtonPressed(){
      Navigator.of(context).pop(maxNumber.toInt());
    }

    void onSliderChannged(double val) {
    setState((){
    maxNumber = val;
    });
  }
}

class _Body extends StatelessWidget {
  final double maxNumber;
  const _Body({Key? key, required this.maxNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: NumberRow(
        number: maxNumber.toInt(),
      )
    );
  }
}


class _Footer extends StatelessWidget {
  final VoidCallback onButtonPressed;
  final double maxNumber;
  final ValueChanged<double>? onSliderChanged;

  const _Footer({Key? key,
    required this.onSliderChanged,
    required this.onButtonPressed,
    required this.maxNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Slider(
          value: maxNumber,
          min: 1000,
          max: 1000000,
          onChanged: onSliderChanged,
        ),
        ElevatedButton(
            onPressed: onButtonPressed,
            style: ElevatedButton.styleFrom(
              primary: RED_COLOR,
            ),
            child: Text("SAVE")
        ),
      ],
    );
  }
}


