class PlaylistModel {
  String songName;
  String albumName = "";
  int songId;
  String filePath;
  String thumbNail = "";
  String artists;

  PlaylistModel(
      {this.albumName,
      this.songName,
      this.filePath,
      this.songId,
      this.thumbNail});
}
