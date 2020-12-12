import 'package:flutter/material.dart';
import 'package:player/presentation/screens/now_playing.dart';
import 'package:player/utils/constants.dart';
import 'gesture_icon_button.dart';

class PlayerCard extends StatefulWidget {
  final VoidCallback shuffleCallbackTap;
  final VoidCallback rewindCallbackTap;
  final VoidCallback forwardCallbackTap;
  final VoidCallback prevCallbackTap;
  final VoidCallback playCallbackTap;
  final VoidCallback nextCallbackTap;
  final VoidCallback loopCallbackTap;
  final VoidCallback albumCallbackTap;
  final String currentSongName;
  final String albumName;
  final String artistName;
  final bool isPlaying;

  PlayerCard({
    Key key,
    @required this.artistName,
    this.albumCallbackTap,
    @required this.albumName,
    @required this.currentSongName,
    @required this.nextCallbackTap,
    @required this.playCallbackTap,
    @required this.prevCallbackTap,
    @required this.isPlaying,
    this.forwardCallbackTap,
    this.loopCallbackTap,
    this.rewindCallbackTap,
    this.shuffleCallbackTap,
  })  : assert(albumName != null),
        assert(currentSongName != null),
        assert(nextCallbackTap != null),
        assert(playCallbackTap != null),
        assert(isPlaying != null),
        assert(prevCallbackTap != null);

  @override
  _PlayerCardState createState() => _PlayerCardState();
}

class _PlayerCardState extends State<PlayerCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        
        children: [
          Container(
            child: Center(
              child: Text(
                widget.currentSongName,
                style: TextStyle(fontSize: 25),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Center(
            child: Container(
              width: 150,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.artistName,
                      style: TextStyle(fontSize: 18, color: kDarkGrey),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: Center(
              child: SeekBar(duration: Duration(seconds: 90), position: Duration(seconds: 20)),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            padding: EdgeInsets.only(bottom: 80.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureIconButton(
                    color: kGreyText,
                    icon: Icons.repeat,
                    onTap: widget.loopCallbackTap),
                GestureIconButton(
                  color: kDarkGrey,
                  icon: Icons.fast_rewind,
                  onTap: widget.rewindCallbackTap,
                ),
                GestureIconButton(
                  size: 35,
                  icon: Icons.skip_previous,
                  onTap: widget.prevCallbackTap,
                ),
                GestureIconButton(
                  color: kPrimaryColor,
                  size: 65.0,
                  icon: widget.isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_filled,
                  onTap: widget.playCallbackTap,
                ),
                GestureIconButton(
                  size: 35,
                  icon: Icons.skip_next,
                  onTap: widget.nextCallbackTap,
                ),
                GestureIconButton(
                  color: kDarkGrey,
                  icon: Icons.fast_forward,
                  onTap: widget.forwardCallbackTap,
                ),
                GestureIconButton(
                  color: kGreyText,
                  icon: Icons.shuffle,
                  onTap: widget.shuffleCallbackTap,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
