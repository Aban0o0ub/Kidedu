import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../data/models/lesson.dart';

// ignore: must_be_immutable
class VideoLesson extends StatefulWidget {
  VideoLesson({
    super.key,
    required this.videoLink,
    this.lessonName,
    this.description,
    this.lesson, // Add lesson parameter for images
  });

  final String videoLink;
  final String? lessonName;
  final String? description;
  final LessonModel? lesson;

  @override
  State<VideoLesson> createState() => _VideoLessonState();
}

class _VideoLessonState extends State<VideoLesson>
    with TickerProviderStateMixin {
  YoutubePlayerController? _controller;
  late AnimationController _sparkleController;
  late Animation<double> _sparkleAnimation;
  bool _showReward = false;
  
  // For image carousel
  PageController _imagePageController = PageController();
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();

    // Debug info
    print('🔍 DEBUG VideoLesson: videoLink = "${widget.videoLink}"');
    print('🔍 DEBUG VideoLesson: lesson.youtubeVideoUrl = "${widget.lesson?.youtubeVideoUrl}"');
    print('🔍 DEBUG VideoLesson: lesson.images = ${widget.lesson?.images}');

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
    if (widget.videoLink.isNotEmpty) {
      final videoId = YoutubePlayer.convertUrlToId(widget.videoLink);
      print('🎥 DEBUG: YouTube Video ID extracted: $videoId');
      
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
      } else {
        print('❌ DEBUG: Failed to extract video ID from URL: ${widget.videoLink}');
      }
    } else {
      print('❌ DEBUG: videoLink is empty');
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

  Widget _buildImageCarousel() {
    final images = widget.lesson!.images!
        .where((img) => img.isNotEmpty)
        .toList();

    return Container(
      margin: EdgeInsets.all(16),
      child: Column(
        children: [
          // Image carousel with nice frame
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
                    child: Stack(
                      children: [
                        // Image PageView
                        PageView.builder(
                          controller: _imagePageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentImageIndex = index;
                            });
                          },
                          itemCount: images.length,
                          itemBuilder: (context, index) {
                            return _buildImage(images[index]);
                          },
                        ),
                        
                        // Navigation arrows (only show if more than 1 image)
                        if (images.length > 1) ...[
                          // Left arrow
                          Positioned(
                            left: 16,
                            top: 0,
                            bottom: 0,
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  if (_currentImageIndex > 0) {
                                    _imagePageController.previousPage(
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          
                          // Right arrow
                          Positioned(
                            right: 16,
                            top: 0,
                            bottom: 0,
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  if (_currentImageIndex < images.length - 1) {
                                    _imagePageController.nextPage(
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                        
                        // Dots indicator (only show if more than 1 image)
                        if (images.length > 1)
                          Positioned(
                            bottom: 16,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                images.length,
                                (index) => Container(
                                  width: 8,
                                  height: 8,
                                  margin: EdgeInsets.symmetric(horizontal: 4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _currentImageIndex == index 
                                        ? Colors.white
                                        : Colors.white.withOpacity(0.4),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String imagePath) {
    if (imagePath.isEmpty) {
      return Container(
        color: Colors.grey[300],
        child: Center(
          child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
        ),
      );
    }

    // Handle network images
    if (imagePath.startsWith('/uploads/')) {
      final fullUrl = 'http://192.168.1.3:3000$imagePath';
      return Image.network(
        fullUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[300],
            child: Center(
              child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
            ),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.grey[200],
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
          );
        },
      );
    } else if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[300],
            child: Center(
              child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
            ),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.grey[200],
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
          );
        },
      );
    } else {
      // Handle asset images
      return Image.asset(
        imagePath,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[300],
            child: Center(
              child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
            ),
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _sparkleController.dispose();
    _imagePageController.dispose(); // Dispose image page controller

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
    // Check if we have a valid YouTube video
    bool hasVideo = _controller != null && widget.videoLink.isNotEmpty;
    
    // Check if we have lesson images
    bool hasImages = widget.lesson?.images != null && 
                    widget.lesson!.images!.isNotEmpty &&
                    widget.lesson!.images!.any((img) => img.isNotEmpty);

    if (hasVideo) {
      // Show YouTube video
      return YoutubePlayerBuilder(
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
      );
    } else if (hasImages) {
      // Show image carousel
      return _buildImageCarousel();
    } else {
      // Show no content message with debug info
      String debugInfo = '';
      if (widget.videoLink.isEmpty && (widget.lesson?.images?.isEmpty ?? true)) {
        debugInfo = 'Both video URL and images are empty';
      } else if (widget.videoLink.isEmpty) {
        debugInfo = 'Video URL is empty but images: ${widget.lesson?.images?.length ?? 0}';
      } else if (widget.lesson?.images?.isEmpty ?? true) {
        debugInfo = 'Images are empty but video URL: "${widget.videoLink}"';
      }
      
      return Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.orange.shade200),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.info_outline,
                  color: Colors.orange.shade600,
                  size: 30,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'No Media Available',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.orange.shade700,
              ),
            ),
            SizedBox(height: 8),
            Text(
              widget.videoLink.isEmpty 
                  ? 'No YouTube video URL was provided for this lesson'
                  : 'Video URL provided but couldn\'t load: "${widget.videoLink}"',
              style: TextStyle(
                fontSize: 14,
                color: Colors.orange.shade500,
              ),
              textAlign: TextAlign.center,
            ),
            if (widget.lesson?.images?.isEmpty ?? true) ...[
              SizedBox(height: 8),
              Text(
                'No images available either',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.orange.shade400,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (debugInfo.isNotEmpty) ...[
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Debug: $debugInfo',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontFamily: 'monospace',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            SizedBox(height: 16),
            Text(
              'Check console logs for more details',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
      );
    }
  }
}
