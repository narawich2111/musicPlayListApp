class Song {
  final String songName;
  final String artistName;
  final String songImage;
  final String songId;
  final String songUrl;
  final String playlistid;
  final String durationTime;

  Song({
    required this.songName,
    required this.artistName,
    required this.songImage,
    required this.songId,
    required this.songUrl,
    required this.playlistid, 
    required this.durationTime,
  });
  // factory Song.fromJson(Map<String, dynamic> json) {
  //   return Song(
  //     songName: json['songName'],
  //     artistName: json['artistName'],
  //     songImage: json['songImage'],
  //     songId: json['songId'],
  //     songUrl: json['songUrl'],
  //     playlistid: json['playlistid'],
  //   );
  // }
}