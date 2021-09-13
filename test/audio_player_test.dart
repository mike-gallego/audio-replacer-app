import 'dart:io';

import 'package:audio_player_app/providers/video_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  Future<String> setUpTest() async {
    const channel = MethodChannel(
      'plugins.flutter.io/path\_provider',
    );

    const TEST_MOCK_STORAGE = './test/fixtures/core';
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return TEST_MOCK_STORAGE;
    });
    return Future.value('');
  }

  setUp(() async {
    await setUpTest();
  });
  group(
    'audio-player-app in testing',
    () {
      testWidgets(
        'check if user picked video',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            ChangeNotifierProvider(
                create: (context) => VideoProvider(),
                lazy: false,
                builder: (context, _) {
                  WidgetsBinding.instance!
                      .addPostFrameCallback((timeStamp) async {
                    final videoProvider =
                        Provider.of<VideoProvider>(context, listen: false);
                    await videoProvider.pickVideo(isTest: true);
                    expect(videoProvider.pickedVideo, true);
                  });
                  return Container();
                }),
          );
        },
      );
      testWidgets(
        'check if user altered video',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            ChangeNotifierProvider(
                create: (context) => VideoProvider(),
                lazy: false,
                builder: (context, _) {
                  WidgetsBinding.instance!
                      .addPostFrameCallback((timeStamp) async {
                    final videoProvider =
                        Provider.of<VideoProvider>(context, listen: false);
                    await videoProvider.replaceAudio(isTest: true);
                    expect(videoProvider.alteredVideo, true);
                  });
                  return Container();
                }),
          );
        },
      );
    },
  );
}
