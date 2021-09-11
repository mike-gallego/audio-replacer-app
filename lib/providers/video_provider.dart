import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class VideoProvider extends ChangeNotifier {
  File? _videoFile;
  File get videoFile => _videoFile ?? File('');

  VideoPlayerController? _videoPlayerController;
  VideoPlayerController? get videoPlayerController => _videoPlayerController;

  Future<void> pickVideo() async {
    final pickedFile = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.video);
    _videoFile = File(pickedFile!.files.first.path);
    notifyListeners();
  }

  Future<void> replaceAudio() async {
    final pickedFile = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['mp3', 'mp4', 'aac']);

    final quietVideo = await removeSound(_videoFile!);
    final extractedSound = await extractSound(
        File(pickedFile!.files.first.path), pickedFile.files.first.extension!);
    final mergedSoundVideo = await mergeSound(
        quietVideo, extractedSound, pickedFile.files.first.extension!);
    _videoFile = mergedSoundVideo;
    notifyListeners();
  }

  Future<void> playVideo(File videoFile) async {
    _videoPlayerController = VideoPlayerController.file(videoFile)
      ..initialize().then((value) => _videoPlayerController!.play());
  }

  Future<File> removeSound(File input) async {
    final flutterFFmpeg = FlutterFFmpeg();
    final output = await getExternalStorageDirectory();

    await flutterFFmpeg.executeWithArguments([
      '-y',
      '-i',
      input.path,
      '-vcodec',
      'copy',
      '-an',
      '${output!.path}/quietVideo.mp4'
    ]).then((executionCode) => debugPrint(
        'The sound removal execution processed with code: $executionCode'));

    _videoFile = File(output.path + '/quietVideo.mp4');
    return File(output.path + '/quietVideo.mp4');
  }

  Future<File> extractSound(File input, String extension) async {
    final flutterFFmpeg = FlutterFFmpeg();
    final output = await getExternalStorageDirectory();

    await flutterFFmpeg.executeWithArguments([
      '-y',
      '-i',
      input.path,
      '-acodec',
      'copy',
      extension == 'mp4'
          ? '${output!.path}/extractedSound.aac'
          : '${output!.path}/extractedSound.mp3'
    ]).then((executionCode) => debugPrint(
        'The extraction execution processed with code: $executionCode'));
    return extension == 'mp4'
        ? File(output.path + '/extractedSound.aac')
        : File(output.path + '/extractedSound.mp3');
  }

  Future<File> mergeSound(File video, File audio, String extension) async {
    final flutterFFmpeg = FlutterFFmpeg();
    final output = await getExternalStorageDirectory();

    await flutterFFmpeg.executeWithArguments([
      '-y',
      '-stream_loop',
      '-i',
      video.path,
      '-i',
      audio.path,
      '-c:v',
      'copy',
      '-c:a',
      'aac',
      '${output!.path}/mergedSoundVideo.mp4'
    ]).then((executionCode) =>
        debugPrint('The merge execution processed with code: $executionCode'));
    return File(output.path + '/mergedSoundVideo.mp4');
  }
}
