import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:player/screens/home_page.dart';
import 'package:audio_service/audio_service.dart';
import 'package:player/screens/main_scaffold.dart';
import 'package:player/utils/generate_mat_colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

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
      home: AudioServiceWidget(child: MainScaffold()),
    );
  }
}


