import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:player/presentation/screens/album_details.dart';
import 'package:player/presentation/widgets/album_card.dart';
import 'package:player/presentation/widgets/mini_player.dart';
import 'package:player/utils/constants.dart';

class PlaylistPage extends StatefulWidget {
  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();

  final player = AudioPlayer();
  bool isPlaying = false;
  String songName = 'Nothing playing';
  IconData playButtonIcon = Icons.play_arrow;
  List<SongInfo> songLists;
  List<AlbumInfo> albumLists;
  PlaylistInfo playlist;
  int track = 0;
  @override
  void initState() {
    super.initState();
    getArtist();
    getAlbums();
    getGenre();
  }

  void getArtist() async {
    songLists = await audioQuery.getSongs();
    songLists.forEach((element) {
    });
    print(playlist);

    List<SongInfo> songs = await audioQuery.getSongsFromAlbum(albumId: '5');
    // songs.forEach((element) {
    //   print(element);
    // });
  }

  void getGenre() async {
    List<GenreInfo> genres = await audioQuery.getGenres();
    genres.forEach((element) => print(element));
  }

  void getAlbums() async {
    List<PlaylistInfo> playlist = await audioQuery.getPlaylists();
    albumLists = await audioQuery.getAlbums();
    albumLists.forEach((element) => print(element));
    print("Playlist: $playlist");
  }

  playCheck() {
    if (isPlaying) {
      playButtonIcon = Icons.pause;
    } else {
      playButtonIcon = Icons.play_arrow;
    }
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kWhiteBackground,
      body: SafeArea(
          child: Container(
        child: Stack(children: [
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Container(
                  height: 30,
                  padding: EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Create Playlist"),
                        Container(
                            child: Icon(
                          Icons.playlist_add,
                          semanticLabel: "Create Playlist",
                        ))
                      ],
                    ),
                  ),
                ),
                Container(
                  height: _size.height * 0.70,
                  child: FutureBuilder(
                    future: audioQuery.getAlbums(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        albumLists = snapshot.data;
                        return GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                            itemCount: albumLists.length,
                            itemBuilder: (context, index) {
                              print(songLists[index].albumArtwork);
                              return AlbumCard(
                                albumArt: albumLists[index].albumArt,
                                albumTitle: albumLists[index].title,
                                numberOfSong:
                                    int.parse(albumLists[index].numberOfSongs),
                                favorite: true,
                                onPlay: () {},
                                onPress: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return AlbumDetails(
                                        albumArt: albumLists[index].albumArt,
                                        albumName: albumLists[index].title,
                                        albumId:
                                            int.parse(albumLists[index].id));
                                  }));
                                },
                              );
                            });
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 200,
              ),
              SizedBox(
                height: 100.0,
              )
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: _size.height * 0.11,
              child: FutureBuilder(
                future: audioQuery.getAlbums(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return MiniPlayer(
                        playPress: () async {
                          if (player.playerState.playing) {
                            player.pause();
                            isPlaying = false;
                          } else {
                            isPlaying = true;
                            player.play();
                          }
                          await player.setFilePath(songLists[track].filePath);
                          setState(() {
                            playCheck();
                            songName = songLists[track].displayName;
                          });
                        },
                        onPress: () {},
                        playIcon: playButtonIcon,
                        albumArt: songLists[track].albumArtwork,
                        artistName: songLists[track].artist,
                        albumName: songLists[track].album,
                        currentPosition: Duration(seconds: 10),
                        songDuration: Duration(seconds: 10),
                        songName: songLists[track].displayName);
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ),
        ]),
      )),
    );
  }
}

class SeekBar extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final ValueChanged<Duration> onChanged;
  final ValueChanged<Duration> onChangeEnd;

  SeekBar({
    @required this.duration,
    @required this.position,
    this.onChanged,
    this.onChangeEnd,
  });

  @override
  _SeekBarState createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  double _dragValue;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Slider(
          min: 0.0,
          max: widget.duration.inMilliseconds.toDouble(),
          value: min(_dragValue ?? widget.position.inMilliseconds.toDouble(),
              widget.duration.inMilliseconds.toDouble()),
          onChanged: (value) {
            setState(() {
              _dragValue = value;
            });
            if (widget.onChanged != null) {
              widget.onChanged(Duration(milliseconds: value.round()));
            }
          },
          onChangeEnd: (value) {
            if (widget.onChangeEnd != null) {
              widget.onChangeEnd(Duration(milliseconds: value.round()));
            }
            _dragValue = null;
          },
        ),
        Positioned(
          right: 16.0,
          bottom: 0.0,
          child: Text(
              RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                      .firstMatch("$_remaining")
                      ?.group(1) ??
                  '$_remaining',
              style: Theme.of(context).textTheme.caption),
        ),
      ],
    );
  }

  Duration get _remaining => widget.duration - widget.position;
}

_showSliderDialog({
  BuildContext context,
  String title,
  int divisions,
  double min,
  double max,
  String valueSuffix = '',
  Stream<double> stream,
  ValueChanged<double> onChanged,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title, textAlign: TextAlign.center),
      content: StreamBuilder<double>(
        stream: stream,
        builder: (context, snapshot) => Container(
          height: 100.0,
          child: Column(
            children: [
              Text('${snapshot.data?.toStringAsFixed(1)}$valueSuffix',
                  style: TextStyle(
                      fontFamily: 'Fixed',
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0)),
              Slider(
                divisions: divisions,
                min: min,
                max: max,
                value: snapshot.data ?? 1.0,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
