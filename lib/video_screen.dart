import 'dart:io';

import 'package:audio_player_app/providers/video_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  VideoScreen({Key? key}) : super(key: key);

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<VideoProvider>(builder: (context, provider, _) {
      return SafeArea(
        child: Scaffold(
          body: Container(
            margin: const EdgeInsets.all(32.0),
            child: Column(
              children: [
                provider.videoFile == File('')
                    ? Container(
                        color: Colors.red,
                        height: 300,
                      )
                    : Container(
                        height: 300,
                        child: VideoPlayer(provider.videoPlayerController ??
                            VideoPlayerController.file(File(''))),
                      ),
                ElevatedButton(
                    onPressed: () async {
                      await provider.pickVideo();
                      await provider.playVideo(provider.videoFile);
                    },
                    child: Text('Pick video')),
                ElevatedButton(
                    onPressed: () async {
                      final file =
                          await provider.replaceAudio(provider.videoFile);
                      await provider.playVideo(file);
                    },
                    child: Text('Replace audio')),
              ],
            ),
          ),
        ),
      );
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
}
