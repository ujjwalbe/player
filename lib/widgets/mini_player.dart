import 'package:flutter/material.dart';
import 'dart:io';

import 'package:player/utils/constants.dart';

class MiniPlayer extends StatefulWidget {
  final VoidCallback playPress;
  final VoidCallback onPress;
  final String albumArt;
  final String songName;
  final String artistName;
  final String albumName;
  final Duration songDuration;
  final Duration currentPosition;
  final IconData playIcon;
  MiniPlayer(
      {Key key,
      @required this.playPress,
      @required this.onPress,
      this.albumArt =
          "/storage/emulated/0/Android/data/com.android.providers.media/albumthumbs/1607176590792",
      @required this.artistName,
      @required this.albumName,
      @required this.currentPosition,
      @required this.songDuration,
      @required this.songName,
      this.playIcon
      });
  @override
  _MiniPlayerState createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  @override
  Widget build(BuildContext context) {
    return Container(

      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 70,
            width: 70,
            margin:  EdgeInsets.only(left: 6.0, right: 10.0, top: 2.0, bottom: 2.0),
            child: GestureDetector(
              onTap: widget.onPress,
              child:  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: widget.albumArt == null ? AssetImage('assets/images/album_art.jpg') : FileImage(File(widget.albumArt)),
                        ),
                      ),
                    ),
            ),
          ),
          GestureDetector(
            onTap: widget.onPress,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(widget.songName, style: TextStyle(fontSize: 16.0, ),)),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.55,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(widget.artistName, style: TextStyle(color: Colors.black38),)),
                ),

                // Row(
                //   children: [
                //     SingleChildScrollView(child: Text(widget.albumName)),
                //   ],
                // ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(8.0),
            child: Center(
              child: GestureDetector(
                child: Icon(widget.playIcon, size: 45,),
                onTap: widget.playPress,
              ),
            ),
          )
        ],
      ),
    );
  }
}
