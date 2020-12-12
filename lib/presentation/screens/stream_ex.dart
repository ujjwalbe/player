import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class CounterPage extends StatefulWidget {
  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _counter = 0;
  final StreamController<int> _streamController =
      StreamController<int>.broadcast();

  int da;
  final AssetsAudioPlayer player = AssetsAudioPlayer();
  getDa() {
    final StreamSubscription subs = _streamController.stream.listen((event) {
      da = event;
    });
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stream version of the Counter App $da ')),
      body: Center(
        child: StreamBuilder<Duration>(
            stream: player.currentPosition,
            builder: (BuildContext context, AsyncSnapshot<Duration> snapshot) {
              getDa();
              return Text('You hit me: ${snapshot.data} times');
            }),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _streamController.sink.add(++_counter);
        },
      ),
    );
  }
}
