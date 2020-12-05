import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:player/screens/home_page.dart';
import 'package:audio_service/audio_service.dart';
import 'package:player/screens/main_scaffold.dart';

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

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[0.5];
  Map swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 0; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + (ds < 0 ? r : (255 - r) * ds).round(),
        g + (ds < 0 ? g : (255 - g) * ds).round(),
        b + (ds < 0 ? b : (255 - b) * ds).round(),
        1);
  });
  return MaterialColor(color.value, swatch);
}
