// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:flutter_gravatar/flutter_gravatar.dart';
import 'package:memestation/entities/jsonMap.dart';
import 'package:memestation/pages/login.dart';
import 'package:memestation/pages/postmeme.dart';
import 'package:memestation/services/api_service.dart';
import 'package:memestation/shared/loader.dart';
import 'package:memestation/shared/memecard.dart';
import 'package:memestation/shared/slideup.dart';

class MemesList extends StatefulWidget {
  @override
  _MemesListState createState() => _MemesListState();
}

class _MemesListState extends State<MemesList> {
  User? _user;
  List<Meme>? _memes;

  Map<String, dynamic> params = {};

  late GlobalKey<RefreshIndicatorState> refreshKey;

  @override
  void initState() {
    super.initState();

    refreshKey = GlobalKey<RefreshIndicatorState>();

    loadMemes().whenComplete(() {
      setState(() {});
    });

    getCurrentUser().whenComplete(() {
      setState(() {});
    });
  }

  static GlobalKey _globalKey = GlobalKey();

  Future loadMemes() async {
    return await APIService.getMemes().then((memes) {
      setState(() {
        _memes = memes;
      });
    });
  }

  Future getCurrentUser() async {
    return await APIService.getLoggedUser().then((user) {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: Container(
        child: SingleChildScrollView(
          child: FutureBuilder<List<dynamic>>(
            future: Future.wait([
              APIService.getMemes(),
              APIService.getLoggedUser(),
              APIService.getFolders(),
            ]),
            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Text('Press button to start');
                case ConnectionState.waiting:
                  return screenLoader(context);
                default:
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(
                            top: 5,
                            bottom: 5,
                            left: 15,
                            right: 15,
                          ),
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      Gravatar(snapshot.data![1]?.email)
                                          .imageUrl(),
                                      height: 30.0,
                                      width: 30.0,
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Column(
                                    children: [
                                      Text(
                                        snapshot.data![1]?.name,
                                        style: TextStyle(
                                          fontSize: 15,
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
                                  SlideUp(
                                    title: 'Post a meme',
                                    description: 'Please enter details below',
                                    child: PostMeme(),
                                    trigger: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.upload_rounded,
                                          size: 20,
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  IconButton(
                                    icon: Icon(
                                      Icons.logout,
                                      size: 20,
                                    ),
                                    onPressed: () async {
                                      await APIService.logout(() {
                                        // show alert
                                        // ScaffoldMessenger.of(context).showSnackBar(
                                        //   SnackBar(
                                        //     content: Text("Logged out successfully!"),
                                        //   ),
                                        // );
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (_) => Login()),
                                        );
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          margin: const EdgeInsets.only(
                            left: 15,
                            right: 15,
                            top: 15,
                            bottom: 0,
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
                                spreadRadius: 1,
                                blurRadius: 20,
                                offset:
                                    Offset(0, 1), // changes position of shadow
                              ),
                            ],
                          ),
                        ),
                        ListView.builder(
                          padding: EdgeInsets.only(top: 15),
                          primary: false,
                          shrinkWrap: true,
                          itemCount: _memes!.length,
                          itemBuilder: (context, index) {
                            return MemeCard(
                              meme: snapshot.data![0][index],
                              user: snapshot.data![1],
                              folders: snapshot.data![2],
                            );
                          },
                        )
                      ],
                    );
                  }
              }
            },
          ),
        ),
      ),
      onRefresh: () async {
        await loadMemes();
      },
    );
  }
}
