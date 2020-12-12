import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:player/logic/cubit/audioplayers_cubit.dart';
import 'package:player/presentation/screens/main_scaffold.dart';
import 'package:player/utils/generate_mat_colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  AssetsAudioPlayer audioPlayer;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xfff81e06),
    ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: createMaterialColor(Color(0xfff81e06)),
        secondaryHeaderColor: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BlocProvider(
        create: (context) => AudioplayersCubit(audioPlayer),
        child: MainScaffold(),
      ),
    );
  }
}
