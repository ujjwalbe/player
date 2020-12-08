import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'dart:io';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:just_audio/just_audio.dart';

class AppAudioService {
  final AssetsAudioPlayer player = AssetsAudioPlayer();
  final List<StreamSubscription> _subscriptions = [];
  bool isPlaying = false;

  void subs() {
    _subscriptions.add(player.playlistAudioFinished.listen((data) {
      print("playlistAudioFinished : $data");
    }));
    _subscriptions.add(player.audioSessionId.listen((sessionId) {
      print("audioSessionId : $sessionId");
    }));
    _subscriptions.add(player.currentPosition.listen((event) {
      //print("Current Position of SONG: $event");
    }));

    _subscriptions.add(player.isPlaying.listen((event) {
      isPlaying = event;
      print("Currently playing SONG: $event");
    }));

    _subscriptions.add(player.current.listen((event) {
      print("Current song DATA: ${event.audio.assetAudioPath}");
    }));

    // audioPlayer.currentIndexStream.listen((event) {
    //   print(event);
    //   print(event);
    // });
  }


  void pauseAudio() async {
    print("im called");
    try {
      print("paused");
      await player.playOrPause();
    } catch (err) {
      print("ERROR: $err");
    }
  }

  Future playAudio() async {
    await player.play();
  }

  Future<void> playNext() async {
    print("called");
    bool stat = await player.next();
    print(stat);
  }

   Future<void> playPrev() async {
    print("called");
    bool stat = await player.previous();
    print(stat);
  }

  void audioSeekTo(Duration duration) async {
    await player.seek(duration);
  }

  void audioForwardBy() async {
    print("tap tap tap");
    await player.seekBy(Duration(seconds: 10));
  }

  void audioRewindBy(Duration duration) async {
    await player.seekBy(-(duration));
  }

  void stopAudio() async {
    await player.stop();
  }

  void openAudio(List<Audio> audios) async {
    print("AUDIOS:  $audios");
    if (isPlaying) {
      bool state = await player.next();
    } else {
      try {
        await player.open(Playlist(audios: audios),
            showNotification: true,
            //playInBackground: PlayInBackground.enabled,
            audioFocusStrategy:
                AudioFocusStrategy.request(resumeAfterInterruption: true),
            headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplugPlayOnPlug);
      } catch (err) {
        print(err);
      }
    }
  }

}
