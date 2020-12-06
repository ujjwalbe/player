import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:player/widgets/player_card.dart';
import 'package:player/widgets/song_card.dart';

class PlayerScreen extends StatefulWidget {
  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Container(
      child: Column(
        children: [
          Expanded(
            child: Container(
              //height: _size.height * 0.75,
              child: FutureBuilder(
                future: audioQuery.getSongs(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<SongInfo> songLists = snapshot.data;
                    return ListView.builder(
                        //gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
                        scrollDirection: Axis.horizontal,
                        itemCount: songLists.length,
                        itemBuilder: (context, index) {
                          print(songLists[index].albumArtwork);
                          return SongCard(
                              albumArt: songLists[index].albumArtwork,
                              //songTitle: songLists[index].displayName,
                              favorite: true,
                              onPress: () {},
                              onPlay: () {});
                        });
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ),
          PlayerCard(
            albumName: "Love Aj Kal",
            artistName: "Pritam, KK",
            currentSongName: "Aur Tanha - Love Aj Kal",
            nextCallbackTap: () {},
            playCallbackTap: () {},
            prevCallbackTap: () {},
            forwardCallbackTap: (){},
            rewindCallbackTap: (){},
            albumCallbackTap: (){},
            loopCallbackTap: (){},

            isPlaying: true,
          ),
        ],
      ),
    );
  }
}
