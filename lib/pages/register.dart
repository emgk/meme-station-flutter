// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:memestation/pages/login.dart';
import 'package:memestation/services/api_service.dart';
import 'package:memestation/shared/formui.dart';

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

        _formKey.currentState!.reset();
        Navigator.of(context).pop();
      }
    }).catchError((e) {
      _formKey.currentState!.reset();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create account, please try again!'),
        ),
      );
    });
  }

  Widget _nameField() {
    return FormInput(
      label: "Name",
      child: TextFormField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 20),
          border: InputBorder.none,
          hintText: 'Eg. John doe',
        ),
        keyboardType: TextInputType.multiline,
        validator: (value) {
          if (null == value) {
            return 'Name is required';
          }
        },
        onSaved: (value) {
          if (null != value) {
            _name = value;
          }
        },
      ),
    );
  }

  Widget _passwordField() {
    return FormInput(
      label: "Password",
      child: TextFormField(
        obscureText: true,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 20),
          border: InputBorder.none,
        ),
        keyboardType: TextInputType.multiline,
        validator: (value) {
          if (null == value) {
            return 'Password is required';
          }
        },
        onSaved: (value) {
          if (null != value) {
            _password = value;
          }
        },
      ),
    );
  }

  Widget _emailField() {
    return FormInput(
      label: "Email",
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 20),
          border: InputBorder.none,
        ),
        validator: (value) {
          if (null == value) {
            return 'Email is required';
          }
        },
        onSaved: (value) {
          if (null != value) {
            _email = value;
          }
        },
      ),
    );
  }

  Widget _genderField() {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        children: [
          Row(children: [
            Radio<String>(
              fillColor: MaterialStateColor.resolveWith(
                  (states) => Colors.orangeAccent),
              value: 'male',
              groupValue: _gender,
              onChanged: (privacy) {
                setState(() {
                  privacy = privacy;
                });
              },
            ),
            Text(
              "Male",
              style: TextStyle(color: Colors.orangeAccent),
            ),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Radio<String>(
              fillColor: MaterialStateColor.resolveWith(
                  (states) => Colors.orangeAccent),
              value: 'female',
              groupValue: _gender,
              onChanged: (privacy) {
                setState(() {
                  privacy = privacy;
                });
              },
            ),
            Text(
              "Female",
              style: TextStyle(color: Colors.orangeAccent),
            ),
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
            _nameField(),
            SizedBox(height: 20),
            _emailField(),
            SizedBox(height: 20),
            _passwordField(),
            SizedBox(height: 20),
            _genderField(),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: InkWell(
                onTap: () => registerUser(),
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
                    'Create',
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
              ),
            )
          ],
        ),
      ),
    );
  }

  void registerPopup(context) {
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
                child: Column(children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Create an account",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Please enter details below",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            _formKey.currentState!.reset();
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.close_sharp,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(height: 20),
                              _nameField(),
                              SizedBox(height: 20),
                              _emailField(),
                              SizedBox(height: 20),
                              _passwordField(),
                              SizedBox(height: 20),
                              _genderField(),
                              SizedBox(height: 20),
                              Padding(
                                padding: EdgeInsets.only(left: 20, right: 20),
                                child: InkWell(
                                  onTap: () => registerUser(),
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
                                      'Create',
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
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ]),
              );
            },
          ),
        );
      },
    );
  }
}

Register postMeme = Register();
