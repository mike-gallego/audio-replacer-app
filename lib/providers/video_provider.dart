import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
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
    notifyListeners();
  }

  Future<void> playVideo(File videoFile) async {
    _videoPlayerController = VideoPlayerController.file(videoFile)
      ..initialize().then((value) => _videoPlayerController!.play());
  }

  Future<File> replaceAudio(File input) async {
    final flutterFFmpeg = FlutterFFmpeg();
    final output = await getExternalStorageDirectory();

    await flutterFFmpeg.executeWithArguments([
      '-y',
      '-i',
      input.path,
      '-vcodec',
      'copy',
      '-an',
      '${output!.path}/test.mp4'
    ]).then((executionCode) =>
        debugPrint('the execution processed with code: $executionCode'));

    _videoFile = File(output.path + '/test.mp4');
    notifyListeners();
    return File(output.path + '/test.mp4');
  }
}
