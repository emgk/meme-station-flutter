// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gravatar/flutter_gravatar.dart';
import 'package:jiffy/jiffy.dart';
import 'package:memestation/entities/jsonMap.dart';
import 'package:memestation/services/api_service.dart';
import 'package:memestation/util/actionbuttons.dart';
import 'package:memestation/util/share.dart';

class MemeCard extends StatefulWidget {
  final Meme meme;
  final User user;

  MemeCard({
    Key? key,
    required this.meme,
    required this.user,
  }) : super(key: key);

  @override
  _MemeCardState createState() => _MemeCardState();
}

class _MemeCardState extends State<MemeCard> {
  bool saved = false;
  bool liked = false;
  bool showBookmartOverlay = false;
  bool _isLocked = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      saved = widget.meme.isSaved!;
    });

    setState(() {
      liked = widget.meme.isLiked!;
    });
  }

  Future _toggleSave(folderId) async {
    // payload
    Map<String, dynamic> data = {
      'userId': widget.user.id,
      'memeId': widget.meme.id,
      'folderId': folderId,
    };

    if (_isLocked) {
      return;
    }

    setState(() => {_isLocked = true});

    await ('' == folderId
            ? APIService.unSaveMeme(data)
            : APIService.saveMeme(data))
        .then((response) {
      if (response!.statusCode == 200) {
        setState(() {
          saved = !saved;
          _isLocked = false;
        });
      }
    }).catchError((e) {
      setState(() {
        _isLocked = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed, please try again!'),
        ),
      );
    });
  }

  Future _toggleLike() async {
    // payload
    Map<String, dynamic> data = {
      'userId': widget.user.id,
      'memeId': widget.meme.id,
    };

    if (_isLocked) {
      return;
    }

    setState(() => {_isLocked = true});

    await (liked ? APIService.unLikeMeme(data) : APIService.likeMeme(data))
        .then((response) {
      if (response!.statusCode == 200) {
        setState(() {
          showBookmartOverlay = true;
          liked = !liked;
          _isLocked = false;
          if (showBookmartOverlay) {
            Timer(const Duration(milliseconds: 500), () {
              setState(() {
                showBookmartOverlay = false;
              });
            });
          }
        });
      }
    }).catchError((e) {
      setState(() => {_isLocked = false});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed, please try again!'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext build) {
    return Container(
      margin: const EdgeInsets.only(
        left: 15,
        right: 15,
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
            visible: "" != widget.meme.description.toString(),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                widget.meme.description.toString(),
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
                bottom: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
              ),
            ),
            child: GestureDetector(
              onDoubleTap: () {
                _toggleLike();
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  FittedBox(
                    fit: BoxFit.fill,
                    child: Image.network(
                      widget.meme.imageUrl.toString(),
                    ),
                  ),
                  showBookmartOverlay
                      ? Icon(
                          liked ? EvaIcons.heart : EvaIcons.heartOutline,
                          color: Colors.white,
                          size: 80.0,
                        )
                      : Container(),
                ],
              ),
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
                      child: Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            Gravatar(
                              widget.meme.user![0].email ?? '',
                            ).imageUrl(),
                            height: 50.0,
                            width: 50.0,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.meme.user![0].name ?? '',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          (Jiffy(widget.meme.user![0].createdAt).fromNow()),
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
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
                          widget.meme.imageUrl.toString(),
                          widget.meme.description.toString(),
                        )
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        saved
                            ? Icons.bookmark
                            : Icons.bookmark_outline_outlined,
                        color: saved ? Colors.blue : Colors.black,
                      ),
                      onPressed: () {
                        if (!saved) {
                          folderPicker(context, widget.user.folders, (data) {
                            _toggleSave(data.id);
                          });
                        } else {
                          _toggleSave('');
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        liked ? EvaIcons.heart : EvaIcons.heartOutline,
                        color: liked ? Colors.red : Colors.black,
                      ),
                      onPressed: () {
                        _toggleLike();
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
