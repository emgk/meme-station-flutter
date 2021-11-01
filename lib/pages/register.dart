// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memestation/pages/homepage.dart';
import 'package:memestation/pages/login.dart';
import 'package:memestation/services/api_service.dart';
import 'package:memestation/util/notice.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String? _name = '';
  String? _email = '';
  String? _gender = 'male';
  String? _password = '';
  // String? _city = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  Future registerUser() async {
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
      'name': _name,
      'email': _email,
      'gender': _gender,
      'password': _password,
    };

    // API request
    await APIService.register(output).then((response) {
      if (response!.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Account registered succefully!'),
          ),
        );

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => Login()),
        );
      }
    }).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create account, please try again!'),
        ),
      );
    });
  }

  Widget _nameField() {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        labelText: 'Name',
      ),
      onSaved: (value) {
        if (null != value) {
          _name = value;
        }
      },
    );
  }

  Widget _passwordField() {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        labelText: 'Password',
      ),
      onSaved: (value) {
        if (null != value) {
          _password = value;
        }
      },
    );
  }

  Widget _emailField() {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        labelText: 'Email',
      ),
      onSaved: (value) {
        if (null != value) {
          _email = value;
        }
      },
    );
  }

  Widget _genderField() {
    return Row(
      children: [
        Row(children: [
          Radio<String>(
            value: 'male',
            groupValue: _gender,
            onChanged: (privacy) {
              setState(() {
                _gender = privacy;
              });
            },
          ),
          Text("Male"),
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Radio<String>(
            value: 'female',
            groupValue: _gender,
            onChanged: (privacy) {
              setState(() {
                _gender = privacy;
              });
            },
          ),
          Text("Female"),
        ]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_left),
          onPressed: () => {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => Login(),
              ),
            )
          },
        ),
        title: Text("Create new account"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueGrey, Colors.blueGrey.shade800],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _nameField(),
                _emailField(),
                _passwordField(),
                SizedBox(height: 20),
                _genderField(),
                MaterialButton(
                  color: Colors.blueGrey,
                  textColor: Colors.white,
                  child: Text("Create"),
                  onPressed: () => registerUser(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Register postMeme = Register();
