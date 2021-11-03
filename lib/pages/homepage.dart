// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:memestation/pages/memeslist.dart';
import 'package:memestation/pages/tabs/folders/foldersList.dart';
import 'package:memestation/util/bottom_nav.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentTabIndex = 0;

  final tabs = [
    MemesList(),
    FoldersList(),
    Center(child: Text("Global")),
    Center(child: Text("Profile")),
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
      appBar: AppBar(
        // centerTitle: true,
        // leading: IconButton(
        //   icon: Icon(Icons.menu, color: Colors.black),
        //   onPressed: () => {},
        // ),
        title: Padding(
          padding: EdgeInsets.all(0),
          child: Text('Meme Station', style: TextStyle(color: Colors.black)),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () => {},
          ),
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () => {},
          )
        ],
        backgroundColor: Colors.grey.shade100,
        // flexibleSpace: Container(
        //   decoration: BoxDecoration(
        //     gradient: LinearGradient(
        //       colors: [
        //         Colors.grey.shade300,
        //         Colors.white,
        //       ],
        //       begin: Alignment.topCenter,
        //       end: Alignment.bottomCenter,
        //     ),
        //   ),
        // ),
        elevation: 1,
        // titleSpacing: 0,
      ),
      body: tabs[_currentTabIndex],
      bottomNavigationBar: BottomNav(
        switchTab: switchTab,
        currentTabIndex: _currentTabIndex,
      ),
    );
  }
}

HomePage homepage = HomePage();
