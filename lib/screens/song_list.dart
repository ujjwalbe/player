
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:just_audio/just_audio.dart';

class ShowSongList extends StatefulWidget {
  @override
  _ShowSongListState createState() => _ShowSongListState();
}

class _ShowSongListState extends State<ShowSongList> {
  bool isPlaying = false;
  String songName = 'Nothing playing';
  IconData playButtonIcon = Icons.play_arrow;
  final AudioPlayer player = AudioPlayer();
  int track = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
                      child: FutureBuilder(
                future: FlutterAudioQuery().getSongs(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<SongInfo> songLists = snapshot.data;

                    return ListView.builder(
                      itemCount: songLists.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          child: ListTile(
                            isThreeLine: true,
                            trailing: Text(
                                ((int.parse(songLists[index].duration) / 1000) / 60)
                                    .toStringAsFixed(2)),
                            leading: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: songLists[index].albumArtwork == null
                                      ? AssetImage('assets/images/album_art.jpg')
                                      : FileImage(
                                          File(songLists[index].albumArtwork)),
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
                      },
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
          ),
          SizedBox(height: 83.0,)
        ],
      ),
    );
  }
}
