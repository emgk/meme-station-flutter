// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, prefer_final_fields
import 'package:flutter/material.dart';
import 'package:memestation/pages/tabs/folders/foldersList.dart';
import 'package:memestation/services/api_service.dart';

class AddFolder extends StatefulWidget {
  @override
  _AddFolderState createState() => _AddFolderState();
}

class _AddFolderState extends State<AddFolder> {
  String? _title = '';
  String? _description = '';
  String? _privacy = 'public';
  int _userId = 1;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  Future addPost() async {
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
        'title': _title,
        'description': _description,
        'userId': user.id,
        'privacy': _privacy,
      };

      // API request
      await APIService.addFolder(
        output,
      ).then((response) {
        if (response!.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Folder created succesfully!"),
            ),
          );
        }

        _formKey.currentState!.reset();
        Navigator.of(context).pop();
      }).catchError((e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Something went wrong, please try again!'),
          ),
        );

        _formKey.currentState!.reset();
        Navigator.of(context).pop();
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

  Widget _buildTitle() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Title",
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
                hintText: 'Eg. Dank memes',
              ),
              keyboardType: TextInputType.multiline,
              validator: (value) {
                if (null == value) {
                  return 'Title is required';
                }
              },
              onSaved: (value) {
                if (null != value) {
                  _title = value;
                }
              },
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
    return IconButton(
      icon: Icon(Icons.add_rounded, color: Colors.white),
      onPressed: () {
        addFolder(context);
      },
    );
  }

  void addFolder(context) {
    showModalBottomSheet(
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
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                padding: EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Create a folder",
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
                                SizedBox(height: 15),
                              ],
                            ),
                            IconButton(
                              onPressed: () {
                                _formKey.currentState!.reset();
                                Navigator.of(context).pop();
                              },
                              icon: Icon(
                                Icons.close_sharp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        _buildTitle(),
                        SizedBox(height: 20),
                        _buildDescription(),
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
                              'Publish',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orangeAccent,
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
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

AddFolder postMeme = AddFolder();
