import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// ignore: must_be_immutable
class VideoLesson extends StatefulWidget {
  VideoLesson({
    super.key,
    required this.videoLink,
    this.lessonName,
    this.description,
  });

  final String videoLink;
  final String? lessonName;
  final String? description;

  @override
  State<VideoLesson> createState() => _VideoLessonState();
}

class _VideoLessonState extends State<VideoLesson>
    with TickerProviderStateMixin {
  YoutubePlayerController? _controller;
  late AnimationController _sparkleController;
  late Animation<double> _sparkleAnimation;
  bool _showReward = false;

  @override
  void initState() {
    super.initState();

    // Simple sparkle animation
    _sparkleController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _sparkleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _sparkleController,
      curve: Curves.easeInOut,
    ));
    _sparkleController.repeat(reverse: true);

    // YouTube setup
    final videoId = YoutubePlayer.convertUrlToId(widget.videoLink);
    if (videoId != null) {
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          enableCaption: true,
          isLive: false,
          forceHD: true,
        ),
      );

      // Listen for video end to show reward
      _controller!.addListener(() {
        if (_controller!.value.playerState == PlayerState.ended &&
            !_showReward) {
          setState(() {
            _showReward = true;
          });
          _showCompletionReward();
        }
      });
    }
  }

  void _showCompletionReward() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [Colors.orange.shade100, Colors.yellow.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.yellow.shade300,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: Center(
                  child: Text('🏆', style: TextStyle(fontSize: 40)),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Great Job!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade700,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'You completed the lesson!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildRewardStar(),
                  _buildRewardStar(),
                  _buildRewardStar(),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );

    // إخفاء الرسالة بعد 3 ثوانٍ
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  Widget _buildRewardStar() {
    return AnimatedBuilder(
      animation: _sparkleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (_sparkleAnimation.value * 0.3),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.yellow.shade400,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.yellow.withOpacity(0.4),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Text('⭐', style: TextStyle(fontSize: 20)),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _sparkleController.dispose();

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
    return _controller != null
        ? YoutubePlayerBuilder(
            player: YoutubePlayer(
              controller: _controller!,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.deepPurple,
              onReady: () {
                debugPrint("Player is ready.");
              },
            ),
            builder: (context, player) {
              return Container(
                margin: EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Video player with nice frame
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [
                            Colors.grey.withOpacity(0.8),
                            Color(0xff02457A).withOpacity(0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 15,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(13),
                              child: player,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          )
        : Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Loading your lesson...',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade700,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Get ready for fun learning!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue.shade500,
                  ),
                ),
              ],
            ),
          );
  }
}
