import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:just_audio/just_audio.dart';

class PlayerHome extends StatefulWidget {
  @override
  _PlayerHomeState createState() => _PlayerHomeState();
}

class _PlayerHomeState extends State<PlayerHome> {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();

  final player = AudioPlayer();
  bool isPlaying = false;
  String songName = 'Nothing playing';
  IconData playButtonIcon = Icons.play_circle_filled;
  List<SongInfo> artists;
  int track = 0;
  @override
  void initState() {
    super.initState();
    // getArtist();
  }

  void getArtist() async {
    artists = await audioQuery.getSongs();
  }

  playCheck() {
    if (isPlaying) {
      playButtonIcon = Icons.pause_circle_filled;
    } else {
      playButtonIcon = Icons.play_circle_filled;
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
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.red,
              ),
              title: Text("Home")),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.music_note,
                color: Colors.red,
              ),
              title: Text("some")),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.playlist_play,
                color: Colors.red,
              ),
              title: Text("Playlist")),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.settings_input_antenna,
                color: Colors.red,
              ),
              title: Text("Explore")),
        ],
      ),
      body: SafeArea(
          child: Container(
        child: Stack(children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: _size.height * 0.7,
              child: FutureBuilder(
                future: audioQuery.getSongs(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    artists = snapshot.data;
                    return ListView.builder(
                        itemCount: artists.length,
                        itemBuilder: (context, index) {
                          print(artists[index].albumArtwork);
                          return Container(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            child: ListTile(
                              isThreeLine: true,
                              trailing: Text(
                                  ((int.parse(artists[index].duration) / 1000) /
                                          60)
                                      .toStringAsFixed(2)),
                              leading: artists[index].albumArtwork == null
                                  ? Icon(
                                      Icons.album,
                                      color: Colors.red,
                                      size: 45,
                                    )
                                  : Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              "https://d1csarkz8obe9u.cloudfront.net/posterpreviews/artistic-album-cover-design-template-d12ef0296af80b58363dc0deef077ecc_screen.jpg"),
                                        ),
                                      ),
                                    ),
                              subtitle: Text(artists[index].artist),
                              onTap: () {
                                setState(() {
                                  playButtonIcon = Icons.pause_circle_filled;
                                  track = index;
                                  songName = artists[index].displayName;
                                  player.setFilePath(artists[index].filePath);
                                  player.play();
                                });
                              },
                              title: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(artists[index].displayName)),
                            ),
                          );
                        });
                  } else {
                    return CircularProgressIndicator();
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
              height: _size.height * 0.2,
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // SeekBar(
                    //     duration: Duration(seconds: 10),
                    //     position: Duration(seconds: 20)),
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Center(
                            child: Text(
                          songName,
                          style: TextStyle(fontSize: 20),
                        ))),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            icon: Icon(
                              Icons.skip_previous,
                              size: 40,
                            ),
                            onPressed: () async {
                              if (track == 0) {
                                track = 0;
                              } else {
                                track--;
                              }
                              setState(() {
                                isPlaying = true;
                                songName = artists[track].displayName;
                              });
                              await player.setFilePath(artists[track].filePath);
                              player.play();
                            }),
                        SizedBox(
                          width: 15.0,
                        ),
                        IconButton(
                            icon: Icon(
                              playButtonIcon,
                              size: 60,
                              color: Colors.red,
                            ),
                            onPressed: () async {
                              if (player.playerState.playing) {
                                player.pause();
                                isPlaying = false;
                              } else {
                                isPlaying = true;
                                player.play();
                              }
                              await player.setFilePath(artists[track].filePath);
                              setState(() {
                                playCheck();
                                songName = artists[track].displayName;
                              });
                              
                            }),
                        SizedBox(
                          width: 15.0,
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.skip_next,
                              size: 40,
                            ),
                            onPressed: () {
                              setState(() async {
                                isPlaying = true;
                                track == artists.length ? track = 0 : track++;
                                setState(() {
                                  songName = artists[track].displayName;
                                });
                                await player
                                    .setFilePath(artists[track].filePath);

                                player.play();
                              });
                            })
                      ],
                    ),
                  ],
                ),
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
