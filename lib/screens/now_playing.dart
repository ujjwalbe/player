import 'dart:math';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:player/constants.dart';
import 'package:player/widgets/mini_player.dart';

class NowPlaying extends StatefulWidget {
  @override
  _NowPlayingState createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();

  final player = AudioPlayer();
  bool isPlaying = false;
  String songName = 'Nothing playing';
  IconData playButtonIcon = Icons.play_arrow;
  List<SongInfo> songLists;
  List<AlbumInfo> albumLists;
  int track = 0;
  @override
  void initState() {
    super.initState();
    getArtist();
  }

  void getArtist() async {
    songLists = await audioQuery.getSongs();
    // albumLists.forEach((element) {
    //   print(element.artist);
    // });

    List<SongInfo> songs = await audioQuery.getSongsFromAlbum(albumId: '5');
    songs.forEach((element) {
      print(element);
    });
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
      // bottomNavigationBar: BottomNavigationBar(
      //   backgroundColor: kPrimaryColor,
      
      //   items: [
      //     BottomNavigationBarItem(
      //         icon: Icon(
      //           Icons.home,
      //           color: Colors.red,
      //         ),
      //         title: Text("Home")),
      //     BottomNavigationBarItem(
      //         icon: Icon(
      //           Icons.music_note,
      //           color: Colors.red,
      //         ),
      //         title: Text("some")),
      //     BottomNavigationBarItem(
      //         icon: Icon(
      //           Icons.playlist_play,
      //           color: Colors.red,
      //         ),
      //         title: Text("Playlist")),
      //     BottomNavigationBarItem(
      //         icon: Icon(
      //           Icons.settings_input_antenna,
      //           color: Colors.red,
      //         ),
      //         title: Text("Explore")),
      //   ],
      // ),
      body: SafeArea(
          child: Container(
        child: Stack(children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: _size.height * 0.75,
              child: FutureBuilder(
                future: audioQuery.getSongs(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    songLists = snapshot.data;
                    return ListView.builder(
                        itemCount: songLists.length,
                        itemBuilder: (context, index) {
                          print(songLists[index].albumArtwork);
                          return Container(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            child: ListTile(
                              isThreeLine: true,
                              trailing: Text(
                                  ((int.parse(songLists[index].duration) /
                                              1000) /
                                          60)
                                      .toStringAsFixed(2)),
                              leading: 
                                  Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.0),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: songLists[index].albumArtwork == null? AssetImage('assets/images/album_art.jpg') : FileImage(File(
                                              songLists[index].albumArtwork)),
                                        ),
                                      ),
                                    ),
                              subtitle: Text(songLists[index].artist),
                              onTap: () {
                                setState(() {
                                  playButtonIcon = Icons.pause;
                                  track = index;
                                  songName = songLists[index].displayName;
                                  player.setFilePath(songLists[index].filePath);
                                  player.play();
                                });
                              },
                              title: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(songLists[index].displayName)),
                            ),
                          );
                        });
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
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
                future: audioQuery.getSongs(),
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
              await player
                  .setFilePath(songLists[track].filePath);
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
