import 'package:calendar_schedular_project/component/custom_textfield.dart';
import 'package:calendar_schedular_project/const/colors.dart';
import 'package:calendar_schedular_project/database/drift_database.dart';
import 'package:calendar_schedular_project/model/category_color.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:calendar_schedular_project/database/drift_database.dart';

class ScheduleBottomSheet extends StatefulWidget {
  final DateTime selectedDate;
  final int? scheduleId;

  const ScheduleBottomSheet(
      {Key? key, required this.selectedDate, this.scheduleId})
      : super(key: key);

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey();

  int? startTime;
  int? endTime;
  String? content;
  int? selectedColorId;

  @override
  Widget build(BuildContext context) {
    // 키보드가 차지하는 부분 가져오기
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: FutureBuilder<Schedule>(
          future: widget.scheduleId == null
              ? null
              : GetIt.I<LocalDatabase>().getScheduleByID(widget.scheduleId!),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("스케줄을 불러올 수 없습니다.."),
              );
            }

            // FutureBuilder 처음 실행했고 로딩 중일 경우 => 데이터를 아직 안 가져온 순간
            if (snapshot.connectionState != ConnectionState.none &&
                !snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            // Future 실행이 되고 값이 있는데 단 한 번도 startTime 이 셋팅되지 않았을 때
            if(snapshot.hasData && startTime == null) {
              startTime = snapshot.data!.startTime;
              endTime = snapshot.data!.endTime;
              content = snapshot.data!.content;
              selectedColorId = snapshot.data!.colorId;
            }

            return SafeArea(
              child: Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height / 2 + bottomInset,
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: Padding(
                    padding:
                    const EdgeInsets.only(left: 8, right: 8, top: 16.0),
                    child: Form(
                      key: formKey,
                      autovalidateMode: AutovalidateMode.always,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _Time(
                            onStartSaved: (String? newValue) {
                              // 이미 앞에서 빈 데이터면 에러 던지도록 했기에 ! 사용하는 것
                              startTime = int.parse(newValue!);
                            },
                            onEndSaved: (String? newValue) {
                              endTime = int.parse(newValue!);
                            },
                            startinitialValue: startTime?.toString() ?? '',
                            endinitialValue: endTime?.toString() ?? '',
                          ),
                          SizedBox(height: 16.0),
                          _Content(
                            onSaved: (String? newValue) {
                              content = newValue;
                            },
                            initialValue: content ?? '',
                          ),
                          SizedBox(height: 16.0),
                          FutureBuilder<List<CategoryColor>>(
                              future:
                              GetIt.I<LocalDatabase>().getCategoryColors(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData &&
                                    selectedColorId == null &&
                                    snapshot.data!.isNotEmpty) {
                                  selectedColorId = snapshot.data![0].id;
                                }

                                return _ColorPicker(
                                  colors:
                                  snapshot.hasData ? snapshot.data! : [],
                                  selectedColorID: selectedColorId!,
                                  colorIdSetter: (int id) {
                                    setState(() {
                                      selectedColorId = id;
                                    });
                                  },
                                );
                              }),
                          SizedBox(height: 8.0),
                          _SaveButton(
                            onPressed: onSavePressed,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  // SaveButton 클릭시 호출 함
  void onSavePressed() async {
    // formKey 생성은 했지만, Form 위젯과 결합을 안 했을 경우 => 그냥 NULL 리턴
    if (formKey.currentState == null) {
      return;
    }
    // 모든 form 필드에서 validate 를 실행함.
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      if(widget.scheduleId == null) {
        await GetIt.I<LocalDatabase>().createSchedule(
          SchedulesCompanion(
            date: Value(widget.selectedDate),
            startTime: Value(startTime!),
            endTime: Value(endTime!),
            content: Value(content!),
            colorId: Value(selectedColorId!),
          ),
        );
      } else {
        await GetIt.I<LocalDatabase>().updateScheduleById(widget.scheduleId!,
          SchedulesCompanion(
            date: Value(widget.selectedDate),
            startTime: Value(startTime!),
            endTime: Value(endTime!),
            content: Value(content!),
            colorId: Value(selectedColorId!),
          )
        );
      }
      Navigator.of(context).pop();
    } else {
      print("ERROR");
    }
  }
}

class _Content extends StatelessWidget {
  final FormFieldSetter<String> onSaved;
  final String initialValue;

  const _Content({Key? key, required this.onSaved, required this.initialValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomTextField(
        label: '시작 내용',
        isTime: false,
        onSaved: onSaved,
        initialValue: initialValue,
      ),
    );
  }
}

class _Time extends StatelessWidget {
  final FormFieldSetter<String> onStartSaved;
  final FormFieldSetter<String> onEndSaved;
  final String startinitialValue;
  final String endinitialValue;

  const _Time({Key? key,
    required this.onStartSaved,
    required this.onEndSaved,
    required this.startinitialValue,
    required this.endinitialValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          child: CustomTextField(
            label: '시작 시간',
            isTime: true,
            onSaved: onStartSaved,
            initialValue: startinitialValue,
      )),
      SizedBox(
        width: 16.0,
      ),
      Expanded(
          child: CustomTextField(
            label: '마감 시간',
            isTime: true,
            onSaved: onEndSaved,
            initialValue: endinitialValue,
      )),
    ]);
  }
}

typedef ColorIdSetter = void Function(int id);

class _ColorPicker extends StatelessWidget {
  final List<CategoryColor> colors;
  final int selectedColorID;
  final ColorIdSetter colorIdSetter; // 함수를 외부에서 받겠다.

  const _ColorPicker(
      {Key? key,
      required this.colors,
      required this.selectedColorID,
      required this.colorIdSetter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      // 서로의 간격 띄우기
      spacing: 8.0,
      // 위, 아래로의 간격 띄우기
      runSpacing: 10.0,
      children: colors
          .map((e) => GestureDetector(
                onTap: () {
                  colorIdSetter(e.id);
                },
                child: renderColor(e, selectedColorID == e.id),
              ))
          .toList(),
    );
  }

  Widget renderColor(CategoryColor color, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(int.parse('FF${color.hexCode}', radix: 16)),
          border:
              isSelected ? Border.all(color: Colors.black, width: 4.0) : null),
      width: 32.0,
      height: 32.0,
    );
  }
}

class _SaveButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _SaveButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: PRIMARY_COLOR,
              ),
              onPressed: onPressed,
              child: Text("SAVE")),
        ),
      ],
    );
  }
}
