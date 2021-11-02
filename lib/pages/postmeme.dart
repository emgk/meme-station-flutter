// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memestation/pages/homepage.dart';
import 'package:memestation/services/api_service.dart';
import 'package:memestation/util/notice.dart';

class PostMeme extends StatefulWidget {
  @override
  _PostMemeState createState() => _PostMemeState();
}

class _PostMemeState extends State<PostMeme> {
  String? _description = '';
  String? _tags = '';
  String? _privacy = 'public';
  int _folderId = 1;
  int _userId = 1;
  File? image;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
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

  Future addPost() async {
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

    await APIService.getLoggedUser().then((user) async {
      Map<String, dynamic> output = {
        'title': 'Test title',
        'description': _description,
        'tags': _tags,
        'folderId': _folderId,
        'userId': user.id,
        // 'privacy': _privacy,
      };

      // API request
      await APIService.postMeme(output, image).then((response) {
        if (response!.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Meme successfully posted!"),
            ),
          );

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => HomePage()),
          );
        }
      }).catchError((e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Something went wrong, please try again!'),
          ),
        );
      });
    });
  }

  Widget _buildDescription() {
    return TextFormField(
      maxLines: 4,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(labelText: 'Description'),
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
    );
  }

  Widget _buildTags() {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        labelText: 'Tags',
        hintText: 'Enter tags by seperated by comma',
      ),
      onSaved: (value) {
        if (null != value) {
          _tags = value;
        }
      },
    );
  }

  Widget _buildPrivacy() {
    return Row(
      children: [
        Row(children: [
          Radio<String>(
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
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.only(top: 10),
          child: IconButton(
            icon: Icon(Icons.arrow_left, color: Colors.black),
            onPressed: () => {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => HomePage(),
                ),
              )
            },
          ),
        ),
        title: Padding(
          padding: EdgeInsets.only(top: 10),
          child: SvgPicture.asset(
            'assets/images/default-monochrome.svg',
            height: 30,
          ),
        ),
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
        titleSpacing: 0,
      ),
      body: Container(
        margin: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
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
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(24),
                      child: image != null
                          ? Image.file(image!, width: 160, height: 160)
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                  height: 300,
                ),
                SizedBox(height: 20),
                Text("Enter details about meme below"),
                _buildDescription(),
                _buildTags(),
                // _buildFolderId(),
                SizedBox(height: 20),
                _buildPrivacy(),
                SizedBox(height: 20),
                MaterialButton(
                  color: Colors.black,
                  textColor: Colors.white,
                  child: Text("Publish"),
                  onPressed: () => addPost(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

PostMeme postMeme = PostMeme();
