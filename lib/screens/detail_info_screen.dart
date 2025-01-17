import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class DetailedInfoScreen extends StatefulWidget {
  final String title;
  final String content;
  final String duration;
  final int number;
  final String videoUrl;

  const DetailedInfoScreen({
    required this.title,
    required this.content,
    required this.duration,
    required this.number,
    required this.videoUrl,
    super.key,
  });

  @override
  _DetailedInfoScreenState createState() => _DetailedInfoScreenState();
}

class _DetailedInfoScreenState extends State<DetailedInfoScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: YoutubePlayerController.convertUrlToId(widget.videoUrl)!,
      params: const YoutubePlayerParams(
        mute: false,
        // showControls: true, // Set to true to allow minimal controls
        showFullscreenButton: true,
        // modestBranding: true, // Ensures YouTube branding is minimized
        showVideoAnnotations: false, // Hide video annotations
        enableCaption: false, // Disable captions if not needed
        enableJavaScript: true, // Enables JavaScript for better compatibility
        playsInline: true, // Ensures video plays inline rather than fullscreen
        enableKeyboard: false, // Disables keyboard controls for better UI
        // rel: false, // Prevents showing related videos at the end
        loop: true, // Loops the video once it ends
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            YoutubePlayer(
              controller: _controller,
              aspectRatio: 16 / 9,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Duration: ${widget.duration} seconds',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            Scrollbar(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description: ',
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    widget.content,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  
                  ),
                ],
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}
