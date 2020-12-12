part of 'audioplayers_cubit.dart';

@immutable
abstract class AudioplayersState {}

class AudioplayersInitial extends AudioplayersState {}

class AudioPlayerCurrentPosition extends AudioplayersState {
  final Duration duration;
  AudioPlayerCurrentPosition({this.duration});
}

class AudioPlayersIsPlaying extends AudioplayersState {
  final bool isPlaying;
  AudioPlayersIsPlaying({this.isPlaying});
}

class AudioPlayersCurrentSong extends AudioplayersState {
  final String songName;
  AudioPlayersCurrentSong({this.songName});
}
