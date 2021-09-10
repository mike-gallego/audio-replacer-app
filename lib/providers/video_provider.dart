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
    debugPrint('the path: $_videoFile');
    _videoPlayerController = VideoPlayerController.file(
      _videoFile!,
    )..initialize().then((value) => _videoPlayerController!.play());
    notifyListeners();
    await extractVideo(_videoFile!.path);
  }

  Future<void> extractVideo(String input) async {
    final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
    final output = await getExternalStorageDirectory();
    // 'ffmpeg -I $input -an output.mp4'
    await _flutterFFmpeg.executeWithArguments([
      '-y',
      '-i',
      input,
      '-vcodec',
      'copy',
      '-an',
      '${output!.path}/test.mp4'
    ]).then((value) => debugPrint('the execution: $value'));
  }
}
