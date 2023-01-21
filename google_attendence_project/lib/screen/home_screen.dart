import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool choolCheckDone = false;

  // latitude - 위도 , longtitude - 경도
  static final LatLng companyLatLng = LatLng(37.5233273, 126.921252);

  // 확대(Zoom Level)
  static final CameraPosition initialPosition =
      CameraPosition(target: companyLatLng, zoom: 15);

  static final double okDistance = 100;

  static final Circle withinDistanceCircle = Circle(
    // 동그라미를 구별하는 기능
    circleId: CircleId('withinDistanceCircle'),
    center: companyLatLng,
    fillColor: Colors.blue.withOpacity(0.5),
    radius: okDistance,
    strokeColor: Colors.blue,
    strokeWidth: 1,
  );

  static final Circle notWithinDistanceCircle = Circle(
    // 동그라미를 구별하는 기능
    circleId: CircleId('notWithinDistanceCircle'),
    center: companyLatLng,
    fillColor: Colors.red.withOpacity(0.5),
    radius: okDistance,
    strokeColor: Colors.red,
    strokeWidth: 1,
  );

  static final Circle checkDoneCircle = Circle(
    // 동그라미를 구별하는 기능
    circleId: CircleId('checkDoneCircle'),
    center: companyLatLng,
    fillColor: Colors.green.withOpacity(0.5),
    radius: okDistance,
    strokeColor: Colors.green,
    strokeWidth: 1,
  );

  static final Marker marker = Marker(
    markerId: MarkerId('marker'),
    position: companyLatLng,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: randerAppbar(),
        body: FutureBuilder<String>(
          future: checkPermission(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            // 로딩 상태일 때 로딩 이미지를 띄우겠다.
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data == '위치 권한을 허가 되었습니다.') {
              return StreamBuilder<Position>(
                  stream: Geolocator.getPositionStream(),
                  builder: (context, snapshot) {
                    bool isWithInRange = false;

                    if (snapshot.hasData) {
                      final start = snapshot.data!;
                      final end = companyLatLng;

                      final distance = Geolocator.distanceBetween(
                          start.latitude,
                          start.longitude,
                          end.latitude,
                          end.longitude);

                      if (distance < okDistance) {
                        isWithInRange = true;
                      }
                    }

                    return Column(
                      children: [
                        _CustomGoogleMap(
                          initialPosition: initialPosition,
                          circle: choolCheckDone
                              ? checkDoneCircle
                              : isWithInRange
                                  ? withinDistanceCircle
                                  : notWithinDistanceCircle,
                          marker: marker,
                        ),
                        _ChoolCheckButton(
                          isWithInRange: isWithInRange,
                          onPressed: onChoolCheckPressed,
                          choolcheckDone: choolCheckDone,
                        ),
                      ],
                    );
                  });
            }

            return Center(
              child: Text(snapshot.data),
            );
          },
        ));
  }

  // 출근 버튼을 눌렸을 경우
  onChoolCheckPressed() async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("출근하기"),
          content: Text("출근하시겠습니까?"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text("취소")),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text("출근하기")),
          ],
        );
      },
    );

    if (result) {
      setState(() {
        choolCheckDone = true;
      });
    }
  }

  // 앱 위치 권한 요청 - 반드시 async
  Future<String> checkPermission() async {
    final isLocationEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationEnabled) {
      return '위치 서비스를 활성화 해주세요.';
    }

    // 현재 지금 앱이 갖고 있는 위치 서비스가 어떻게 되는지 확인한다.
    LocationPermission checkedPermissition = await Geolocator.checkPermission();

    if (checkedPermissition == LocationPermission.denied) {
      checkedPermissition = await Geolocator.requestPermission();

      if (checkedPermissition == LocationPermission.denied) {
        return "위치 권한을 허가 해주세요.";
      }
    }

    if (checkedPermissition == LocationPermission.deniedForever) {
      return "앱의 위치 권한을 설정-위치 허용으로 해주세요.";
    }

    // 드디어 허가!
    return '위치 권한을 허가 되었습니다.';
  }

  AppBar randerAppbar() {
    return AppBar(
      title: Text(
        "Google Map Project",
        style: TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.w700,
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}

class _CustomGoogleMap extends StatelessWidget {
  final CameraPosition initialPosition;
  final Marker marker;
  final Circle circle;

  const _CustomGoogleMap(
      {Key? key,
      required this.initialPosition,
      required this.circle,
      required this.marker})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: GoogleMap(
        mapType: MapType.normal,
        // 처음에 어떤 위치에서 바라볼지
        initialCameraPosition: initialPosition,
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        circles: Set.from([circle]),
        markers: Set.from([marker]),
      ),
    );
  }
}

class _ChoolCheckButton extends StatelessWidget {
  final bool isWithInRange;
  final VoidCallback onPressed;
  final bool choolcheckDone;

  const _ChoolCheckButton(
      {Key? key,
      required this.isWithInRange,
      required this.onPressed,
      required this.choolcheckDone})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.timelapse_outlined,
            size: 50,
            color: choolcheckDone
                ? Colors.green
                : isWithInRange
                    ? Colors.blue
                    : Colors.red,
          ),
          const SizedBox(
            height: 20.0,
          ),
          if (!choolcheckDone && isWithInRange)
            TextButton(onPressed: onPressed, child: Text("출근하기"))
        ],
      ),
    );
  }
}
