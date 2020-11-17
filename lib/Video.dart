import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:nested_listview/main.dart';
import 'package:video_player/video_player.dart';

class Video extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool loop;
  Video({@required this.videoPlayerController, this.loop, Key key})
      : super(key: key);
  @override
  _VideoState createState() => _VideoState();
}

class _VideoState extends State<Video> {
  ChewieController _chewieController;
  @override
  void initState() {
    super.initState();
    _chewieController = ChewieController(
        videoPlayerController: widget.videoPlayerController,
        looping: widget.loop,
        aspectRatio: 16/9,
        autoInitialize: true);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(

      padding: const EdgeInsets.all(8.0),
      child: Chewie(
        controller: _chewieController,
      ),
    );
  }

  @override
  void dispose() {
    widget.videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }
}

class MyVideoplayer extends StatefulWidget {
  final String videoData;
  MyVideoplayer({this.videoData});
  @override
  _MyVideoplayerState createState() => _MyVideoplayerState();
}

class _MyVideoplayerState extends State<MyVideoplayer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => MyApp()));
          },
        ),
      ),
      body: Container(
        decoration: new BoxDecoration(color: Colors.black),
        child: Center(

          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Video(
              loop: true,
              videoPlayerController:
              VideoPlayerController.network(widget.videoData),
            ),
          ),
        ),
      ),
    );
  }
}


