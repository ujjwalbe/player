import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:player/utils/constants.dart';
import 'package:player/screens/home_page.dart';
import 'package:player/screens/now_playing.dart';
import 'package:player/screens/playlist_page.dart';

class MainScaffold extends StatefulWidget {
  @override
  _MainScaffoldState createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;
  PageController _pageController;
  String appBarTitle = "Play Music";

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        leading: IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
        title: Text(appBarTitle),
        actions: [IconButton(icon: Icon(Icons.search), onPressed: () {})],
      ),
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              if (index == 0) {
                appBarTitle = 'Play Music';
              } else if (index == 1) {
                appBarTitle = 'Now Playing';
              } else if (index == 2) {
                appBarTitle = 'Playlist';
              } else if (index == 3) {
                appBarTitle = 'Settings';
              }
              _currentIndex = index;
            });
          },
          children: <Widget>[
            PlayerHome(),
            NowPlaying(),
            SimpleExample(),
            Container(
              color: Colors.blue,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        backgroundColor: Colors.deepOrange,
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
              inactiveColor: Colors.white,
              activeColor: Colors.white,
              title: Text('Home'),
              icon: Icon(Icons.home)),
          BottomNavyBarItem(
              inactiveColor: Colors.white,
              activeColor: Colors.white,
              title: Text('Now Playing'),
              icon: Icon(Icons.music_note)),
          BottomNavyBarItem(
              inactiveColor: Colors.white,
              activeColor: Colors.white,
              title: Text('Playlist'),
              icon: Icon(Icons.playlist_play)),
          BottomNavyBarItem(
              inactiveColor: Colors.white,
              activeColor: Colors.white,
              title: Text('Item Four'),
              icon: Icon(Icons.settings)),
        ],
      ),
    );
  }
}
