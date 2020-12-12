import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:player/utils/constants.dart';

class AlbumCard extends StatelessWidget {
  final String albumArt;
  final String albumTitle;
  final bool favorite;
  final String genere;
  final int numberOfSong;
  final VoidCallback onPress;
  final VoidCallback onPlay;

  AlbumCard(
      {Key key,
      @required this.albumArt,
      @required this.albumTitle,
      @required this.favorite,
      @required this.onPress,
      @required this.onPlay,
      this.genere,
      @required this.numberOfSong});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onPress,
              child: Stack(children: [
          Container(
            padding: EdgeInsets.all(8.0),
            //margin: EdgeInsets.all(8.0),
            height: 200,
            width: 300,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    //colorFilter: ColorFilter.mode(Colors.grey, BlendMode.multiply),
                    image: albumArt == null
                        ? AssetImage('assets/images/album_art.jpg')
                        : FileImage(File(albumArt)))),
          ),
          Container(
            height: 200,
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.favorite,
                      color: favorite ? Colors.red : Colors.white,
                    )
                  ],
                ),
                ClipRect(
                  clipBehavior: Clip.hardEdge,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SingleChildScrollView(
                            child: Text(
                              albumTitle,
                              style: kAlbumTextStyle,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'Genere',
                                style: TextStyle(color: Colors.white),
                              ),
                              Container(
                                width: 30,
                                height: 15,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: Center(
                                  child: Text(
                                    "+${numberOfSong.toString()}",
                                    style: TextStyle(color: kBlackPrimary),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: onPlay,
                                child: Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
