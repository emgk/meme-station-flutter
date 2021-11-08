// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:memestation/pages/memeslist.dart';
import 'package:memestation/pages/tabs/folders/foldersList.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentTabIndex = 0;

  final tabs = [
    MemesList(),
    FoldersList(),
    Center(child: Text("Global (to be developed...)")),
    Center(child: Text("Profile (to be developed...)")),
  ];

  @override
  void initState() {
    super.initState();
  }

  void switchTab(int tabId) {
    setState(() {
      _currentTabIndex = tabId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: false,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxScrolled) => [
          SliverAppBar(
            // systemOverlayStyle: Brightness.light,
            backgroundColor: Colors.white,
            title: Text(
              'memestation',
              style: TextStyle(
                color: Colors.orangeAccent,
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
                letterSpacing: -1.2,
              ),
            ),
          ),
        ],
        body: tabs[_currentTabIndex],
      ),
      bottomNavigationBar: BottomNavyBar(
          animationDuration: Duration(milliseconds: 300),
          onItemSelected: switchTab,
          selectedIndex: _currentTabIndex,
          items: <BottomNavyBarItem>[
            BottomNavyBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
              activeColor: Colors.orangeAccent,
              inactiveColor: Colors.grey,
            ),
            BottomNavyBarItem(
              icon: Icon(Icons.bookmark),
              title: Text('Folders'),
              activeColor: Colors.orangeAccent,
              inactiveColor: Colors.grey,
            ),
            BottomNavyBarItem(
              icon: Icon(Icons.public),
              title: Text('Explore'),
              activeColor: Colors.orangeAccent,
              inactiveColor: Colors.grey,
            ),
            BottomNavyBarItem(
              icon: Icon(Icons.person),
              title: Text('Profile'),
              activeColor: Colors.orangeAccent,
              inactiveColor: Colors.grey,
            ),
          ]),
      // bottomNavigationBar: BottomNav(
      //   switchTab: switchTab,
      //   currentTabIndex: _currentTabIndex,
      // ),
    );
  }
}

HomePage homepage = HomePage();
