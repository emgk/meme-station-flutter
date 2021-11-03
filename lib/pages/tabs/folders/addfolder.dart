// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, prefer_final_fields
import 'package:flutter/material.dart';
import 'package:memestation/services/api_service.dart';
import 'package:memestation/shared/formui.dart';

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

  Widget _buildTitle() {
    return FormInput(
      label: "Title",
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
    );
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
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            _buildTitle(),
            SizedBox(height: 20),
            _buildDescription(),
            // _buildFolderId(),
            SizedBox(height: 20),
            _buildPrivacy(),
            SizedBox(height: 20),
            FormButton(
              label: "Publish",
              onClick: addPost,
            )
          ],
        ),
      ),
    );
  }
}

AddFolder postMeme = AddFolder();
