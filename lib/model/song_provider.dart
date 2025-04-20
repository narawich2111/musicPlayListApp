import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_playlist/model/song.dart';

class SongProvider extends ChangeNotifier {
  List<Song> _songs = [
    Song(
      songName: 'Song 1',
      artistName: 'Artist 1',
      songImage: 'assets/images/song1.jpg',
      songId: '1',
      songUrl: 'audio/song1.mp3',
      playlistid: '1',
      durationTime: '3.59',
    ),
    Song(
      songName: 'Song 2',
      artistName: 'Artist 2',
      songImage: 'assets/images/song2.jpg',
      songId: '2',
      songUrl: 'audio/song2.mp3',
      playlistid: '1',
      durationTime: '2.22',
    ),
    // Add more songs as needed
    Song(
      songName: 'Song 3',
      artistName: 'Artist 3',
      songImage: 'assets/images/song3.jpg',
      songId: '3',
      songUrl: 'audio/song3.mp3',
      playlistid: '2',
      durationTime: '4.00',
    ),
    Song(
      songName: 'Song 4',
      artistName: 'Artist 4',
      songImage: 'assets/images/song4.jpg',
      songId: '4',
      songUrl: 'audio/song4.mp3',
      playlistid: '2',
      durationTime: '2.15',
    ),
    Song(
      songName: 'Song 5',
      artistName: 'Artist 5',
      songImage: 'assets/images/song5.jpg',
      songId: '5',
      songUrl: 'audio/song5.mp3',
      playlistid: '3',
      durationTime: '2.33',
    ),
  ];

  int? _currentSongIndex;

  final AudioPlayer _audioPlayer = AudioPlayer();

  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;
  Duration _prevDuration = Duration.zero;
  Duration _prevPosition = Duration.zero;

  SongProvider() {
    print("SongProvider initialized");
    listenToDuration();
  }

  bool _isPlaying = false;

  void play() async {
    final String path = _songs[_currentSongIndex!].songUrl;
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(path));
    _isPlaying = true;
    notifyListeners();
  }

  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  void resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  void pauseOrResume() async {
    print("_isPlaying: ");
    print(_isPlaying);

    if (_isPlaying) {
      await _audioPlayer.pause();
      _isPlaying = false;
    } else {
      await _audioPlayer.resume();
      _isPlaying = true;
    }
    notifyListeners();
  }

  void seek(Duration position) async {
    await _audioPlayer.seek(position);
    // notifyListeners();
  }

  void playNextSong() {
    print("Playing next song");
    print("Current song index: $_currentSongIndex");
    print("Total songs: ${_songs.length}");
    _currentDuration = Duration.zero;
    _prevDuration = Duration.zero;
    _prevPosition = Duration.zero;
    
    var thisSongList = _songs
        .where((element) =>
            element.playlistid == _songs[_currentSongIndex!].playlistid)
        .toList();
    print("This song list: $thisSongList");
    var firstSong = thisSongList[0];
    var lastSong = thisSongList[thisSongList.length - 1];
    print("Last song: $lastSong");
    if (_currentSongIndex != null) {
      // if (_currentSongIndex! < _songs.length - 1) {
      if (_currentSongIndex! == int.parse(lastSong.songId) - 1) {
        _currentSongIndex =
            int.parse(firstSong.songId) - 1; // Loop back to the first song
        play();
      } else if (_currentSongIndex! < _songs.length - 1) {
        _currentSongIndex = _currentSongIndex! + 1;
        print("Current song index----: $_currentSongIndex");
        play();
      } else {
        _currentSongIndex = 0; // Loop back to the first song
        play();
      }
    }
  }

  void listenToDuration() {
    print("Listening to duration changes");
    _audioPlayer.onDurationChanged.listen((duration) {
      _totalDuration = duration;
      notifyListeners();
    });
    _audioPlayer.onPositionChanged.listen((position) {
      print("---------");
      print("Position changed: $position");
      print("Prev Position changed: $_prevPosition");
      print("Current duration: $_currentDuration");
      print("Previous duration: $_prevDuration");
      print("===============");
      _prevPosition = position;
      if (_prevDuration > position) {
        Duration diff = _prevDuration - position;
        print("Difference: $diff");
        if (diff > Duration.zero) {
          var positionDiff = _prevPosition - position;
          print("Position difference: $positionDiff");
          _currentDuration = _prevDuration + positionDiff;
          _prevDuration = _currentDuration;
          notifyListeners();
          return;
          // print("Current duration: $_currentDuration");
          // print("Previous duration: $_prevDuration");
        }
      } else {
        _currentDuration = position;
        _prevDuration = position;
        print("Outer Current duration: $_currentDuration");
        print("Outer Previous duration: $_prevDuration");
        notifyListeners();
      }
    });
    _audioPlayer.onPlayerComplete.listen((event) {
      // print("Song completed, playing next song");
      playNextSong();
    });
  }

  List<Song> get songs => _songs;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;

  set currentSongIndex(int? newIndex) {
    print("Setting current song index to: $newIndex");
    _currentSongIndex = newIndex;
    if (newIndex != null) {
      print("Playing song: ${_songs[newIndex].songName}");
      print("Playing song URL: ${_songs[newIndex].songUrl}");
      play();
    }
    notifyListeners();
  }

  set isPlaying(bool newValue) {
    _isPlaying = newValue;
    notifyListeners();
  }
}
