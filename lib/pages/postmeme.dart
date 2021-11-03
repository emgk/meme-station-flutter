// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memestation/entities/jsonMap.dart';
import 'package:memestation/services/api_service.dart';
import 'package:memestation/shared/formui.dart';
import 'package:memestation/shared/pickfolder.dart';

class PostMeme extends StatefulWidget {
  @override
  _PostMemeState createState() => _PostMemeState();
}

class _PostMemeState extends State<PostMeme> {
  User? user;
  Folder? seelectedFolder;
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

      image = File(pic.path);

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
      'folderId': seelectedFolder!.id,
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
      seelectedFolder = null;
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
      seelectedFolder = null;
      _formKey.currentState!.reset();
      Navigator.of(context).pop();

      setState(() {
        _isSubmitting = false;
      });
    });
  }

  Widget _buildDescription() {
    return FormInput(
      label: "Description",
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
    );
  }

  Widget _buildTags() {
    return FormInput(
      label: "Tags",
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
    );
  }

  Widget _selectFolder() {
    if (null == seelectedFolder) {
      return FormInput(
        label: "Folder",
        child: Row(
          children: [
            InkWell(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.folder,
                      size: 30.0,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 5),
                    Text("Please select folder"),
                  ],
                ),
              ),
              onTap: () {
                if (null != user) {
                  folderPicker(context, user!.folders, (data) {
                    setState(() {
                      seelectedFolder = data;
                    });
                  });
                }
                _formKey.currentState!.reassemble();
              },
            ),
          ],
        ),
      );
    }

    return FormInput(
      label: "Tags",
      child: Row(
        children: [
          InkWell(
            onTap: () {
              if (null != user) {
                folderPicker(context, user!.folders, (data) {
                  setState(() {
                    seelectedFolder = data;
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
                      seelectedFolder!.title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      seelectedFolder!.description,
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
    );
  }

  Widget _buildPrivacy() {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        children: [
          Row(children: [
            Radio<String>(
              fillColor: MaterialStateColor.resolveWith(
                  (states) => Colors.orangeAccent),
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
              fillColor: MaterialStateColor.resolveWith(
                  (states) => Colors.orangeAccent),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 15),
          SizedBox(
            child: InkWell(
              child: Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                  color: Colors.white54,
                  borderRadius: BorderRadius.circular(20),
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                    top: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                    right: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                    left: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                ),
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
          FormButton(label: "Post", onClick: addPost)
        ],
      ),
    );
  }
}

PostMeme postMeme = PostMeme();
