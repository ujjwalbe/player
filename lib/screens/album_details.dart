import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:io';

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
  List<SongInfo> songLists;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
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
        body: Center(
            child: FutureBuilder(
          future:
              audioQuery.getSongsFromAlbum(albumId: widget.albumId.toString()),
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
                            ((int.parse(songLists[index].duration) / 1000) / 60)
                                .toStringAsFixed(2)),
                        leading: songLists[index].albumArtwork == null
                            ? Icon(
                                Icons.album,
                                color: Colors.red,
                                size: 45,
                              )
                            : Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: FileImage(
                                        File(songLists[index].albumArtwork)),
                                  ),
                                ),
                              ),
                        subtitle: Text(songLists[index].artist),
                        onTap: () {
                          setState(() {
                            // playButtonIcon = Icons.pause;
                            // track = index;
                            // songName = songLists[index].displayName;
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
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        )),
      ),
    );
  }
}
