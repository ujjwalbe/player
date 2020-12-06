import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:io';

import 'package:player/widgets/mini_player.dart';

class AlbumDetails extends StatefulWidget {
  final String albumArt;
  final int albumId;
  final String albumName;
  AlbumDetails(
      {Key key,
      @required this.albumArt,
      @required this.albumId,
      @required this.albumName});
  @override
  _AlbumDetailsState createState() => _AlbumDetailsState();
}

class _AlbumDetailsState extends State<AlbumDetails> {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  final AudioPlayer player = AudioPlayer();
  int track = 0;
  List<SongInfo> songLists;
  bool isPlaying = false;
  IconData playButtonIcon = Icons.play_arrow;

  playCheck() {
    if (isPlaying) {
      playButtonIcon = Icons.pause;
    } else {
      playButtonIcon = Icons.play_arrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 250.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Text(widget.albumName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            )),
                      ),
                    ),
                    background: Image(
                      fit: BoxFit.cover,
                      image: widget.albumArt == null
                          ? AssetImage('assets/images/album_art.jpg')
                          : FileImage(File(widget.albumArt)),
                    )),
              ),
            ];
          },
          body: Container(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    child: FutureBuilder(
                      future: audioQuery.getSongsFromAlbum(
                          albumId: widget.albumId.toString()),
                      builder: (context, snapshot) {
                        print("ALBUM ID FROM WIDGET: ${widget.albumId}");
                        if (snapshot.hasData) {
                          songLists = snapshot.data;
                          //songLists.forEach((element) => print(element));
                          return ListView.builder(
                              itemCount: songLists.length,
                              itemBuilder: (context, index) {
                                //print(songLists[index].albumArtwork);
                                return Container(
                                  padding: EdgeInsets.only(top: 5, bottom: 5),
                                  child: ListTile(
                                    isThreeLine: true,
                                    trailing: Text(
                                        ((int.parse(songLists[index].duration) /
                                                    1000) /
                                                60)
                                            .toStringAsFixed(2)),
                                    leading: Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: songLists[index]
                                                      .albumArtwork ==
                                                  null
                                              ? AssetImage(
                                                  'assets/images/album_art.jpg')
                                              : FileImage(File(songLists[index]
                                                  .albumArtwork)),
                                        ),
                                      ),
                                    ),
                                    subtitle: Text(songLists[index].artist),
                                    onTap: () {
                                      print(
                                          "Song Path: ${songLists[index].filePath} SONG ID: ${songLists[index].id} SONG NAME:  ${songLists[index].displayName} ALBUM ID:  ${songLists[index].albumId}");
                                      setState(() {
                                        track = index;
                                        isPlaying = true;
                                        playCheck();
                                        // playButtonIcon = Icons.pause;
                                        // track = index;
                                        // songName = songLists[index].displayName;
                                        player.setFilePath(
                                            songLists[index].filePath);
                                        player.play();
                                      });
                                    },
                                    title: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child:
                                            Text(songLists[index].displayName)),
                                  ),
                                );
                              });
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ),
                ),
                Container(
                  child: FutureBuilder(
                    future: audioQuery.getSongsFromAlbum(
                        albumId: widget.albumId.toString()),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        songLists = snapshot.data;
                        return MiniPlayer(
                          playPress: () {
                            player.setFilePath(songLists[track].filePath);
                            player.play();
                            setState(() {
                              playCheck();
                            });
                          },
                          onPress: () {},
                          artistName: songLists[track].artist,
                          albumName: songLists[track].album,
                          currentPosition: Duration(seconds: 10),
                          songDuration: Duration(seconds: 10),
                          songName: songLists[track].displayName,
                          playIcon: playButtonIcon,
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
