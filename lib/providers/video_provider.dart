import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class VideoProvider extends ChangeNotifier {
  final picker = ImagePicker();

  File? _videoFile;
  File get videoFile => _videoFile ?? File('');

  VideoPlayerController? _videoPlayerController;
  VideoPlayerController? get videoPlayerController => _videoPlayerController;

  Future<void> pickVideo() async {
    XFile? pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    _videoFile = File(pickedFile!.path);
    _videoPlayerController = VideoPlayerController.file(
      _videoFile!,
    )..initialize().then((value) => _videoPlayerController!.play());
    notifyListeners();
  }
}
