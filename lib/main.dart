import 'package:flutter/material.dart';
import 'package:music_playlist/model/playlist_provider.dart';
import 'package:music_playlist/model/song_provider.dart';
import 'package:music_playlist/pages/my_playlist.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => PlaylistProvider()),
      ChangeNotifierProvider(create: (_) => SongProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: myPlaylist(),
    );
  }
}