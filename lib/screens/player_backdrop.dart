import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:player/widgets/backdrop.dart';
import 'package:audio_session/audio_session.dart';
import 'package:player/utils/constants.dart';
import 'package:player/screens/player_screen.dart';
import 'package:player/screens/song_list.dart';
import 'package:player/widgets/backdrop.dart';
import 'package:player/widgets/front_panel_toolbar.dart';
import 'package:player/widgets/mini_player.dart';
import 'package:player/widgets/song_card.dart';

class PlayerWithBackdrop extends StatefulWidget {
  final SongInfo currentSongInfo;
  final String currentSongName;
  final String artistName;
  final VoidCallback playPress;
  final bool isPlaying;

  PlayerWithBackdrop(
      {Key key,
      this.artistName,
      this.currentSongInfo,
      this.currentSongName,
      this.isPlaying,
      this.playPress});
  @override
  _PlayerWithBackdropState createState() => _PlayerWithBackdropState();
}

class _PlayerWithBackdropState extends State<PlayerWithBackdrop> {
  final frontPanelVisible = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    print("FRONT PANEL VISIBLE: ${frontPanelVisible.value}");
    return Backdrop(
      frontLayer: PlayerScreen(),
      backLayer: ShowSongList(),
      frontHeader: MiniPlayer(
        playPress: () {},
        onPress: () {},
        artistName: widget.artistName,
        albumName: "album Name",
        currentPosition: Duration(seconds: 20),
        songDuration: Duration(seconds: 10),
        songName: widget.currentSongName,
        playIcon: Icons.play_circle_filled,
      ),
      panelVisible: frontPanelVisible,
      frontPanelOpenHeight: 40.0,
      frontHeaderHeight: 48.0,
      frontHeaderVisibleClosed: true,
      frontPanelToolbar: ToolBar(),
    );
  }
}
