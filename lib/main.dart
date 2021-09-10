import 'package:audio_player_app/providers/video_provider.dart';
import 'package:audio_player_app/video_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => VideoProvider(),
      builder: (context, _) {
        return MaterialApp(
          title: 'Audio Player Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: VideoScreen(),
        );
      },
    );
  }
}
