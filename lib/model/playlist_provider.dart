import 'package:flutter/material.dart';
import 'package:music_playlist/model/playList.dart';
// import 'package:music_playlist/model/song.dart';

class PlaylistProvider extends ChangeNotifier {
  // List<Playlist> _playlists = [];

  // List<Playlist> get playlists => _playlists;

  // void addPlaylist(Playlist playlist) {
  //   _playlists.add(playlist);
  //   notifyListeners();
  // }

  // void removePlaylist(Playlist playlist) {
  //   _playlists.remove(playlist);
  //   notifyListeners();
  // }

  // void updatePlaylist(Playlist oldPlaylist, Playlist newPlaylist) {
  //   int index = _playlists.indexOf(oldPlaylist);
  //   if (index != -1) {
  //     _playlists[index] = newPlaylist;
  //     notifyListeners();
  //   }
  // }

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