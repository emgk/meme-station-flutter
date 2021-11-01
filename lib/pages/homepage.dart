// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:memestation/entities/jsonMap.dart';
import 'package:memestation/main.dart';
import 'package:memestation/pages/login.dart';
import 'package:memestation/pages/memeslist.dart';
import 'package:memestation/pages/postmeme.dart';
import 'package:memestation/services/api_service.dart';
import 'package:memestation/pages/bottomnav.dart';
import 'package:flutter_gravatar/flutter_gravatar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class BottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  CustomPaint(
                    size: Size(MediaQuery.of(context).size.width, 80),
                    painter: BottomCustomPainer(),
                  ),
                  Center(
                    heightFactor: 0.6,
                    child: FloatingActionButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => PostMeme()),
                        );
                      },
                      backgroundColor: Colors.black,
                      child: Icon(
                        Icons.upload,
                      ),
                      elevation: 10,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(Icons.home, color: Colors.white),
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (_) => HomePage()),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.bookmark, color: Colors.white),
                          onPressed: () {},
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.20,
                        ),
                        IconButton(
                          icon: Icon(Icons.public, color: Colors.white),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(Icons.person, color: Colors.white),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _HomePageState extends State<HomePage> {
  User? _user;

  @override
  void initState() {
    super.initState();

    loadMemes().whenComplete(() {
      setState(() {});
    });
  }

  Future loadMemes() async {
    return await APIService.getLoggedUser().then((user) {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        // centerTitle: true,
        // leading: IconButton(
        //   icon: Icon(Icons.menu, color: Colors.black),
        //   onPressed: () => {},
        // ),
        title: Text(
          MemeStation.appName,
          style: TextStyle(
            color: Colors.black,
          ),
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
        backgroundColor: Colors.transparent,
        // flexibleSpace: Container(
        //   decoration: BoxDecoration(
        //     gradient: LinearGradient(
        //       colors: [Colors.black45, Colors.transparent],
        //       begin: Alignment.topCenter,
        //       end: Alignment.bottomCenter,
        //     ),
        //   ),
        // ),
        elevation: 0,
        // titleSpacing: 0,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        null == _user?.email
                            ? SizedBox(width: 20)
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  Gravatar(_user?.email ?? '').imageUrl(),
                                  height: 50.0,
                                  width: 50.0,
                                ),
                              ),
                        SizedBox(width: 20),
                        Column(
                          children: [
                            Text(
                              _user?.name ?? "fdsfsdf",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.settings),
                          onPressed: () => {},
                        ),
                        IconButton(
                          icon: Icon(Icons.logout),
                          onPressed: () async {
                            await APIService.logout(() {
                              // show alert
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Logged out successfully!"),
                                ),
                              );

                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (_) => Login()),
                              );
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                margin: const EdgeInsets.only(
                  left: 5,
                  right: 5,
                  top: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
              ),
              MemesList(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(),
    );
  }
}

HomePage homepage = HomePage();
