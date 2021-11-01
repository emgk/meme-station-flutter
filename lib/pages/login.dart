// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:memestation/constants/strings.dart';
import 'package:memestation/pages/homepage.dart';
import 'package:memestation/pages/register.dart';
import 'package:memestation/services/api_service.dart';
import 'package:memestation/util/secure_storage.dart';

class Login extends StatefulWidget {
  @override
  _LoginStates createState() => _LoginStates();
}

class _LoginStates extends State<Login> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  final storage = new FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image(
            image: AssetImage("assets/images/login-bg.jpg"),
            fit: BoxFit.cover,
            color: Colors.black87,
            colorBlendMode: BlendMode.darken,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlutterLogo(
                size: 100,
              ),
              Form(
                child: Theme(
                  data: ThemeData(
                    brightness: Brightness.dark,
                    primarySwatch: Colors.teal,
                    inputDecorationTheme: InputDecorationTheme(
                      labelStyle: TextStyle(
                        color: Colors.teal,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: "Enter Email",
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            labelText: "Enter Password",
                          ),
                          keyboardType: TextInputType.text,
                          obscureText: true,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MaterialButton(
                              color: Colors.blueGrey,
                              textColor: Colors.white,
                              child: Text("Login"),
                              onPressed: () => {doLogin()},
                            ),
                            MaterialButton(
                              color: Colors.black87,
                              textColor: Colors.white,
                              child: Text("Register"),
                              onPressed: () => {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (_) => Register()),
                                )
                              },
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> doLogin() async {
    if (passwordController.text.isNotEmpty && emailController.text.isNotEmpty) {
      // API request
      await APIService.login(
        emailController.text,
        passwordController.text,
      ).then((response) {
        if (response!.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Logged in succesfully!'),
            ),
          );

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => HomePage()),
          );
        }
      }).catchError((e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid credentials!'),
          ),
        );
      });
    }
  }
}

Login login = Login();
