import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

part 'audioplayers_state.dart';

class AudioplayersCubit extends Cubit<AudioplayersState> {
  AudioplayersCubit(this.player) : super(AudioplayersInitial());
  AssetsAudioPlayer player = AssetsAudioPlayer();

  StreamSubscription audioPlayerDurationStreamSubcription;
  StreamSubscription audioPlayerIsPlayingStreamSubcription;

  // StreamSubscription<Duration> monitorAudioPlayerDuration() {
  //   return audioPlayerDurationStreamSubcription =
  //       player.currentPosition.listen((event) {
  //     emit(AudioPlayerCurrentPosition(duration: event));
  //   });
  // }

  // StreamSubscription<bool> monitorAudioPlayerIsPlaying() {
  //   return audioPlayerIsPlayingStreamSubcription =
  //       player.isPlaying.listen((event) {
  //     emit(AudioPlayersIsPlaying(isPlaying: event));
  //   });
  // }

  playAudios(List<Audio> audios) async {
    try {
      await player.open(Playlist(audios: audios));
      await player.play();
    } catch (err) {
      print("Player Message: $err");
    }
  }

  playOrPause() async {
    await player.playOrPause();
  }

  playNext() async {
    bool stat = await player.next();
    print("Playing Next ?: $stat");
  }

  void playPrevious() async {
    bool stat = await player.previous();
    print("Playing Previous: $stat");
  }

  @override
  Future<void> close() {
    audioPlayerDurationStreamSubcription.cancel();
    audioPlayerIsPlayingStreamSubcription.cancel();
    return super.close();
  }
}
