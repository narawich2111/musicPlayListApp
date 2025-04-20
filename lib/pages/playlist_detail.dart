import 'package:flutter/material.dart';
import 'package:music_playlist/model/song.dart';
import 'package:music_playlist/model/song_provider.dart';
import 'package:logger/logger.dart';

class PlaylistDetailPage extends StatefulWidget {
  final String playlistId;
  late final bool isPlaying; // Default value for isPlaying
  final SongProvider songProvider;

  PlaylistDetailPage(
      {super.key,
      required this.playlistId,
      required this.isPlaying,
      required this.songProvider});

  @override
  State<PlaylistDetailPage> createState() => _PlaylistDetailPageState();
}

class _PlaylistDetailPageState extends State<PlaylistDetailPage> {
  late bool isPlaying; // Use the value passed from the constructor
  late int currentSong;
  late SongProvider songProvider; // Initialize the SongProvider
  List<Song> songs = [];
  Logger logger = Logger();
  @override
  void initState() {
    super.initState();
    songProvider =
        widget.songProvider; // Get the SongProvider instance from the widget
    isPlaying = songProvider
        .isPlaying; // Initialize isPlaying with the value passed from the constructor
    logger.i(
        'songProviderisPlaying: $isPlaying'); // Log the initial value of isPlaying
    setState(() {
      songs = songProvider.songs
          .where((song) => song.playlistid == widget.playlistId)
          .toList();
      if (isPlaying) {
        if (songs.isNotEmpty) {
          logger.i('Songs found in this playlist: ${songs.length}');
          if (songProvider.currentSongIndex != null &&
              songProvider.currentSongIndex! < songs.length) {
            currentSong = songProvider.currentSongIndex!;
          } else {
            logger.i(
                'No current song index found, defaulting to the first song: ${songs[0].songId}');
            logger.i(
                'No current song index found, defaulting to the first song: ${songs[0].songName}');
            currentSong = (songProvider.currentSongIndex!) %
                songs.length; // Default to the first song if no song is playing
            logger.i('currentSong: ${currentSong}');
            logger.i(
                'Now current song playing, defaulting to the first song: ${songs[0].songName}');
            // songProvider.currentSongIndex = int.parse(songs[0].songId) - 1;
          }
        } else {
          logger.i('No songs found in this playlist.');
          currentSong = 0; // Default to 0 to avoid index errors
        }
      } else {
        logger.i('isPlaying is true ${songProvider.currentSongIndex!}');
        currentSong = (songProvider.currentSongIndex!) % songs.length;
        logger.i('isPlaying is true currentSong ${currentSong}');
      }
    });
  }

  void nextSong(int index, int songId) {
    setState(() {
      currentSong = (index + 1) % songs.length; // Move to the next song
      String nextSong = songs[currentSong].songId; // Get the next song
      logger.i('Next song ID: $nextSong'); // Log the next song ID for debugging
      songProvider.currentSongIndex =
          int.parse(nextSong) - 1; // Update the current song index
    });
  }

  void selectSong(int index, int songId) {
    currentSong = index; // Update the current song
    songProvider.currentSongIndex = songId; // Update the current song index
    setState(() {});
  }

  void dispose() {
    super.dispose();
    logger.i('Disposing PlaylistDetailPage');
    // songProvider.isPlaying = false; // Set isPlaying to false when disposing
    songProvider.isPlaying =
        isPlaying; // Update the isPlaying value in the widget
  }

  // AudioPlayer audioPlayer = new AudioPlayer();
  // void stopSong() async {
  //   await audioPlayer.stop();
  // }
  // void playSong(String url) async {
  //   await audioPlayer.setSourceUrl(url);
  //   await audioPlayer.resume();
  // }
  // void pauseSong() async {
  //   await audioPlayer.pause();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 33, 72, 99),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 20, 46, 62),
        automaticallyImplyLeading: false,
        elevation: 0,
        titleSpacing: 0,
        toolbarHeight: 80,
        title: Row(
          children: [
            const SizedBox(width: 20),
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.asset(
                      songs.isNotEmpty
                          ? songs[currentSong].songImage
                          : 'assets/images/playlist${widget.playlistId}.jpg',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover),
                )
              ],
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  songs.isNotEmpty
                      ? songs[currentSong].songName
                      : 'Playlist Name',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  songs.isNotEmpty
                      ? songs[currentSong].artistName
                      : 'Playlist Name',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
            onPressed: () {
              setState(() {
                songProvider.pauseOrResume(); // Pause or resume the song
                isPlaying = !isPlaying; // Toggle play/pause state
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.skip_next), // Icon for the next song
            onPressed: () {
              // Logic to play the next song
              print('Next song button pressed');
              nextSong(currentSong, int.parse(songs[currentSong].songId) - 1);
              setState(() {
                isPlaying = true; // Set to true when the next song is played
              });
            },
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2, // Number of tabs
        child: Column(
          children: [
            Container(
              // padding: const EdgeInsets.only(top: 5, bottom: 0),
              child: const Icon(
                Icons.horizontal_rule_rounded,
                color: Color.fromARGB(255, 59, 96, 120),
                size: 50, // Adjust the size of the icon
              ),
            ),
            Container(
              color: const Color.fromARGB(
                  255, 33, 72, 99), // TabBar background color
              child: const TabBar(
                indicatorColor: Colors.white, // Indicator color
                labelColor: Colors.white, // Selected tab text color
                unselectedLabelColor:
                    Colors.white70, // Unselected tab text color
                tabs: [
                  Tab(text: 'UP NEXT'),
                  Tab(text: 'LYRICS'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // UP NEXT Tab Content

                  ListView.builder(
                    itemCount: songs.length,
                    itemBuilder: (context, index) {
                      final song = songs[index];
                      final isCurrentSong = index == currentSong;
                      return Container(
                        decoration: BoxDecoration(
                          color: isCurrentSong
                              ? Colors.white.withOpacity(
                                  0.1) // Highlight color for current song
                              : Colors.transparent, // Default background
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Stack(
                              children: [
                                Image.asset(
                                  song.songImage,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                                if (isCurrentSong) // Show watermark only for the current song
                                  Positioned(
                                    left: 5,
                                    top: 5,
                                    bottom: 5,
                                    right: 5,
                                    child: Container(
                                      padding: const EdgeInsets.all(0),
                                      color: Colors.black.withOpacity(
                                          0.5), // Semi-transparent background
                                      child: const Icon(
                                        Icons
                                            .equalizer, // Replace with your desired icon
                                        color: Colors.white,
                                        size: 20, // Adjust the size of the icon
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          title: Text(
                            song.songName,
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            song.artistName + '・' + song.durationTime.replaceAll('.', ':'),
                            style: const TextStyle(color: Colors.white70),
                          ),
                          trailing: const Icon(
                            Icons.drag_handle,
                            color: Colors.white70,
                            size: 35,
                          ),
                          onTap: () {
                            setState(() {
                              currentSong = index;
                              selectSong(
                                  currentSong,
                                  int.parse(song.songId) -
                                      1); // Update the current song
                            });
                          },
                        ),
                      );
                    },
                  ),
                  // LYRICS Tab Content
                  Center(
                    child: Text(
                      'Lyrics will be displayed here.',
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
