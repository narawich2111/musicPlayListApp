import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:music_playlist/components/playlist_tile.dart';
import 'package:music_playlist/model/playList.dart';
import 'package:music_playlist/model/playlist_provider.dart';
import 'package:music_playlist/model/song.dart';
import 'package:provider/provider.dart';
import 'package:music_playlist/pages/playlist_detail.dart';
import 'package:music_playlist/model/song_provider.dart';

class myPlaylist extends StatefulWidget {
  const myPlaylist({super.key});

  @override
  State<myPlaylist> createState() => _myPlaylistState();
}

class _myPlaylistState extends State<myPlaylist> {
  Logger logger = Logger();
  late SongProvider songProvider;
  List<Song> songs = [];
  int currentSong = 0;
  String playlistTempId = "";
  String currentTitle = "";
  String currentCover = "";
  String currentSubtitle = "";
  String currentPlaylistId = "";
  bool isSelectedPlaylist = false;
  bool isPlaying = false;
  @override
  void initState() {
    super.initState();
    didChangeDependencies();
    setState(() {
      logger.i('Initializing myPlaylist state...');
      logger.i('Current Song isPlaying: ${songProvider.isPlaying}');
      isPlaying = songProvider.isPlaying;
    });
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    songProvider = Provider.of<SongProvider>(context, listen: false);
  }

  void goToPlaylist(String playlistId, bool isPlaying) {
    // Navigate to the playlist details page or handle the action
    logger.i('Navigating to Playlist ID: $playlistId');
    logger.i('playlistTempId: $playlistTempId');
    if (playlistTempId == "") {
      playlistTempId = playlistId;
    }
    // logger.i('Navigating to Playlist ID: $playlistId');
    // logger.i('Is Playing: $isPlaying');
    songs = songProvider.songs
        .where((song) => song.playlistid == playlistId)
        .toList();
    // logger.i('Songs in Playlist: ${songs.length}');
    if (songs.isEmpty) {
      // logger.i('No songs found in this playlist.');
      return;
    }
    if (songProvider.currentSongIndex != null) {
      // logger
      //     .i('Current Song: ${songs[songProvider.currentSongIndex!].songName}');
      if (playlistTempId == playlistId) {
        logger.i('Already in the same playlist, no action taken.');
        // songProvider.pauseOrResume(); // Play the current song
        playlistTempId = playlistId;
      } else {
        logger.i(
            'Different playlist, updating current song index to the first song.');
        // currentSong = songProvider.currentSongIndex!;
        currentSong = int.parse(songs[0].songId) - 1;
        songProvider.currentSongIndex = currentSong;
        songProvider.play(); // Play the current song
        playlistTempId = playlistId;
        // isPlaying = true; // Set to true if a song is currently playing
      }
    } else {
      logger.i('No current song playing.');
      currentSong = int.parse(songs[0].songId) -
          1; // Default to the first song if no song is playing
      songProvider.currentSongIndex = currentSong; // Set the current song index
      // isPlaying = true; // Set to false if no song is currently playing
      songProvider.pauseOrResume(); // Play the first song
      playlistTempId = playlistId;
    }
    songProvider.isPlaying = true;
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => PlaylistDetailPage(
    //       playlistId: playlistId,
    //       isPlaying: isPlaying,
    //       songProvider: songProvider,
    //     ),
    //   ),
    // );
    goToPlaylistDetail(playlistId); // Navigate to the playlist detail page
  }

  void goToPlaylistDetail(String playlistId) {
    logger.i('Navigating to Playlist Detail Page with ID: $playlistId');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlaylistDetailPage(
          playlistId: playlistId,
          isPlaying: isPlaying,
          songProvider: songProvider,
        ),
      ),
    ).then((_) {
      // This is called when returning to this page
      isPlaying = songProvider.isPlaying;
      setState(() {
        logger.i('Returned to myPlaylist, updated isPlaying: $isPlaying');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          children: [
            // const SizedBox(width: 10),
            const Text(
              'My Playlist',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            // const SizedBox(height: 20),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        // titleSpacing: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: Consumer<PlaylistProvider>(
                builder: (context, playlistProvider, child) {
              final List<Playlist> playlists = playlistProvider.playlists;
              return ListView.builder(
                itemCount: playlists.length,
                itemBuilder: (context, index) => playlistTile(
                  title: playlists[index].playlistname,
                  cover: playlists[index].playlistimage,
                  subtitle: playlists[index].playlistsubtitle,
                  onTap: () {
                    setState(() {
                      currentTitle = playlists[index].playlistname;
                      currentCover = playlists[index].playlistimage;
                      currentSubtitle = playlists[index].playlistsubtitle;
                      currentPlaylistId = playlists[index].playlistid;
                      isPlaying = !isPlaying;

                      logger.i(
                          "Playlist ID: ${playlists[index].playlistid}"); // Log the playlist ID
                      logger
                          .i("Playlist Name: ${playlists[index].playlistname}");
                      goToPlaylist(playlists[index].playlistid, isPlaying);
                      isSelectedPlaylist = true;
                    });
                  },
                ),
              );
            }),
          ),
          isSelectedPlaylist
              ? Container(
                  margin: const EdgeInsets.only(left: 0, right: 0, top: 10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Colors.black12,
                    //     blurRadius: 10,
                    //   ),
                    // ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Consumer<SongProvider>(
                        builder: (context, provider, child) {
                          return Container(
                            width: double.infinity,
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight:
                                    6, // Optional: makes the track thinner
                                thumbShape: const RoundSliderThumbShape(
                                    enabledThumbRadius: 0),
                                overlayShape: SliderComponentShape.noOverlay,
                                trackShape:
                                    const RectangularSliderTrackShape(), // removes round padding
                              ),
                              child: Slider(
                                min: 0,
                                max:
                                    provider.totalDuration.inSeconds.toDouble(),
                                value: provider.currentDuration.inSeconds
                                    .clamp(0, provider.totalDuration.inSeconds)
                                    .toDouble(),
                                activeColor: Color.fromARGB(255,225,190,90),
                                inactiveColor:
                                    Colors.grey.shade400.withOpacity(0.7),
                                onChanged: (double value) {
                                  logger.i("onChanged Slider value: $value");
                                },
                                onChangeEnd: (double value) {
                                  logger.i("Slider value: $value");
                                  provider
                                      .seek(Duration(seconds: value.toInt()));
                                },
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          // Handle play/pause action here
                          // goToPlaylist(currentPlaylistId, isPlaying);
                          goToPlaylistDetail(currentPlaylistId);
                          // setState(() {
                          //   isPlaying = !isPlaying;
                          // });
                          logger.d("Tap Bar");
                        },
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(width: 10),
                            Container(
                              height: 80.0,
                              width: 80.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                image: DecorationImage(
                                  image: AssetImage(currentCover),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentTitle,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  currentSubtitle,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    // if (isPlaying) {
                                    //   songProvider.pause();
                                    // } else {
                                    //   songProvider.resume();
                                    // }
                                    songProvider.pauseOrResume();
                                    isPlaying = !isPlaying;
                                  });
                                },
                                icon: isPlaying
                                    ? const Icon(
                                        Icons.pause,
                                        size: 40,
                                      )
                                    : const Icon(
                                        Icons.play_arrow,
                                        size: 40,
                                      )),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ))
              : const SizedBox(),
        ],
      ),
    );
  }
}
