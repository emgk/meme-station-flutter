// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memestation/entities/jsonMap.dart';
import 'package:memestation/services/api_service.dart';
import 'package:memestation/util/actionbuttons.dart';

class PostMeme extends StatefulWidget {
  @override
  _PostMemeState createState() => _PostMemeState();
}

class _PostMemeState extends State<PostMeme> {
  User? user;
  Folder? selecteFolder;
  String? _description = '';
  String? _tags = '';
  String? _privacy = 'public';
  File? image;
  bool _isSubmitting = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    getCurrentUser().whenComplete(() {
      setState(() {});
    });
  }

  // image picker
  Future pickImage() async {
    try {
      final pic = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pic == null) return;

      setState(() {
        image = File(pic.path);
      });
    } on PlatformException catch (e) {
      print('Failed to pick an image: $e');
    }
  }

  Future getCurrentUser() async {
    return await APIService.getLoggedUser().then((userdata) {
      user = userdata;
    });
  }

  Future addPost() async {
    setState(() {
      _isSubmitting = true;
    });

    if (null == image) {
      // no image selected
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("No image selected"),
      ));
      return;
    }

    // validation failed
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please enter values in required format."),
        ),
      );
      return;
    }

    _formKey.currentState!.save();

    Map<String, dynamic> output = {
      'title': 'FAKE TITLE',
      'description': _description,
      'tags': _tags,
      'folderId': selecteFolder!.id,
      'userId': user!.id,
      'privacy': _privacy,
    };

    // API request
    await APIService.postMeme(output, image).then((response) {
      if (response!.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Meme successfully posted!"),
          ),
        );
      }

      image = null;
      selecteFolder = null;
      _formKey.currentState!.reset();
      Navigator.of(context).pop();

      setState(() {
        _isSubmitting = false;
      });
    }).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Something went wrong, please try again!'),
        ),
      );

      image = null;
      selecteFolder = null;
      _formKey.currentState!.reset();
      Navigator.of(context).pop();

      setState(() {
        _isSubmitting = false;
      });
    });
  }

  Widget _buildDescription() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Description",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white54,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.1),
                  offset: Offset(0, 0),
                  blurRadius: 4.0,
                  spreadRadius: 2.0,
                ),
                BoxShadow(
                  color: Color.fromRGBO(255, 255, 255, 0.9),
                  offset: Offset(0, 0),
                  blurRadius: 4.0,
                  spreadRadius: 2.0,
                )
              ],
            ),
            child: TextFormField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(20),
                border: InputBorder.none,
                hintText: 'Enter short description...',
              ),
              maxLines: 4,
              keyboardType: TextInputType.multiline,
              validator: (value) {
                if (null == value) {
                  return 'Description is required';
                }
              },
              onSaved: (value) {
                if (null != value) {
                  _description = value;
                }
              },
            ),
          ),
        ]);
  }

  Widget _buildTags() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tags",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white54,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.1),
                  offset: Offset(0, 0),
                  blurRadius: 4.0,
                  spreadRadius: 2.0,
                ),
                BoxShadow(
                  color: Color.fromRGBO(255, 255, 255, 0.9),
                  offset: Offset(0, 0),
                  blurRadius: 4.0,
                  spreadRadius: 2.0,
                )
              ],
            ),
            child: TextFormField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 20),
                border: InputBorder.none,
                hintText: 'Enter tags by seperated by comma',
              ),
              keyboardType: TextInputType.multiline,
              validator: (value) {},
              onSaved: (value) {
                if (null != value) {
                  _tags = value;
                }
              },
            ),
          ),
        ]);
  }

  Widget _selectFolder() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Folder",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.only(
              top: 10,
              bottom: 10,
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
            child: Row(
              children: null == selecteFolder
                  ? [
                      InkWell(
                        child: Container(
                          width: MediaQuery.of(context).size.width - 40,
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
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.folder,
                                size: 30.0,
                                color: Colors.grey,
                              ),
                              SizedBox(width: 10),
                              Text("Please select folder"),
                            ],
                          ),
                        ),
                        onTap: () {
                          if (null != user) {
                            folderPicker(context, user!.folders, (data) {
                              setState(() {
                                selecteFolder = data;
                              });
                            });
                          }
                        },
                      ),
                    ]
                  : [
                      InkWell(
                        onTap: () {
                          if (null != user) {
                            folderPicker(context, user!.folders, (data) {
                              setState(() {
                                selecteFolder = data;
                              });
                            });
                          }
                        },
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(
                                right: 20,
                              ),
                              alignment: Alignment.center,
                              height: 80,
                              child: Container(
                                width: 80,
                                height: 80,
                                child: Icon(
                                  Icons.image,
                                  color: Colors.black54,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  selecteFolder!.title,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  selecteFolder!.description,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
            ),
          ),
        ]);
  }

  Widget _buildPrivacy() {
    return Row(
      children: [
        Row(children: [
          Radio<String>(
            fillColor:
                MaterialStateColor.resolveWith((states) => Colors.orangeAccent),
            value: 'public',
            groupValue: _privacy,
            onChanged: (privacy) {
              setState(() {
                _privacy = privacy;
              });
            },
          ),
          Text("Public"),
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Radio<String>(
            fillColor:
                MaterialStateColor.resolveWith((states) => Colors.orangeAccent),
            value: 'private',
            groupValue: _privacy,
            onChanged: (privacy) {
              setState(() {
                _privacy = privacy;
              });
            },
          ),
          Text("Private"),
        ]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      heightFactor: 0.6,
      child: FloatingActionButton(
        onPressed: () {
          addPopup(context);
        },
        backgroundColor: Colors.white,
        child: Icon(
          Icons.upload_rounded,
          color: Colors.grey,
        ),
        elevation: 5,
      ),
    );
  }

  addPopup(context) {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isDismissible: true,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: DraggableScrollableSheet(
              initialChildSize: 0.9, //set this as you want
              maxChildSize: 1.0, //set this as you want
              minChildSize: 0.75, //set this as you want
              expand: true,
              builder: (context, scrollController) {
                return Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Post a meme",
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "Please enter details below",
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                onPressed: () {
                                  image = null;
                                  _formKey.currentState!.reset();
                                  selecteFolder = null;
                                  Navigator.of(context).pop();
                                },
                                icon: Icon(
                                  Icons.close_sharp,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          SizedBox(
                            child: InkWell(
                              child: Container(
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
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.all(24),
                                child: image != null
                                    ? Image.file(image!,
                                        width: 160, height: 160)
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text("Please select image"),
                                          SizedBox(height: 18),
                                          Icon(
                                            Icons.image,
                                            size: 50.0,
                                            color: Colors.grey,
                                          )
                                        ],
                                      ),
                              ),
                              onTap: () => pickImage(),
                            ),
                            width: MediaQuery.of(context).size.width,
                            height: 200,
                          ),
                          SizedBox(height: 20),
                          _buildDescription(),
                          SizedBox(height: 20),
                          _selectFolder(),
                          SizedBox(height: 20),
                          _buildTags(),
                          // _buildFolderId(),
                          SizedBox(height: 20),
                          _buildPrivacy(),
                          SizedBox(height: 20),
                          InkWell(
                            onTap: () => addPost(),
                            child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.only(
                                left: 30,
                                right: 30,
                                top: 10,
                                bottom: 10,
                              ),
                              child: Text(
                                'Post',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: _isSubmitting
                                    ? Colors.grey[350]
                                    : Colors.orangeAccent,
                                borderRadius: BorderRadius.circular(100),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.orangeAccent,
                                    offset: Offset(6, 2),
                                    blurRadius: 2.0,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ));
      },
    );
  }
}

PostMeme postMeme = PostMeme();
