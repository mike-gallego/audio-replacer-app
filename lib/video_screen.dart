import 'dart:io';

import 'package:audio_player_app/providers/video_provider.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
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
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  provider.videoFile.path == ''
                      ? Container(
                          color: Colors.red,
                          height: 300,
                        )
                      : Container(
                          height: 300,
                          child: VideoPlayer(provider.videoPlayerController!),
                        ),
                  ElevatedButton(
                      onPressed: () async {
                        await provider.pickVideo();
                        await provider.playVideo(provider.videoFile);
                      },
                      child: Text('Pick video')),
                  Visibility(
                    visible: provider.pickedVideo!,
                    child: ElevatedButton(
                        onPressed: () async {
                          await provider.replaceAudio();
                          await provider.playVideo(provider.videoFile);
                        },
                        child: Text('Replace audio')),
                  ),
                  Visibility(
                    visible: provider.alteredVideo!,
                    child: ElevatedButton(
                        onPressed: () async {
                          await GallerySaver.saveVideo(provider.videoFile.path,
                              albumName: 'app_movies');
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Video saved!'),
                              action: SnackBarAction(
                                label: 'See Image',
                                onPressed: () async {
                                  await DeviceApps.openApp(
                                      'com.oneplus.gallery');
                                },
                              )));
                        },
                        child: Text('Save video')),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
}
