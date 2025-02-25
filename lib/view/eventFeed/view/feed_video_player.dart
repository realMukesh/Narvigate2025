import 'package:chewie/chewie.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class FeedListVideoPLayer extends StatefulWidget {
  dynamic url;
  FeedListVideoPLayer({super.key, required this.url});

  @override
  State<FeedListVideoPLayer> createState() => _FeedListVideoPLayer();
}

class _FeedListVideoPLayer extends State<FeedListVideoPLayer> {
  ChewieController? _chewieController;
  late VideoPlayerController videoPlayerController;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(widget.url.toString() ?? ""),
    )..initialize().then((_) {
        setState(() {});
      });
    _chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: false,
      showOptions: false,
      showControls: true,
      allowFullScreen: true,
      allowPlaybackSpeedChanging: false,
      deviceOrientationsOnEnterFullScreen: [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ],
    );
    enterFullScreen();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
    exitFullScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorLightGray,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            videoPlayerController.value.isInitialized
                ? Flexible(
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Chewie(controller: _chewieController!),
                    ),
                  )
                : const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  void enterFullScreen() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.leanBack); // Hide status and navigation bars
  }

  void exitFullScreen() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp]); // Go back to portrait
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge); // Show status and navigation bars
  }
}
