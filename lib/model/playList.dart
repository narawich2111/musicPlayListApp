class Playlist {
  final String playlistname;
  final String playlistimage;
  final String playlistid;
  final String playlistsubtitle;

  Playlist({
    required this.playlistname,
    required this.playlistimage,
    required this.playlistid,
    required this.playlistsubtitle,
  });
  // factory Playlist.fromJson(Map<String, dynamic> json) {
  //   return Playlist(
  //     playlistname: json['playlistname'],
  //     playlistimage: json['playlistimage'],
  //     playlistid: json['playlistid'],
  //   );
  // }
}