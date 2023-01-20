import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  final XFile video;
  final VoidCallback onNewVideoPressed; // 외부에서 관리하겠다.

  const CustomVideoPlayer(
      {Key? key, required this.video, required this.onNewVideoPressed})
      : super(key: key);

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  VideoPlayerController? videoController;
  Duration currentPosition = Duration();
  bool showControls = false;

  @override
  void initState() {
    super.initState();
    initializeContoller();
  }

  @override
  void didUpdateWidget(covariant CustomVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 현재 영상과 재생할 영상이 서로 다르다면 다시 initializeContoller 를 호출해라.
    // 즉, 갤러리에서 새로운 영상을 선택하면 재시작해라.
    if(oldWidget.video.path != widget.video.path) {
      initializeContoller();
    }
  }

  initializeContoller() async {
    // BUG 조심
    // 새로운 영상을 시작하면 async 와 안 맞아서 에러가 날 수 있다.
    // 처음 위치로 되돌려주는 작업이 필요하다.
    currentPosition = Duration();

    videoController = VideoPlayerController.file(
      File(widget.video.path),
    );

    await videoController!.initialize();

    // videoController 가 실행될 때마다 호출되는 함수 (영상의 위치가 바뀔 때마다)
    videoController!.addListener(() async {
      final currentPosition = videoController!.value.position;
      setState(() {
        this.currentPosition = currentPosition;
      });
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (videoController == null) {
      return CircularProgressIndicator();
    }

    return AspectRatio(
      aspectRatio: videoController!.value.aspectRatio,
      child: GestureDetector(
        onTap: () {
          setState(() {
            showControls = !showControls;
          });
        },
        child: Stack(
          children: [
            VideoPlayer(
              videoController!,
            ),
            if (showControls)
              _Controls(
                onReversePressed: onReversePressed,
                onPlayPressed: onPlayPressed,
                onForwordPressed: onForwordPressed,
                isPlaying: videoController!.value.isPlaying,
              ),
            if (showControls)
              _NewVideo(
                onPressed: widget.onNewVideoPressed,
              ),
            _SliderBottom(
              currentPosition: currentPosition,
              maxPosition: videoController!.value.duration,
              onSliderChanged: onSliderChanged,
            ),
          ],
        ),
      ),
    );
  }

  void onReversePressed() {
    // 현재 지금 동영상의 위치 파악하기
    final currentPosition = videoController!.value.duration;

    // 현재 기본 상태는 0초
    Duration position = Duration();

    // 설정된 값, 그 이상되었을 경우 빼주기 아니면 처음 위치로 돌아간다.
    if (currentPosition.inSeconds > 5) {
      Duration position = currentPosition - Duration(seconds: 5);
    }

    videoController!.seekTo(position);
  }

  void onPlayPressed() {
    // 이미 실행중이면 정지
    // 실행중이 아니면 실행
    setState(() {
      if (videoController!.value.isPlaying) {
        videoController!.pause();
      } else {
        videoController!.play();
      }
    });
  }

  void onForwordPressed() {
    // 동영상 맨 끝 위치
    final maxPosition = videoController!.value.duration;
    // 동영상 현재 위치
    final currentPosition = videoController!.value.position;

    // 현재 기본 상태는 0초
    Duration position = maxPosition;

    // 현재 위치가 전체 길이보다 더 짧다면 초를 추가해라.
    if ((maxPosition - Duration(seconds: 5)).inSeconds >
        currentPosition.inSeconds) {
      position = currentPosition + Duration(seconds: 5);
    }

    videoController!.seekTo(position);
  }

  void onSliderChanged(double val) {
    videoController!.seekTo(Duration(
      seconds: val.toInt(),
    ));
  }
}

class _Controls extends StatelessWidget {
  final VoidCallback onPlayPressed;
  final VoidCallback onReversePressed;
  final VoidCallback onForwordPressed;
  final bool isPlaying;

  const _Controls(
      {Key? key,
      required this.onPlayPressed,
      required this.onReversePressed,
      required this.onForwordPressed,
      required this.isPlaying})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      height: MediaQuery.of(context).size.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          renderIconButton(
              onPressed: onReversePressed, iconData: Icons.rotate_left),
          renderIconButton(
              onPressed: onPlayPressed,
              iconData: isPlaying ? Icons.pause : Icons.play_arrow),
          renderIconButton(
              onPressed: onForwordPressed, iconData: Icons.rotate_right),
        ],
      ),
    );
  }

  Widget renderIconButton({
    required VoidCallback onPressed,
    required IconData iconData,
  }) {
    return IconButton(
        onPressed: onPressed,
        iconSize: 30.0,
        color: Colors.white,
        icon: Icon(iconData));
  }
}

class _NewVideo extends StatelessWidget {
  final VoidCallback onPressed;

  const _NewVideo({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        right: 0,
        child: IconButton(
            onPressed: onPressed,
            color: Colors.white,
            iconSize: 30.0,
            icon: Icon(Icons.photo_camera_back)));
  }
}

class _SliderBottom extends StatelessWidget {
  final Duration currentPosition;
  final Duration maxPosition;
  final ValueChanged<double> onSliderChanged;

  const _SliderBottom(
      {Key? key,
      required this.currentPosition,
      required this.maxPosition,
      required this.onSliderChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Text(
              '${currentPosition.inMinutes}:${(currentPosition.inSeconds % 60).toString().padLeft(2, '0')}',
              style: TextStyle(color: Colors.white),
            ),
            Expanded(
              child: Slider(
                value: currentPosition.inSeconds.toDouble(),
                onChanged: onSliderChanged,
                max: maxPosition.inSeconds.toDouble(),
                min: 0,
              ),
            ),
            Text(
              '${maxPosition.inMinutes}:${(maxPosition.inSeconds % 60).toString().padLeft(2, '0')}',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
