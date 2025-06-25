import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// ignore: must_be_immutable
class VideoLesson extends StatefulWidget {
  VideoLesson({
    super.key,
    required this.videoLink, this.lessonName, this.description,
  });

  final String videoLink;
  final String? lessonName;
  final String? description;

  @override
  State<VideoLesson> createState() => _VideoLessonState();
}

class _VideoLessonState extends State<VideoLesson> {
  YoutubePlayerController? _controller;

 @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.videoLink);
    if (videoId != null) {
      _controller = YoutubePlayerController(
        initialVideoId: videoId, // مش فاضي!
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          enableCaption: true,
          isLive: false,
          forceHD: true,
        ),
      );
    } else {
      print("Could not parse YouTube URL: ${widget.videoLink}");
    }
  }

 // في VideoLesson
@override
void dispose() {
  if (_controller != null) {
    try {
      _controller!.dispose();
    } catch (e) {
      print('Controller already disposed: $e');
    }
    _controller = null;
  }
  super.dispose();
}

 @override
Widget build(BuildContext context) {
  return _controller != null  // غيّر من widget.videoLink != null
      ? YoutubePlayerBuilder(
          player: YoutubePlayer(
            controller: _controller!,  // أضف ! للـ null assertion
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.red,
            onReady: () {
              debugPrint("Player is ready.");
            },
          ),
          builder: (context, player) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: player,
                ),
              ),
            );
          },
        )
      : Padding(
          padding: const EdgeInsets.only(
              top: 22.0, right: 45, left: 45, bottom: 20),
          child: Stack(
            children: [
              Image.asset("assets/images/Group 594 (1).png"),
              Padding(
                padding: const EdgeInsets.only(
                  top: 122.0,
                  left: 62,
                ),
                child: Row(
                  children: [
                    ImageIcon(
                      AssetImage("assets/images/fluent_previous-16-regular.png"),
                      color: Color(0xff02457A),
                    ),
                    SizedBox(width: 30),
                    ImageIcon(
                      AssetImage("assets/images/Group 574.png"),
                      color: Color(0xff02457A),
                    ),
                    SizedBox(width: 30),
                    ImageIcon(
                      AssetImage("assets/images/Group 587.png"),
                      color: Color(0xff02457A),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
}}
