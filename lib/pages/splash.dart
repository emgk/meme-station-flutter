// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:memestation/pages/homepage.dart';
import 'package:memestation/services/api_service.dart';

import 'login.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();

    getCurrentUser().whenComplete(() {
      setState(() {});
    });
  }

  Future getCurrentUser() async {
    return await APIService.getLoggedUser().then((user) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomePage()),
      );
    }).catchError((err) {
      // Redirect to login if failed
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => Login()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/default-monochrome-white.svg',
              height: 50,
              width: 10,
            ),
            SizedBox(height: 10),
            Text(
              'is starting...',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 100),
            CircularProgressIndicator.adaptive(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey),
            )
          ],
        ),
      ),
    );
  }
}

Splash splash = Splash();
