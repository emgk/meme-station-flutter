// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:flutter_gravatar/flutter_gravatar.dart';
import 'package:memestation/entities/jsonMap.dart';
import 'package:memestation/pages/login.dart';
import 'package:memestation/services/api_service.dart';
import 'package:memestation/shared/memecard.dart';

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
    return await APIService.getMemes(params).then((memes) {
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
    if (null == _memes) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.black),
            strokeWidth: 5.0,
          ),
        ),
      );
    }

    return RefreshIndicator(
        child: Container(
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(children: <Widget>[
              Visibility(
                visible: null != _user,
                child: Container(
                  padding: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              Gravatar(_user?.email ?? 'test@example.com')
                                  .imageUrl(),
                              height: 50.0,
                              width: 50.0,
                            ),
                          ),
                          SizedBox(width: 20),
                          Column(
                            children: [
                              Text(
                                _user?.name ?? "",
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
                                // ScaffoldMessenger.of(context).showSnackBar(
                                //   SnackBar(
                                //     content: Text("Logged out successfully!"),
                                //   ),
                                // );
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
              ),
              ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: _memes!.length,
                itemBuilder: (context, index) {
                  if (null != _memes && _memes!.isNotEmpty) {
                    return MemeCard(meme: _memes![index], user: _user!);
                  }
                  return Container();
                },
              ),
            ]),
          ),
        ),
        onRefresh: () async {
          await loadMemes();
        });
  }
}
