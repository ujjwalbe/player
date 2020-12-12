import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:player/logic/cubit/audioplayers_cubit.dart';
import 'package:player/logic/service/audio_service.dart';
import 'package:player/presentation/widgets/player_card.dart';
import 'package:player/presentation/widgets/song_card.dart';

class PlayerScreen extends StatefulWidget {
  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();

  final AppAudioService audioService = AppAudioService();
  final AssetsAudioPlayer player = AssetsAudioPlayer();

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
          FutureBuilder(
            future: audioQuery.getSongs(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                return CircularProgressIndicator();
              }
              List<SongInfo> data = snapshot.data;
              return PlayerCard(
                albumName: "Love Aj Kal",
                artistName: "Pritam, KK",
                currentSongName: "Aur Tanha - Love Aj Kal",
                nextCallbackTap: () {
                  print("I dont know whats happending");
                  audioService.playNext();
                },
                playCallbackTap: () async {
                  List<Audio> audios = [];
                  data.forEach(
                      (element) => audios.add(Audio.file(element.filePath)));
                  // audioService.openAudio(audios);
                  BlocProvider.of<AudioplayersCubit>(context).player.open(Playlist(audios: audios));
                },
                prevCallbackTap: () {
                  audioService.playPrev();
                },
                forwardCallbackTap: () {
                  audioService.audioForwardBy();
                },
                rewindCallbackTap: () {},
                albumCallbackTap: () {},
                loopCallbackTap: () {},
                isPlaying: true,
              );
            },
          ),
        ],
      ),
    );
  }
}
