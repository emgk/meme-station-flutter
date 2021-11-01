// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:flutter_gravatar/flutter_gravatar.dart';
import 'package:memestation/entities/jsonMap.dart';
import 'package:memestation/services/api_service.dart';
import 'package:memestation/util/share.dart';

class MemesList extends StatefulWidget {
  @override
  _MemesListState createState() => _MemesListState();
}

class _MemesListState extends State<MemesList> {
  List<Meme>? _memes;

  Map<String, dynamic> params = {};

  @override
  void initState() {
    super.initState();

    loadMemes().whenComplete(() {
      setState(() {});
    });
  }

  static GlobalKey _globalKey = GlobalKey();

  Future loadMemes() async {
    return await APIService.getMemes(params).then((memes) {
      _memes = memes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return null == _memes
        ? Center(
            child: Positioned(
              top: MediaQuery.of(context).size.height * 0.5,
              bottom: MediaQuery.of(context).size.height * 0.5,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.blue),
                strokeWidth: 5.0,
              ),
            ),
          )
        : ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: _memes!.length,
            itemBuilder: (context, index) {
              return Container(
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: "" != _memes![index].description.toString(),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          _memes![index].description.toString(),
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.fill,
                      child: Image.network(
                        _memes![index].imageUrl.toString(),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        top: 15,
                        bottom: 15,
                        left: 5,
                        right: 5,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  Gravatar('unavailable2010@gmail.com')
                                      .imageUrl(),
                                  height: 50.0,
                                  width: 50.0,
                                ),
                              ),
                              Column(
                                children: [
                                  Text("Govind Kumar"),
                                  Text("2 minutes ago"),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.share),
                                onPressed: () => {
                                  ShareAPI.share(
                                    _memes![index].imageUrl.toString(),
                                    _memes![index].description.toString(),
                                  )
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.download),
                                onPressed: () => {
                                  ShareAPI.share(
                                    _memes![index].imageUrl.toString(),
                                    _memes![index].description.toString(),
                                  )
                                },
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
  }
}
