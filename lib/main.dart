// ignore_for_file: use_key_in_widget_constructors, unnecessary_new, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:memestation/pages/tabs/folders/folderview.dart';
// pages
import 'pages/login.dart';
import 'pages/splash.dart';
import 'pages/homepage.dart';

void main() => runApp(new MemeStation());

class MemeStation extends StatelessWidget {
  static const String appName = "Meme Station";

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Meme Station",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey.shade200,
      ),
      home: Splash(),
      navigatorKey: navigatorKey,
      routes: {
        '/login': (_) => Login(),
        '/homepage': (_) => HomePage(),
      },
    );
  }
}
