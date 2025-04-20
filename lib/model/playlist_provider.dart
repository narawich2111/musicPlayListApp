import 'package:flutter/material.dart';
import 'package:music_playlist/model/playList.dart';

class PlaylistProvider extends ChangeNotifier {

  final List<Playlist> _playlists = [
    Playlist(
      playlistname: 'My Playlist',
      playlistsubtitle: 'My Favorite Songs',
      playlistimage: 'assets/images/playList1.jpg',
      playlistid: '1',
    ),
    Playlist(
      playlistname: 'Chill Vibes',
      playlistsubtitle: 'Relax and Unwind',
      playlistimage: 'assets/images/playList2.jpg',
      playlistid: '2',
    ),
    Playlist(
      playlistname: 'Top Hits',
      playlistsubtitle: 'Trending Now',
      playlistimage: 'assets/images/playList3.jpg',
      playlistid: '3',
    ),
  ];
  List<Playlist> get playlists => _playlists; 
  
  

  
}